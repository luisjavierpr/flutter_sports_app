import 'package:flutter/material.dart';

class GameStatsPage extends StatelessWidget {
  final dynamic gameData;

  const GameStatsPage({Key? key, required this.gameData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Stats'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Game Stats for ${gameData['home_team']} vs ${gameData['visitor_team']}'), // Replace with actual team names
            SizedBox(height: 20),
            // Display game stats here based on gameData
            // Example: Text('Stat 1: ${gameData['stat_1']}'),
            //          Text('Stat 2: ${gameData['stat_2']}'),
            //          ...
          ],
        ),
      ),
    );
  }
}
