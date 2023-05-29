import 'package:flutter/material.dart';
import 'package:mastermind_game/game_screen.dart';
import 'package:mastermind_game/help_screen.dart';

class LevelsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Level'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Easy'),
              onPressed: () {
                startGame(context, 'Easy');
              },
            ),
            ElevatedButton(
              child: Text('Medium'),
              onPressed: () {
                startGame(context, 'Medium');
              },
            ),
            ElevatedButton(
              child: Text('Hard'),
              onPressed: () {
                startGame(context, 'Hard');
              },
            ),
            ElevatedButton(
              child: Text('Help'),
              onPressed: () {
                navigateToHelpScreen(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void startGame(BuildContext context, String level) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(level: level),
      ),
    );
  }

  void navigateToHelpScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HelpScreen(),
      ),
    );
  }
}
