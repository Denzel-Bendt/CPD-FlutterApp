// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import 'package:cpd_flutterapp/services/api_service.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  EventsPageState createState() => EventsPageState();
}

class EventsPageState extends State<EventsPage> {
  final ApiService _apiService = ApiService();
  Map<DateTime, List<String>> _events = {};
  List<dynamic> _teams = []; // Teams ophalen
  int? _selectedTeamId; // Geselecteerd team
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTeams(); // Teams ophalen
    _fetchEvents(); // Evenementen ophalen
  }

  Future<void> _fetchTeams() async {
    try {
      final response = await _apiService.getTeams();
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        setState(() {
          _teams = data;
          _selectedTeamId = _teams.isNotEmpty ? _teams.first['id'] : null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fout bij ophalen teams: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fout bij ophalen teams: $e')),
      );
    }
  }

  Future<void> _fetchEvents() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await _apiService.getAllEvents();
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        Map<DateTime, List<String>> events = {};
        for (var event in data) {
          final DateTime date = DateTime.parse(event['datetimeStart']);
          final String title = event['title'];
          if (events[date] == null) {
            events[date] = [title];
          } else {
            events[date]!.add(title);
          }
        }
        setState(() {
          _events = events;
          isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fout bij ophalen evenementen: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fout: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _addEvent(String title) async {
    if (_selectedTeamId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecteer eerst een team.')),
      );
      return;
    }

    try {
      final DateTime startTime = _selectedDay ?? _focusedDay;
      final DateTime endTime = startTime.add(const Duration(hours: 1));
      final response = await _apiService.createEvent(
        title: title,
        description: 'Automatisch toegevoegd evenement',
        datetimeStart: startTime.toIso8601String(),
        datetimeEnd: endTime.toIso8601String(),
        teamId: _selectedTeamId!,
        location: {'latitude': 0.0, 'longitude': 0.0},
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Evenement succesvol toegevoegd!')),
        );
        _fetchEvents();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fout bij toevoegen evenement: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fout: $e')),
      );
    }
  }

  List<String> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evenementen'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Dropdown voor team selectie
                DropdownButton<int>(
                  value: _selectedTeamId,
                  items: _teams.map((team) {
                    return DropdownMenuItem<int>(
                      value: team['id'],
                      child: Text(team['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTeamId = value;
                    });
                  },
                  hint: const Text('Selecteer een team'),
                ),
                TableCalendar(
                  focusedDay: _focusedDay,
                  firstDay: DateTime(2000),
                  lastDay: DateTime(2100),
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  eventLoader: _getEventsForDay,
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                ),
                Expanded(
                  child: ListView(
                    children: _getEventsForDay(_selectedDay ?? _focusedDay)
                        .map((event) => ListTile(
                              title: Text(event),
                              leading: const Icon(Icons.event),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String? newEvent = await showDialog<String>(
            context: context,
            builder: (context) {
              final TextEditingController controller = TextEditingController();
              return AlertDialog(
                title: const Text('Nieuw evenement toevoegen'),
                content: TextField(
                  controller: controller,
                  decoration: const InputDecoration(hintText: 'Evenement naam'),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, null),
                    child: const Text('Annuleer'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, controller.text),
                    child: const Text('Voeg toe'),
                  ),
                ],
              );
            },
          );
          if (newEvent != null && newEvent.isNotEmpty) {
            _addEvent(newEvent);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
