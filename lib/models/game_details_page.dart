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
          if (homeTeamId == selectedTeamId &&
              homeTeamScore > visitorTeamScore) {
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

    String teamName =
        getTeamNameById(selectedTeamId); // Get team name based on ID

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Schedule', // Display the team's name in the AppBar title
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  teamName, // Display the team's name at the top of the screen
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Record: $wins - $losses', // Display the team's record
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
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
                final status = pastGames[index]['status']; // New status attribute

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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Status: $status',
                                style: TextStyle(
                                  color: status == 'Final'
                                      ? Colors.red
                                      : Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${pastGames[index]['home_team']['abbreviation']} $homeTeamScore - ${pastGames[index]['visitor_team']['abbreviation']} $visitorTeamScore',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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

  // Function to get team name based on team ID (Replace with your own logic)
  String getTeamNameById(int teamId) {
    // Replace this logic with your actual implementation to fetch team names by ID
    switch (teamId) {
      case 1:
        return 'Atlanta Hawks';
      case 2:
        return 'Boston Celtics';
      case 3:
        return 'Brooklyn Nets';
      case 4:
        return 'Charlotte Hornets';
      case 5:
        return 'Chicago Bulls';
      case 6:
        return 'Cleveland Cavaliers';
      case 7:
        return 'Dallas Mavericks';
      case 8:
        return 'Denver Nuggets';
      case 9:
        return 'Detroit Pistons';
      case 10:
        return 'Golden State Warriors';
      case 11:
        return 'Houston Rockets';
      case 12:
        return 'Indiana Pacers';
      case 13:
        return 'Los Angeles Clippers';
      case 14:
        return 'Los Angeles Lakers';
      case 15:
        return 'Memphis Grizzlies';
      case 16:
        return 'Miami Heat';
      case 17:
        return 'Milwaukee Bucks';
      case 18:
        return 'Minnesota Timberwolves';
      case 19:
        return 'New Orleans Pelicans';
      case 20:
        return 'New York Knicks';
      case 21:
        return 'Oklahoma City Thunder';
      case 22:
        return 'Orlando Magic';


      case 23:
        return 'Philadelphia 76ers';
      case 24:
        return 'Phoenix Suns';
      case 25:
        return 'Portland Trail Blazers';
      case 26:
        return 'Sacramento Kings';
      case 27:
        return 'San Antonio Spurs';
      case 28:
        return 'Toronto Raptors';
      case 29:
        return 'Utah Jazz';
      case 30:
        return 'Washington Wizards';
      default:
        return 'Unknown Team';

    }
  }
}
