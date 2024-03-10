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
    if (widget.gameController.model.gameOver) {
      String message = '';

      if (widget.gameController.model.winner == 'Draw') {
        message = '무승부입니다.';
      } else {
        message = '${widget.gameController.model.winner}의 승리입니다.';
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('게임 종료'),
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

  void _showUndoLimitReachedAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알림'),
          content: const Text('더 이상 무르기를 사용할 수 없습니다.'),
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildPlayerInfoSection(),
          Expanded(
            child: _buildGameBoard(),
          ),
          _buildControlButtons(),
        ],
      ),
    );
  }

  Widget _buildPlayerInfoSection() {
    final model = widget.gameController.model;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildPlayerInfo('Player 1', model.player1Mark, model.player1Color,
              model.isPlayer1Turn, model.player1UndoCount),
          _buildPlayerInfo('Player 2', model.player2Mark, model.player2Color,
              !model.isPlayer1Turn, model.player2UndoCount),
        ],
      ),
    );
  }

  Widget _buildPlayerInfo(String playerName, String mark, Color color,
      bool isCurrentTurn, int undoCount) {
    return Column(
      children: [
        Text(playerName + (isCurrentTurn ? " (차례)" : ""),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text("마크: $mark", style: TextStyle(color: color, fontSize: 16)),
        Text("남은 무르기: $undoCount", style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildGameBoard() {
    return GridView.builder(
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
              border: Border.all(color: determineBorderColor(value), width: 2),
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
    );
  }

  Widget _buildControlButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: () {
              if ((widget.gameController.model.isPlayer1Turn &&
                      widget.gameController.model.player1UndoCount == 0) ||
                  (!widget.gameController.model.isPlayer1Turn &&
                      widget.gameController.model.player2UndoCount == 0)) {
                _showUndoLimitReachedAlert();
              } else {}
            },
          )
        ],
      ),
    );
  }
}
