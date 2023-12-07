import 'package:flutter/material.dart';
import 'package:httpapp/models/game_stats_page.dart';
import 'package:intl/intl.dart';

class GameDetailsPage extends StatelessWidget {
  final List<dynamic> pastGames;

  const GameDetailsPage({Key? key, required this.pastGames}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_print
    print(GameDetailsPage(pastGames: pastGames));
    // print('Past Games: $pastGames');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Schedule',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: pastGames.length,
        itemBuilder: (context, index) {
          final homeTeamScore = pastGames[index]['home_team_score'];
          final visitorTeamScore = pastGames[index]['visitor_team_score'];
          final isHomeTeamWinner = homeTeamScore > visitorTeamScore;
          final isVisitorTeamWinner = visitorTeamScore > homeTeamScore;

          Color borderColor = Colors.blue;
          if (isHomeTeamWinner) {
            borderColor = Colors.green;
          } else if (isVisitorTeamWinner) {
            borderColor = Colors.red;
          }

          return ListTile(
            title: Text('Game ${index + 1}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigate to stats page when the score is tapped
                    navigateToGameStats(context, pastGames[index]);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: borderColor, // Border color
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      '${pastGames[index]['home_team']['abbreviation']} $homeTeamScore - ${pastGames[index]['visitor_team']['abbreviation']} $visitorTeamScore',
                      style: const TextStyle(
                        color: Colors.blue, // Text color
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Text(
                  'Date: ${DateFormat('MMMM dd, yyyy').format(DateTime.parse(pastGames[index]['date']))}',
                ),
                // Add more details as needed
              ],
            ),
          );
        },
      ),
    );
  }

  void navigateToGameStats(BuildContext context, dynamic gameData) {
    // Navigate to the GameStatsPage with the selected game data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameStatsPage(gameData: gameData),
      ),
    );
  }
}
