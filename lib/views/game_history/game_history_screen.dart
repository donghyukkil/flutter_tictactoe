import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_tictactoe/controllers/game_history_provider.dart';
import 'package:flutter_tictactoe/views/game/game_screen.dart';
import 'package:flutter_tictactoe/models/game_model.dart';

class GameHistoryScreen extends StatelessWidget {
  const GameHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameRecords = Provider.of<GameHistoryProvider>(context).gameHistory;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text('저장된 게임'),
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
        children: [
          const SizedBox(height: 50),
          Expanded(
            child: ListView.builder(
              itemCount: gameRecords.length,
              itemBuilder: (context, index) {
                final game = gameRecords[index];
                final String winner = game['winner'] ?? 'Draw';
                final int boardSize = game['boardSize'] ?? 3;
                final int winCondition = game['winCondition'] ?? 3;
                final String player1Mark = game['player1Mark'] ?? 'X';
                String winnerText = winner == 'Draw'
                    ? 'Draw'
                    : (winner == player1Mark ? 'Player 1' : 'Player 2');
                final String gameInfo =
                    'Game ${game['id']} - 승자: $winner ($winnerText)'
                    '보드 크기: $boardSize, 승리 조건: $winCondition';

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 20.0),
                      title: Text(
                        gameInfo,
                        style: const TextStyle(fontSize: 12),
                      ),
                      onTap: () {
                        final int boardSize = game['boardSize'] != null
                            ? game['boardSize'] as int
                            : 3;
                        final int winCondition = game['winCondition'] != null
                            ? game['winCondition'] as int
                            : 3;

                        final GameModel restoredModel = GameModel.fromHistory(
                          boardSize: boardSize,
                          winCondition: winCondition,
                          board:
                              List<String>.from(game['finalBoardState'] ?? []),
                          markSequence:
                              List<int>.from(game['markSequence'] ?? []),
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
          ),
        ],
      ),
    );
  }
}
