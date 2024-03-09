import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  final int boardSize;
  final int winCondition;

  const GameScreen(
      {Key? key, required this.boardSize, required this.winCondition})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe Game'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1,
        ),
        itemCount: 9,
        itemBuilder: (context, index) {
          return GridTile(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.lightBlue.shade100,
                border: Border.all(color: Colors.blue, width: 2),
              ),
            ),
          );
        },
      ),
    );
  }
}
