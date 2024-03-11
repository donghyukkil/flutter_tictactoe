import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/game_history_provider.dart';
import '../game/game_screen.dart';
import '../../models/game_model.dart';

class GameHistoryScreen extends StatelessWidget {
  const GameHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameRecords = Provider.of<GameHistoryProvider>(context).gameHistory;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text('Recorded Games'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: gameRecords.length,
        itemBuilder: (context, index) {
          final game = gameRecords[index];
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Card(
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 20.0),
                title: Text('Game ${game['id']}'),
                onTap: () {
                  final int boardSize =
                      game['boardSize'] != null ? game['boardSize'] as int : 3;
                  final int winCondition = game['winCondition'] != null
                      ? game['winCondition'] as int
                      : 3;

                  final GameModel restoredModel = GameModel.fromHistory(
                    boardSize: boardSize,
                    winCondition: winCondition,
                    board: List<String>.from(game['finalBoardState'] ?? []),
                    markSequence: List<int>.from(game['markSequence'] ?? []),
                    readOnly: true,
                  );
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        GameScreen(initialModel: restoredModel),
                  ));
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
