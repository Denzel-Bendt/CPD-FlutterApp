// matches_page.dart
import 'package:flutter/material.dart';

class MatchesPage extends StatefulWidget {
  const MatchesPage({super.key});

  @override
  State<MatchesPage> createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matches'),
      ),
      body: const Center(
        child: Text(
          'Welkom op de Matches Pagina!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
