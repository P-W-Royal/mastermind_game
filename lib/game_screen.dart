import 'dart:async';

import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  final String level;

  const GameScreen({Key? key, required this.level}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int score = 0;
  int remainingTime = 0;
  List<String> words = [
    'apple',
    'banana',
    'cherry',
    'grape',
    'orange',
  ];
  int currentWordIndex = 0;
  TextEditingController inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    switch (widget.level) {
      case 'Easy':
        setState(() {
          remainingTime = 120;
        });
        break;
      case 'Medium':
        setState(() {
          remainingTime = 60;
        });
        break;
      case 'Hard':
        setState(() {
          remainingTime = 30;
        });
        break;
    }

    // Timer countdown logic
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (timer) {
      if (remainingTime == 0) {
        timer.cancel();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Game Over'),
              content: Text('Your final score: $score'),
              actions: [
                TextButton(
                  child: Text('Try Again'),
                  onPressed: () {
                    Navigator.pop(context);
                    restartGame();
                  },
                ),
                TextButton(
                  child: Text('Quit'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      } else {
        setState(() {
          remainingTime--;
        });
      }
    });
  }

  void restartGame() {
    setState(() {
      score = 0;
      currentWordIndex = 0;
      inputController.clear();
    });
    startTimer();
  }

  void submitWord() {
    String userInput = inputController.text.trim().toLowerCase();
    String correctWord = words[currentWordIndex].toLowerCase();

    if (userInput == correctWord) {
      setState(() {
        score += 10;
        currentWordIndex++;
        inputController.clear();
      });
    } else {
      setState(() {
        inputController.clear();
      });
    }

    if (currentWordIndex >= words.length) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Game Over'),
            content: Text('Your final score: $score'),
            actions: [
              TextButton(
                child: Text('Try Again'),
                onPressed: () {
                  Navigator.pop(context);
                  restartGame();
                },
              ),
              TextButton(
                child: Text('Quit'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game - ${widget.level}'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Remaining Time: $remainingTime seconds',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Score: $score',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 32),
            Text(
              'Unscramble the word:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 8),
            Text(
              words[currentWordIndex],
              style: TextStyle(fontSize: 32),
            ),
            SizedBox(height: 16),
            TextField(
              controller: inputController,
              decoration: InputDecoration(
                hintText: 'Enter the correct word',
              ),
              onSubmitted: (_) => submitWord(),
            ),
          ],
        ),
      ),
    );
  }
}
