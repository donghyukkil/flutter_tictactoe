import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_tictactoe/models/game_model.dart';

void main() {
  group('GameModel checkWinCondition Tests', () {
    test('Player wins by filling a row', () {
      final gameModel = GameModel.defaultModel();
      gameModel.board[0] = 'X';
      gameModel.board[1] = 'X';
      gameModel.board[2] = 'X';
      gameModel.checkWinCondition();

      expect(gameModel.gameOver, isTrue);
      expect(gameModel.winner, 'X');
    });

    test('Game is a draw when all tiles are filled without a winner', () {
      final gameModel = GameModel.defaultModel();
      gameModel.board = [
        'X',
        'O',
        'X',
        'X',
        'X',
        'O',
        'O',
        'X',
        'O',
      ];
      gameModel.checkWinCondition();

      expect(gameModel.gameOver, isTrue);
      expect(gameModel.winner, 'Draw');
    });

    test('Game continues when no win or draw condition is met', () {
      final gameModel = GameModel.defaultModel();
      gameModel.board[0] = 'X';
      gameModel.checkWinCondition();

      expect(gameModel.gameOver, isFalse);
      expect(gameModel.winner, isNull);
    });
  });
}
