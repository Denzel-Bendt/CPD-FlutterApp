import 'package:flutter/material.dart';
import 'package:cpd_flutterapp/services/api_service.dart';

class TeamDetailsPage extends StatefulWidget {
  final int teamId;

  const TeamDetailsPage({required this.teamId, super.key});

  @override
  TeamDetailsPageState createState() => TeamDetailsPageState();
}

class TeamDetailsPageState extends State<TeamDetailsPage> {
  final ApiService apiService = ApiService();
  Map<String, dynamic>? teamDetails;
  final TextEditingController _userIdController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTeamDetails();
  }

  Future<void> _fetchTeamDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      final Map<String, dynamic>? response = await apiService.getTeamDetails(widget.teamId);

      if (!mounted) return;

      if (response != null) {
        setState(() {
          teamDetails = response;
          isLoading = false;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fout bij ophalen teamdetails')),
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

  Future<void> _addUserToTeam() async {
    final String userIdText = _userIdController.text;

    if (userIdText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gebruiker ID mag niet leeg zijn.')),
      );
      return;
    }

    final int userId = int.tryParse(userIdText) ?? -1;
    if (userId <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ongeldig gebruiker ID.')),
      );
      return;
    }

    try {
      final response = await apiService.addUserToTeam(widget.teamId, userId);

      if (!mounted) return; // Controleer of de widget nog bestaat

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gebruiker toegevoegd aan team!')),
        );
        await _fetchTeamDetails(); // Herlaad teamdetails
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fout bij toevoegen gebruiker: ${response.body}')),
        );
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
      appBar: AppBar(title: const Text('Team Details')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Text(
                  'Teamnaam: ${teamDetails?['name'] ?? 'Onbekend'}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text('Beschrijving: ${teamDetails?['description'] ?? 'Geen beschrijving'}'),
                const Divider(),
                const Text('Leden:'),
                if (teamDetails?['members'] != null)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: (teamDetails!['members'] as List).length,
                    itemBuilder: (context, index) {
                      final member = (teamDetails!['members'] as List)[index];
                      return ListTile(
                        title: Text(member['name']),
                        subtitle: Text('ID: ${member['id']}'),
                      );
                    },
                  )
                else
                  const Text('Geen leden beschikbaar.'),
                const SizedBox(height: 20),
                TextField(
                  controller: _userIdController,
                  decoration: const InputDecoration(labelText: 'Voer Gebruiker ID in'),
                  keyboardType: TextInputType.number,
                ),
                ElevatedButton(
                  onPressed: _addUserToTeam,
                  child: const Text('Voeg gebruiker toe'),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _userIdController.dispose();
    super.dispose();
  }
}
