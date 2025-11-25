import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cpd_flutterapp/services/api_service.dart';



class UsersPage extends StatefulWidget {
  final int teamId;

  const UsersPage({super.key, required this.teamId});

  @override
  UsersPageState createState() => UsersPageState();
}

class UsersPageState extends State<UsersPage> {
  final ApiService apiService = ApiService();
  List<dynamic> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await apiService.getAllUsers();

      if (!mounted) return;

      if (response.statusCode == 200) {
        setState(() {
          users = json.decode(response.body)['data'];
          isLoading = false;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Fout bij ophalen gebruikers: ${response.body}')),
          );
        }
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Er is een fout opgetreden: $e')),
        );
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _addUserToTeam(int userId) async {
    try {
      final response = await apiService.addUserToTeam(widget.teamId, userId);

      if (!mounted) return;

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gebruiker toegevoegd aan team!')),
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Fout: ${response.body}')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Er is een fout opgetreden: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gebruikerslijst'),
        backgroundColor: Colors.blueAccent, // Aanpassing aan de kleur
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.grey),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      user['name'][0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    user['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('ID: ${user['id']}'),
                  trailing: ElevatedButton(
                    onPressed: () => _addUserToTeam(user['id']),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Kleur aanpassen
                    ),
                    child: const Text('Toevoegen'),
                  ),
                );
              },
            ),
    );
  }
}
