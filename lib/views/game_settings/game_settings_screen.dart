import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';

import '../game/game_screen.dart';
import '../../models/game_model.dart';
import '../../controllers/game_controller.dart';

class GameSettingsScreen extends StatefulWidget {
  const GameSettingsScreen({Key? key}) : super(key: key);

  @override
  _GameSettingsScreenState createState() => _GameSettingsScreenState();
}

class _GameSettingsScreenState extends State<GameSettingsScreen> {
  int boardSize = 3;
  int winCondition = 3;
  String player1Mark = 'X';
  Color player1Color = Colors.blue;
  String player2Mark = 'O';
  Color player2Color = Colors.red;
  String firstPlayer = 'Random';
  final List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.yellow,
  ];
  final List<String> marks = ['X', 'O', '△', '■'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Settings'),
        backgroundColor: Colors.yellow,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            ListTile(
              title: const Text("Board Size"),
              trailing: DropdownButton<int>(
                value: boardSize,
                onChanged: (int? newValue) {
                  setState(() {
                    boardSize = newValue!;
                    winCondition = max(3, boardSize);
                  });
                },
                items: <int>[3, 4, 5, 6, 7]
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value x $value'),
                  );
                }).toList(),
              ),
            ),
            ListTile(
              title: const Text("Win Condition"),
              trailing: DropdownButton<int>(
                value: winCondition,
                onChanged: (int? newValue) {
                  setState(() {
                    winCondition = max(3, min(newValue!, boardSize));
                  });
                },
                items: List<int>.generate(boardSize - 2, (index) => index + 3)
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value'),
                  );
                }).toList(),
              ),
            ),
            ListTile(
              title: const Text("First Player"),
              trailing: DropdownButton<String>(
                value: firstPlayer,
                onChanged: (String? newValue) {
                  setState(() {
                    firstPlayer = newValue!;
                  });
                },
                items: <String>['Random', 'Player 1', 'Player 2']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            ListTile(
              title: const Text("Player 1 Mark"),
              trailing: DropdownButton<String>(
                value: player1Mark,
                onChanged: (String? newValue) {
                  setState(() {
                    player1Mark = newValue!;
                  });
                },
                items: marks.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            ListTile(
              title: const Text("Player 1 Color"),
              trailing: DropdownButton<Color>(
                value: player1Color,
                onChanged: (Color? newValue) {
                  setState(() {
                    player1Color = newValue!;
                  });
                },
                items: colors.map<DropdownMenuItem<Color>>((Color color) {
                  return DropdownMenuItem<Color>(
                    value: color,
                    child: Container(
                      width: 24,
                      height: 24,
                      color: color,
                    ),
                  );
                }).toList(),
              ),
            ),
            ListTile(
              title: const Text("Player 2 Mark"),
              trailing: DropdownButton<String>(
                value: player2Mark,
                onChanged: (String? newValue) {
                  setState(() {
                    player2Mark = newValue!;
                  });
                },
                items: marks.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            ListTile(
              title: const Text("Player 2 Color"),
              trailing: DropdownButton<Color>(
                value: player2Color,
                onChanged: (Color? newValue) {
                  setState(() {
                    player2Color = newValue!;
                  });
                },
                items: colors.map<DropdownMenuItem<Color>>((Color color) {
                  return DropdownMenuItem<Color>(
                    value: color,
                    child: Container(
                      width: 24,
                      height: 24,
                      color: color,
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.yellow,
              ),
              onPressed: () {
                GameModel gameModel = GameModel(
                  boardSize: boardSize,
                  winCondition: winCondition,
                  player1Mark: player1Mark,
                  player1Color: player1Color,
                  player2Mark: player2Mark,
                  player2Color: player2Color,
                  firstPlayer: firstPlayer == 'Random'
                      ? ['Player 1', 'Player 2'][Random().nextInt(2)]
                      : firstPlayer,
                );
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        ChangeNotifierProvider<GameController>(
                      create: (_) => GameController(model: gameModel),
                      child: const GameScreen(),
                    ),
                  ),
                );
              },
              child: const Text('Start Game'),
            ),
          ],
        ),
      ),
    );
  }
}
