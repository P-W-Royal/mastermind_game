import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MasterMindApp());
}

class MasterMindApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Master Mind',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Master Mind',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Level level = Level.easy; // Added level variable and set default to easy
  int score = 0;
  int remainingTime = Level.easy.duration; // Updated to use the level's duration

  String jumbledWord = '';
  String userAnswer = '';

  Map<String, String> hints = {
    'apple': 'A fruit',
    'table': 'Used for eating',
    'car': 'A vehicle',
  };

  List<String> easyWords = ['apple', 'banana', 'grape'];
  List<String> mediumWords = ['table', 'chair', 'lamp'];
  List<String> hardWords = ['car', 'truck', 'motorcycle'];

  String hint = '';

  Timer? timer;

  void startGame({required Level level}) {
    setState(() {
      this.level = level;
      score = 0;
      remainingTime = level.duration;
      jumbledWord = _getRandomWord(easyWords);
      hint = hints[jumbledWord] ?? '';

      timer?.cancel();
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          remainingTime--;
          if (remainingTime <= 0) {
            timer.cancel();
            showResultScreen();
          }
        });
      });
    });
  }

  String _getRandomWord(List<String> wordList) {
    return wordList[DateTime.now().millisecond % wordList.length];
  }

  String _shuffleWord(String word) {
    List<String> letters = word.split('');
    letters.shuffle();
    return letters.join();
  }

  void checkAnswer() {
    if (userAnswer.toLowerCase() == jumbledWord.toLowerCase()) {
      setState(() {
        score += 10;
        userAnswer = '';
        switch (level) {
          case Level.easy:
            jumbledWord = _getRandomWord(easyWords);
            break;
          case Level.medium:
            jumbledWord = _getRandomWord(mediumWords);
            break;
          case Level.hard:
            jumbledWord = _getRandomWord(hardWords);
            break;
        }
        hint = hints[jumbledWord] ?? '';
      });
    } else {
      setState(() {
        userAnswer = '';
      });
    }
  }

  void showResultScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(score: score),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Master Mind'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              'Score: $score',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              'Remaining Time: $remainingTime seconds',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              'Jumbled Word: ${_shuffleWord(jumbledWord)}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              'Hint: $hint',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                setState(() {
                  userAnswer = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Enter your answer',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: checkAnswer,
                  child: Text('Check'),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Select Level'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Text('Easy'),
                            onTap: () {
                              Navigator.pop(context);
                              startGame(level: Level.easy);
                            },
                          ),
                          ListTile(
                            title: Text('Medium'),
                            onTap: () {
                              Navigator.pop(context);
                              startGame(level: Level.medium);
                            },
                          ),
                          ListTile(
                            title: Text('Hard'),
                            onTap: () {
                              Navigator.pop(context);
                              startGame(level: Level.hard);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Text('Change Level'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('How to Play'),
                      content: Text(
                        'In this game, you need to unscramble the jumbled words and enter the correct word in the provided box. Each correct answer earns you 10 points. The game has three levels: easy, medium, and hard. You can change the level by clicking on the "Change Level" button. The game ends when the time runs out. Good luck!',
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('How to Play'),
            ),
          ],
        ),
      ),
    );
  }
}

enum Level {
  easy,
  medium,
  hard,
}

extension LevelExtension on Level {
  int get duration {
    switch (this) {
      case Level.easy:
        return 120;
      case Level.medium:
        return 60;
      case Level.hard:
        return 30;
      default:
        return 0;
    }
  }
}

class ResultScreen extends StatelessWidget {
  final int score;

  const ResultScreen({required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Master Mind'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Game Over',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Your Score: $score',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Play Again'),
            ),
          ],
        ),
      ),
    );
  }
}
