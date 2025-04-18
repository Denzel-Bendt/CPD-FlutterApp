import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import 'package:cpd_flutterapp/services/api_service.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('EventsPage');

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  EventsPageState createState() => EventsPageState();
}

class EventsPageState extends State<EventsPage> {
  final ApiService _apiService = ApiService();
  Map<DateTime, List<Map<String, dynamic>>> _events = {};
  List<dynamic> _teams = [];
  int? _selectedTeamId;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchTeams();
      _fetchEvents();
    });
  }

  Future<void> _fetchTeams() async {
    try {
      final response = await _apiService.getTeams();
      _logger.info('Teams response: ${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        setState(() {
          _teams = data;
          _selectedTeamId = _teams.isNotEmpty ? _teams.first['id'] : null;
        });
      } else {
        _showSnackBar('Fout bij ophalen teams: ${response.body}');
        _logger.warning('Fout bij ophalen teams: ${response.body}');
      }
    } catch (e) {
      _showSnackBar('Fout bij ophalen teams: $e');
      _logger.severe('Fout bij ophalen teams', e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchEvents() async {
    if (_selectedTeamId == null) {
      _showSnackBar('Selecteer eerst een team.');
      _logger.warning('Geen team geselecteerd bij het ophalen van evenementen.');
      setState(() {
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final combinedEvents = await _apiService.getCombinedEvents(_selectedTeamId!);
      _logger.info('Events response: $combinedEvents');

      Map<DateTime, List<Map<String, dynamic>>> eventsByDate = {};
      for (var event in combinedEvents) {
        final DateTime date = DateTime.parse(event['datetimeStart']).toLocal();
        eventsByDate[DateTime(date.year, date.month, date.day)] ??= [];
        eventsByDate[DateTime(date.year, date.month, date.day)]!.add(event);
      }

      setState(() {
        _events = eventsByDate;
      });
    } catch (e) {
      _showSnackBar('Fout bij ophalen gecombineerde evenementen: $e');
      _logger.severe('Fout bij ophalen gecombineerde evenementen', e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _addEvent(String title) async {
  if (_selectedTeamId == null) {
    _showSnackBar('Selecteer eerst een team.');
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
      _showSnackBar('Evenement succesvol toegevoegd!');
      
      // Direct toevoegen aan lokale _events map
      final newEvent = {
        'id': json.decode(response.body)['id'], // Zorg dat dit de juiste ID is
        'title': title,
        'description': 'Automatisch toegevoegd evenement',
        'datetimeStart': startTime.toIso8601String(),
        'datetimeEnd': endTime.toIso8601String(),
      };

      setState(() {
        _events[DateTime(startTime.year, startTime.month, startTime.day)] ??= [];
        _events[DateTime(startTime.year, startTime.month, startTime.day)]!.add(newEvent);
      });
    } else {
      _showSnackBar('Fout bij toevoegen evenement: ${response.body}');
    }
  } catch (e) {
    _showSnackBar('Fout: $e');
  }
}

  Future<void> _deleteEvent(int eventId) async {
    try {
      final response = await _apiService.deleteEvent(eventId);
      if (response.statusCode == 200) {
        _showSnackBar('Evenement succesvol verwijderd!');
        _fetchEvents();
      } else {
        _showSnackBar('Fout bij verwijderen evenement: ${response.body}');
        _logger.warning('Fout bij verwijderen evenement: ${response.body}');
      }
    } catch (e) {
      _showSnackBar('Fout: $e');
      _logger.severe('Fout bij verwijderen evenement', e);
    }
  }

  Future<void> _editEvent(int eventId, String newTitle) async {
    try {
      final DateTime startTime = _selectedDay ?? _focusedDay;
      final DateTime endTime = startTime.add(const Duration(hours: 1));
      final response = await _apiService.updateEvent(
        id: eventId,
        title: newTitle,
        description: 'Bijgewerkte beschrijving',
        datetimeStart: startTime.toIso8601String(),
        datetimeEnd: endTime.toIso8601String(),
        location: {'latitude': 0.0, 'longitude': 0.0},
      );

      if (response.statusCode == 200) {
        _showSnackBar('Evenement succesvol bijgewerkt!');
        _fetchEvents();
      } else {
        _showSnackBar('Fout bij bewerken evenement: ${response.body}');
        _logger.warning('Fout bij bewerken evenement: ${response.body}');
      }
    } catch (e) {
      _showSnackBar('Fout: $e');
      _logger.severe('Fout bij bewerken evenement', e);
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
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
                      _fetchEvents();
                    });
                  },
                  hint: const Text('Selecteer een team'),
                ),
                TableCalendar(
                  focusedDay: _focusedDay,
                  firstDay: DateTime(2000),
                  lastDay: DateTime(2100),
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  eventLoader: (day) => _getEventsForDay(day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _getEventsForDay(_selectedDay ?? _focusedDay).length,
                    itemBuilder: (context, index) {
                      final event = _getEventsForDay(_selectedDay ?? _focusedDay)[index];
                      return ListTile(
                        title: Text(event['title']),
                        subtitle: Text(event['description'] ?? ''),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () async {
                                final newTitle = await _showEditDialog(event['title']);
                                if (newTitle != null && newTitle.isNotEmpty) {
                                  _editEvent(event['id'], newTitle);
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteEvent(event['id']),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newEventTitle = await _showAddEventDialog();
          if (newEventTitle != null && newEventTitle.isNotEmpty) {
            _addEvent(newEventTitle);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<String?> _showEditDialog(String currentTitle) async {
    final TextEditingController controller = TextEditingController(text: currentTitle);
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Evenement Bewerken'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Nieuwe titel'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Annuleer'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Opslaan'),
            ),
          ],
        );
      },
    );
  }

  Future<String?> _showAddEventDialog() async {
    final TextEditingController controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nieuw Evenement Toevoegen'),
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
              child: const Text('Toevoegen'),
            ),
          ],
        );
      },
    );
  }
}
