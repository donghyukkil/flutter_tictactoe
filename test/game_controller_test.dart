import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_tictactoe/controllers/game_controller.dart';
import 'package:flutter_tictactoe/models/game_model.dart';

class MockGameModel extends Mock implements GameModel {
  @override
  bool gameOver = false;
  @override
  bool readOnly = false;
  @override
  List<String> board = List.filled(9, '');
  @override
  bool isPlayer1Turn = true;
  @override
  String player1Mark = 'X';
  @override
  List<List<String>> previousBoards = [];
  @override
  List<int> markSequence = [];
  @override
  List<bool> movePlayerSequence = [];
}

void main() {
  group('GameController Tests', () {
    late GameController gameController;
    late MockGameModel mockGameModel;

    setUp(() {
      mockGameModel = MockGameModel();
      gameController = GameController(model: mockGameModel);
    });

    test('Test markTile method', () {
      gameController.markTile(0);
      expect(mockGameModel.board[0], 'X');
      expect(mockGameModel.isPlayer1Turn, isFalse);
    });

    test('Undo functionality works correctly', () {
      mockGameModel.board[0] = 'X';
      mockGameModel.previousBoards.add(List.from(mockGameModel.board));
      mockGameModel.markSequence.add(0);
      mockGameModel.movePlayerSequence.add(true);
      mockGameModel.board[0] = '';
      gameController.undo();

      expect(mockGameModel.board[0], '');
      expect(mockGameModel.isPlayer1Turn, isTrue);
    });
  });
}
