import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Help'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center (
            child: Text('Instructions about master mind game '),
          ),
          Text("Easy Level"),
          Text("In this mode you can easily understand the word means you can easily read the word and can be type like 'apple'.because you have learn the spellings ....")
        ],
      ),
    );
  }
}
