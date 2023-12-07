import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:httpapp/models/game_stats_page.dart';

class GameDetailsPage extends StatelessWidget {
  final List<dynamic> pastGames;
  final int selectedTeamId; // ID of the selected team

  const GameDetailsPage({
    Key? key,
    required this.pastGames,
    required this.selectedTeamId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int wins = 0;
    int losses = 0;

    for (var game in pastGames) {
      final homeTeamId = game['home_team']['id'];
      final visitorTeamId = game['visitor_team']['id'];

      if (game['home_team_score'] != null &&
          game['visitor_team_score'] != null &&
          (game['home_team_score'] != 0 || game['visitor_team_score'] != 0)) {
        final homeTeamScore = game['home_team_score'];
        final visitorTeamScore = game['visitor_team_score'];

        if ((homeTeamId == selectedTeamId || visitorTeamId == selectedTeamId)) {
          if (homeTeamId == selectedTeamId && homeTeamScore > visitorTeamScore) {
            wins++;
          } else if (visitorTeamId == selectedTeamId &&
              visitorTeamScore > homeTeamScore) {
            wins++;
          } else {
            losses++;
          }
        }
      }
    }

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Record: $wins - $losses',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: pastGames.length,
              itemBuilder: (context, index) {
                final homeTeamId = pastGames[index]['home_team']['id'];
                final visitorTeamId = pastGames[index]['visitor_team']['id'];
                final homeTeamScore = pastGames[index]['home_team_score'];
                final visitorTeamScore = pastGames[index]['visitor_team_score'];

                Color borderColor = Colors.blue;

                if ((homeTeamId == selectedTeamId ||
                        visitorTeamId == selectedTeamId) &&
                    homeTeamScore != null &&
                    visitorTeamScore != null &&
                    (homeTeamScore != 0 || visitorTeamScore != 0)) {
                  if (homeTeamId == selectedTeamId &&
                      homeTeamScore > visitorTeamScore) {
                    borderColor = Colors.green;
                  } else if (visitorTeamId == selectedTeamId &&
                      visitorTeamScore > homeTeamScore) {
                    borderColor = Colors.green;
                  } else {
                    borderColor = Colors.red;
                  }
                }

                return ListTile(
                  title: Text('Game ${index + 1}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          navigateToGameStats(context, pastGames[index]);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: borderColor,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            '${pastGames[index]['home_team']['abbreviation']} $homeTeamScore - ${pastGames[index]['visitor_team']['abbreviation']} $visitorTeamScore',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'Date: ${DateFormat('MMMM dd, yyyy').format(DateTime.parse(pastGames[index]['date']))}',
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void navigateToGameStats(BuildContext context, dynamic gameData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameStatsPage(gameData: gameData),
      ),
    );
  }
}
