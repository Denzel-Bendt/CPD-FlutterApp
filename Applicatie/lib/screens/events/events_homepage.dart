// events_homepage.dart
import 'package:flutter/material.dart';

class EventsHomePage extends StatefulWidget {
  const EventsHomePage({super.key});

  @override
  State<EventsHomePage> createState() => _EventsHomePageState();
}

class _EventsHomePageState extends State<EventsHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evenementen Homepage'),
      ),
      body: const Center(
        child: Text(
          'Welkom op de Evenementen Homepage!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
