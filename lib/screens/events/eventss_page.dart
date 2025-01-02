import 'package:flutter/material.dart';

class EventssPage extends StatelessWidget {
  const EventssPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Evenementen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('aankomende Events'),
            const SizedBox(
                height: 20), // Add some space between the text and the button
            ElevatedButton(
              onPressed: () {
                // Navigate to the AddEventPage when the button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddEventPage()),
                );
              },
              child: const Text('evenement toevoegen'),
            ),
          ],
        ),
      ),
    );
  }
}

class AddEventPage extends StatelessWidget {
  const AddEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voeg Evenement Toe')),
      body: Center(
        child: const Text('Hier kun je een evenement toevoegen.'),
      ),
    );
  }
}
