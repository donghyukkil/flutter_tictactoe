import 'package:flutter/material.dart';

import '../game/game_screen.dart';

class GameSettingsScreen extends StatefulWidget {
  const GameSettingsScreen({Key? key}) : super(key: key);

  @override
  _GameSettingsScreenState createState() => _GameSettingsScreenState();
}

class _GameSettingsScreenState extends State<GameSettingsScreen> {
  int boardSize = 3;
  int winCondition = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<int>(
              value: boardSize,
              onChanged: (int? newValue) {
                setState(() {
                  boardSize = newValue!;
                  winCondition = 3;
                });
              },
              items: <int>[3, 4, 5].map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value x $value'),
                );
              }).toList(),
            ),
            DropdownButton<int>(
              value: winCondition,
              onChanged: (int? newValue) {
                setState(() {
                  winCondition = newValue!;
                });
              },
              items: List<int>.generate(boardSize - 2, (index) => index + 3)
                  .map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('Win Condition: $value'),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameScreen(
                      boardSize: boardSize,
                      winCondition: winCondition,
                    ),
                  ),
                );
              },
              child: const Text('시작'),
            ),
          ],
        ),
      ),
    );
  }
}
