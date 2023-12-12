// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/game_details_page.dart';

void main() {
  runApp(const MyApp());
}

class Team {
  final int teamId; // Unique team identifier
  final String abbreviation;
  final String city;

  Team({
    required this.teamId,
    required this.abbreviation,
    required this.city,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NBA Teams',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Team> teams = [];

  @override
  void initState() {
    super.initState();
    getTeams();
  }

  Future<void> getTeams() async {
    try {
      var response =
          await http.get(Uri.https('balldontlie.io', 'api/v1/teams'));
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          for (var eachTeam in jsonData['data']) {
            final team = Team(
              teamId: eachTeam['id'],
              abbreviation: eachTeam['abbreviation'],
              city: eachTeam['city'],
            );
            teams.add(team);
          }
        });
      } else {
        throw Exception('Failed to load teams');
      }
    } catch (e) {
      print('Error fetching teams: $e');
    }
  }

  String getTeamLogoAsset(String abbreviation) {
  switch (abbreviation) {
    case 'BOS':
      return 'assets/team_logos/BOS.png';
    case 'BKN':
      return 'assets/team_logos/BKN.png';
    case 'NYK':
      return 'assets/team_logos/NYK.png';
    // Add cases for other teams
    case 'PHI':
      return 'assets/team_logos/PHI.png';
    case 'TOR':
      return 'assets/team_logos/TOR.png';
    case 'CHI':
      return 'assets/team_logos/CHI.png';
    case 'CLE':
      return 'assets/team_logos/CLE.png';
    case 'DET':
      return 'assets/team_logos/DET.png';
    case 'IND':
      return 'assets/team_logos/IND.png';
    case 'MIL':
      return 'assets/team_logos/MIL.png';
    case 'ATL':
      return 'assets/team_logos/ATL.png';
    case 'CHA':
      return 'assets/team_logos/CHA.png';
    case 'MIA':
      return 'assets/team_logos/MIA.png';
    case 'ORL':
      return 'assets/team_logos/ORL.png';
    case 'WAS':
      return 'assets/team_logos/WAS.png';
    case 'DEN':
      return 'assets/team_logos/DEN.png';
    case 'MIN':
      return 'assets/team_logos/MIN.png';
    case 'OKC':
      return 'assets/team_logos/OKC.png';
    case 'POR':
      return 'assets/team_logos/POR.png';
    case 'UTA':
      return 'assets/team_logos/UTA.png';
    case 'GSW':
      return 'assets/team_logos/GSW.png';
    case 'LAC':
      return 'assets/team_logos/LAC.png';
    case 'LAL':
      return 'assets/team_logos/LAL.png';
    case 'PHX':
      return 'assets/team_logos/PHX.png';
    case 'SAC':
      return 'assets/team_logos/SAC.png';
    case 'DAL':
      return 'assets/team_logos/DAL.png';
    case 'HOU':
      return 'assets/team_logos/HOU.png';
    case 'MEM':
      return 'assets/team_logos/MEM.png';
    case 'NOP':
      return 'assets/team_logos/NOP.png';
    case 'SAS':
      return 'assets/team_logos/SAS.png';
    default:
      return 'assets/default_logo.png';
  }
}

  Future<List<dynamic>> fetchGames(int teamId) async {
    try {
      var startDate = '2023-10-24';
      var endDate = '2024-06-01';

      var response = await http.get(
        Uri.https(
          'balldontlie.io',
          'api/v1/games',
          {
            'team_ids[]': '$teamId',
            'per_page': '82',
            'start_date': startDate,
            'end_date': endDate,
          },
        ),
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        return jsonData['data'];
      } else {
        throw Exception('Failed to load past games for the selected team');
      }
    } catch (e) {
      print('Error fetching past games: $e');
      return [];
    }
  }

  void navigateToGameDetails(int teamId) async {
    try {
      List<dynamic> allGames = await fetchGames(teamId);
      allGames.sort((a, b) => a['date'].compareTo(b['date']));

      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameDetailsPage(pastGames: allGames, selectedTeamId: teamId),
        ),
      );
    } catch (e) {
      print('Error navigating to game details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NBA Teams',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: teams.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: teams.length,
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              navigateToGameDetails(teams[index].teamId);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListTile(
                                leading: Image.asset(
                                  getTeamLogoAsset(teams[index].abbreviation),
                                ),
                                title: Text(teams[index].abbreviation),
                                subtitle: Text(teams[index].city),
                                trailing: const Icon(Icons.arrow_forward_ios),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
