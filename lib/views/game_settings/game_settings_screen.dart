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
    Colors.purple,
  ];
  final List<String> marks = ['X', 'O', '△', '□'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('게임 세팅'),
        backgroundColor: Colors.yellow,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            ListTile(
              title: const Text("보드 크기"),
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
              title: const Text("승리 조건"),
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
              title: const Text("순서 정하기"),
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
              title: const Text("Player 1 마크"),
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
              title: const Text("Player 1 색상"),
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
              title: const Text("Player 2 마크"),
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
              title: const Text("Player 2 색상"),
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
                if (_validateSettings()) {
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
                }
              },
              child: const Text('게임 시작'),
            ),
          ],
        ),
      ),
    );
  }

  bool _validateSettings() {
    if (player1Mark == player2Mark) {
      _showValidationError('플레이어는 동일한 마크를 가질 수 없습니다.');
      return false;
    }
    if (player1Color == player2Color) {
      _showValidationError('플레이어는 동일한 색상을 가질 수 없습니다.');
      return false;
    }
    return true;
  }

  void _showValidationError(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('유효성 검사 오류'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }
}
