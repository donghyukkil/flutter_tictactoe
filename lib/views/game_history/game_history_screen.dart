import 'package:flutter/material.dart';

class GameHistoryScreen extends StatelessWidget {
  const GameHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> gameRecords = [
      {
        'id': '1',
        'players': ['Player 1', 'Player 2'],
        'winner': 'Player 1',
        'date': '2023-03-15',
      },
      {
        'id': '2',
        'players': ['Player 1', 'Player 2'],
        'winner': 'Player 2',
        'date': '2023-03-16',
      },
      {
        'id': '3',
        'players': ['Player 1', 'Player 2'],
        'winner': 'Draw',
        'date': '2023-03-17',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recorded Games'),
      ),
      body: ListView.builder(
        itemCount: gameRecords.length,
        itemBuilder: (context, index) {
          final game = gameRecords[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('Game ${game['id']}'),
              subtitle: Text('Date: ${game['date']}'),
              trailing: Text('Winner: ${game['winner']}'),
            ),
          );
        },
      ),
    );
  }
}
