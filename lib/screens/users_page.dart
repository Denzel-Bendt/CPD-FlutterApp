import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'dart:convert';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  UsersPageState createState() => UsersPageState();  // Geen underscore hier
}

class UsersPageState extends State<UsersPage> {  // Geen underscore hier
  final ApiService apiService = ApiService();
  List<dynamic> users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final response = await apiService.getAllUsers();

    // Controleer of de widget nog "mounted" is om BuildContext veilig te gebruiken
    if (mounted) {
      if (response.statusCode == 200) {
        setState(() {
          users = json.decode(response.body)['data'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fout bij het ophalen van gebruikers: ${response.body}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gebruikerslijst'),
      ),
      body: users.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text(user['name']),
                  subtitle: Text('ID: ${user['id']}'),
                );
              },
            ),
    );
  }
}
