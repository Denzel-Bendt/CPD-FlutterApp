// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cpd_flutterapp/services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  Map<DateTime, List<String>> _eventsByDate = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool isLoading = false;
  String? username;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    setState(() {
      isLoading = true;
    });

    // Simulatie van ophalen gebruikersprofiel
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      username = AuthService.username ?? "Onbekend"; // Gebruik AuthService of vervang door echte service
      isLoading = false;
    });
  }

  void _addEvent(String title) {
    final DateTime selectedDate = DateTime(
      (_selectedDay ?? _focusedDay).year,
      (_selectedDay ?? _focusedDay).month,
      (_selectedDay ?? _focusedDay).day,
    );

    setState(() {
      if (_eventsByDate[selectedDate] != null) {
        _eventsByDate[selectedDate]!.add(title);
      } else {
        _eventsByDate[selectedDate] = [title];
      }
    });
  }

  void _editEvent(DateTime date, int index, String newTitle) {
    setState(() {
      _eventsByDate[date]![index] = newTitle;
    });
  }

  void _deleteEvent(DateTime date, int index) {
    setState(() {
      _eventsByDate[date]!.removeAt(index);
      if (_eventsByDate[date]!.isEmpty) {
        _eventsByDate.remove(date);
      }
    });
  }

  List<String> _getEventsForDay(DateTime day) {
    return _eventsByDate[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profiel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welkom, ${username ?? "Gebruiker"}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Jouw afspraken',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
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
                    child: ListView.builder(
                      itemCount: _getEventsForDay(_selectedDay ?? _focusedDay).length,
                      itemBuilder: (context, index) {
                        final event = _getEventsForDay(_selectedDay ?? _focusedDay)[index];
                        final selectedDate = DateTime(
                          (_selectedDay ?? _focusedDay).year,
                          (_selectedDay ?? _focusedDay).month,
                          (_selectedDay ?? _focusedDay).day,
                        );
                        return ListTile(
                          title: Text(event),
                          leading: const Icon(Icons.event),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () async {
                                  final TextEditingController controller =
                                      TextEditingController(text: event);
                                  final newTitle = await showDialog<String>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Evenement Bewerken'),
                                      content: TextField(
                                        controller: controller,
                                        decoration: const InputDecoration(hintText: 'Nieuwe titel'),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Annuleren'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(controller.text);
                                          },
                                          child: const Text('Opslaan'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (newTitle != null && newTitle.isNotEmpty) {
                                    _editEvent(selectedDate, index, newTitle);
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteEvent(selectedDate, index),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final titleController = TextEditingController();
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Nieuw Evenement Toevoegen'),
              content: TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'Titel'),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Annuleren'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (titleController.text.isNotEmpty) {
                      _addEvent(titleController.text);
                    }
                  },
                  child: const Text('Toevoegen'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
