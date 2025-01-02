import 'package:flutter/material.dart'; 

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
