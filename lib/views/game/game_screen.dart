import 'package:flutter/material.dart';

import '../../controllers/game_controller.dart';

class GameScreen extends StatefulWidget {
  final GameController gameController;

  const GameScreen({Key? key, required this.gameController}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    super.initState();
    widget.gameController.onStateChanged = updateUI;
  }

  @override
  void dispose() {
    widget.gameController.onStateChanged = null;
    super.dispose();
  }

  void updateUI() {
    setState(() {});
  }

  Color determineBorderColor(String value) {
    if (value == widget.gameController.model.player1Mark) {
      return widget.gameController.model.player1Color;
    } else if (value == widget.gameController.model.player2Mark) {
      return widget.gameController.model.player2Color;
    }
    return Colors.transparent;
  }

  Color determineTextColor(String value) {
    return determineBorderColor(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe Game'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.gameController.model.boardSize,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1,
        ),
        itemCount: widget.gameController.model.board.length,
        itemBuilder: (context, index) {
          String value = widget.gameController.model.board[index];
          return InkWell(
            onTap: () => widget.gameController.markTile(index),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.lightBlue.shade100,
                border:
                    Border.all(color: determineBorderColor(value), width: 2),
              ),
              child: Center(
                child: Text(
                  value,
                  style: TextStyle(
                    color: determineTextColor(value),
                    fontSize: 32,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
