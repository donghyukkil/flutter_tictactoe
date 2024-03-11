import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/game_controller.dart';
import '../../controllers/game_history_provider.dart';
import '../../models/game_model.dart';

class GameScreen extends StatefulWidget {
  final GameModel? initialModel;

  const GameScreen({Key? key, this.initialModel}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final gameController = Provider.of<GameController>(context, listen: false);

    if (widget.initialModel != null) {
      gameController.model = widget.initialModel!;
    }

    gameController.onGameOver = () {
      Provider.of<GameHistoryProvider>(context, listen: false).addGameResult({
        'id': Provider.of<GameHistoryProvider>(context, listen: false)
                .gameHistory
                .length +
            1,
        'boardSize': gameController.model.boardSize,
        'winCondition': gameController.model.winCondition,
        'winner': gameController.model.winner ?? 'Draw',
        'date': DateTime.now().toString(),
        'finalBoardState': gameController.model.board,
        'markSequence': gameController.model.markSequence,
      });

      if (gameController.model.gameOver &&
          gameController.model.winner != null) {
        _showWinDialog(gameController.model.winner!);
      }
    };
  }

  void _showWinDialog(String winner) {
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

  @override
  Widget build(BuildContext context) {
    final gameController = Provider.of<GameController>(context);
    final isReadOnly = gameController.model.readOnly;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
        backgroundColor: Colors.yellow,
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
          const SizedBox(
            height: 50,
          ),
          _buildPlayerInfoSection(gameController),
          _buildRemainingTimeSection(gameController),
          Flexible(
            flex: 3,
            child: _buildGameBoard(gameController, isReadOnly),
          ),
          if (!isReadOnly)
            Flexible(
              flex: 1,
              child: _buildControlButtons(gameController),
            ),
        ],
      ),
    );
  }

  Widget _buildPlayerInfoSection(
    GameController gameController,
  ) {
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

  Widget _buildPlayerInfo(String playerName, String mark, Color color,
      bool isCurrentTurn, int undoCount) {
    Color backgroundColor = isCurrentTurn ? Colors.yellow : Colors.white;

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(playerName + (isCurrentTurn ? " (차례)" : ""),
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text("마크: $mark", style: TextStyle(color: color, fontSize: 16)),
          Text("남은 무르기: $undoCount", style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildRemainingTimeSection(GameController gameController) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text('Remaining Time: ${gameController.remainingSeconds} seconds',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildGameBoard(GameController gameController, bool isReadOnly) {
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
        Color tileColor = Colors.yellow;
        int markOrder = gameController.model.markSequence.indexOf(index) + 1;

        return InkWell(
          onTap: isReadOnly ? null : () => gameController.markTile(index),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: tileColor,
              border: Border.all(
                color: _determineBorderColor(value, gameController),
                width: 2,
              ),
            ),
            child: Center(
              child: value.isNotEmpty
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          value,
                          style: TextStyle(
                            color: _determineTextColor(value, gameController),
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          "($markOrder)",
                          style: TextStyle(
                            color: _determineTextColor(value, gameController),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    )
                  : const Text(""),
            ),
          ),
        );
      },
    );
  }

  Widget _buildControlButtons(GameController gameController) {
    return Padding(
      padding: const EdgeInsets.only(top: 1.0, bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.restart_alt_rounded),
            onPressed: gameController.model.previousBoards.isNotEmpty
                ? () => gameController.undo()
                : null,
          ),
        ],
      ),
    );
  }

  Color _determineBorderColor(String value, GameController gameController) {
    return value == gameController.model.player1Mark
        ? gameController.model.player1Color
        : value == gameController.model.player2Mark
            ? gameController.model.player2Color
            : Colors.transparent;
  }

  Color _determineTextColor(String value, GameController gameController) {
    return _determineBorderColor(value, gameController);
  }
}
