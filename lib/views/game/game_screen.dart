import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/game_controller.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameController = Provider.of<GameController>(context);

    if (gameController.model.gameOver && gameController.model.winner != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showWinDialog(context, gameController.model.winner!);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe Game'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildPlayerInfoSection(gameController),
          _buildRemainingTimeSection(gameController),
          Expanded(
            child: _buildGameBoard(gameController),
          ),
          _buildControlButtons(gameController, context),
        ],
      ),
    );
  }

  void _showWinDialog(BuildContext context, String winner) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Text(winner == 'Draw' ? 'It\'s a Draw!' : '$winner Wins!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
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

  Widget _buildPlayerInfoSection(GameController gameController) {
    final model = gameController.model;

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

  Widget _buildRemainingTimeSection(GameController gameController) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Remaining Time: ${gameController.remainingSeconds} seconds',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildGameBoard(GameController gameController) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: gameController.model.boardSize,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: gameController.model.board.length,
      itemBuilder: (context, index) {
        String value = gameController.model.board[index];
        Color tileColor =
            gameController.wasLastMoveAutomatic && value.isNotEmpty
                ? Colors.amber.shade200
                : Colors.lightBlue.shade100;

        if (gameController.wasLastMoveAutomatic) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            gameController.resetLastMoveAutomaticFlag();
          });
        }

        return InkWell(
          onTap: () {
            gameController.markTile(index);
          },
          child: Container(
            decoration: BoxDecoration(
              color: tileColor,
              border: Border.all(
                color: _determineBorderColor(value, gameController),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                value,
                style: TextStyle(
                  color: _determineTextColor(value, gameController),
                  fontSize: 32,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildControlButtons(
      GameController gameController, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: gameController.model.previousBoards.isNotEmpty
                ? () {
                    gameController.undo();
                  }
                : null,
          )
        ],
      ),
    );
  }

  Color _determineBorderColor(String value, GameController gameController) {
    if (value == gameController.model.player1Mark) {
      return gameController.model.player1Color;
    } else if (value == gameController.model.player2Mark) {
      return gameController.model.player2Color;
    }

    return Colors.transparent;
  }

  Color _determineTextColor(String value, GameController gameController) {
    return _determineBorderColor(value, gameController);
  }
}
