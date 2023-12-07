import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GameStatsPage extends StatefulWidget {
  final dynamic gameData; // Data for the selected game

  const GameStatsPage({Key? key, required this.gameData}) : super(key: key);

  @override
  _GameStatsPageState createState() => _GameStatsPageState();
}

class _GameStatsPageState extends State<GameStatsPage> {
  late List<dynamic> allPlayerStats;
  late List<dynamic> teamAStats;
  late List<dynamic> teamBStats;

  @override
  void initState() {
    super.initState();
    allPlayerStats = [];
    teamAStats = [];
    teamBStats = [];
    fetchPlayerStats();
  }

  Future<void> fetchPlayerStats() async {
    try {
      int gameId = widget.gameData['id']; // Extract game ID from gameData

      final response = await http.get(
        Uri.https('www.balldontlie.io', 'api/v1/stats', {'game_ids[]': '$gameId'}),
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        setState(() {
          allPlayerStats = jsonData['data'];
          teamAStats = getPlayerStatsForTeam(widget.gameData['home_team']['full_name']);
          teamBStats = getPlayerStatsForTeam(widget.gameData['visitor_team']['full_name']);
        });
      } else {
        throw Exception('Failed to load player stats for the selected game');
      }
    } catch (error) {
      print('Error fetching player stats: $error');
    }
  }

  List<dynamic> getPlayerStatsForTeam(String teamName) {
    return allPlayerStats.where((playerStat) {
      return playerStat['team']['full_name'] == teamName;
    }).toList();
  }

Widget buildPlayerStats(dynamic playerStat) {
  String playerName = playerStat['player']['first_name'] + ' ' + playerStat['player']['last_name'];
  int pointsScored = playerStat['pts'] ?? 0;
  int assists = playerStat['ast'] ?? 0;
  int rebounds = playerStat['reb'] ?? 0;
  String playerImageURL = playerStat['player']['image_url'] ?? ''; // Replace 'image_url' with the actual field from API

    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Player image
            playerImageURL.isNotEmpty
                ? CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(playerImageURL),
                  )
                : CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey,
                    // Placeholder if image URL is not available
                  ),
            SizedBox(width: 16),
            // Player stats
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$playerName',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  SizedBox(height: 8),
                  Text('Points: $pointsScored'),
                  SizedBox(height: 8),
                  Text('Assists: $assists'),
                  SizedBox(height: 8),
                  Text('Rebounds: $rebounds'),
                  // ... add other stats
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String teamAName = widget.gameData['home_team']['full_name'];
    String teamBName = widget.gameData['visitor_team']['full_name'];

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text('Player Stats for the Game', 
        style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select a Team:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      allPlayerStats = teamAStats;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    minimumSize: Size(150, 50),
                  ),
                  child: Text(
                    teamAName,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      allPlayerStats = teamBStats;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    minimumSize: Size(150, 50),
                  ),
                  child: Text(
                    teamBName,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: allPlayerStats.length,
                itemBuilder: (context, index) {
                  return buildPlayerStats(allPlayerStats[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
