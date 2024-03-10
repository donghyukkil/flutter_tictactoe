import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/game_model.dart';

class GameController extends ChangeNotifier {
  GameModel model;

  GameController({required this.model});

  static GameController of(BuildContext context, {bool listen = false}) =>
      Provider.of<GameController>(context, listen: listen);

  static GameModel defaultModel() => GameModel(
        boardSize: 3,
        winCondition: 3,
        player1Mark: 'X',
        player1Color: Colors.blue,
        player2Mark: 'O',
        player2Color: Colors.red,
        firstPlayer: "Random",
      );

  void markTile(int index) {
    if (!model.gameOver && model.board[index].isEmpty) {
      model.previousBoards.add(List.from(model.board));
      model.board[index] =
          model.isPlayer1Turn ? model.player1Mark : model.player2Mark;
      model.checkWinCondition();
      model.isPlayer1Turn = !model.isPlayer1Turn;

      notifyListeners();
    }
  }

  void undo() {
    if (model.previousBoards.isNotEmpty) {
      if (model.isPlayer1Turn && model.player2UndoCount > 0) {
        model.player2UndoCount -= 1;
        model.isPlayer1Turn = !model.isPlayer1Turn;
      } else if (!model.isPlayer1Turn && model.player1UndoCount > 0) {
        model.player1UndoCount -= 1;
        model.isPlayer1Turn = !model.isPlayer1Turn;
      }
      model.undo();

      notifyListeners();
    }
  }
}
