import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import 'package:flutter_tictactoe/models/game_model.dart';

class GameController extends ChangeNotifier {
  GameModel model;

  static const int turnDurationSeconds = 15;
  Timer? _countdownTimer;
  int _remainingSeconds = turnDurationSeconds;

  bool _wasLastMoveAutomatic = false;
  Function? onGameOver;

  bool get wasLastMoveAutomatic => _wasLastMoveAutomatic;
  int get remainingSeconds => _remainingSeconds;

  GameController({required this.model});

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void markTile(int index) {
    if (!model.gameOver && model.board[index].isEmpty && !model.readOnly) {
      model.previousBoards.add(List.from(model.board));
      model.board[index] =
          model.isPlayer1Turn ? model.player1Mark : model.player2Mark;
      model.markSequence.add(index);
      model.movePlayerSequence.add(model.isPlayer1Turn);

      model.checkWinCondition();
      model.isPlayer1Turn = !model.isPlayer1Turn;

      if (model.gameOver) {
        _countdownTimer?.cancel();

        if (onGameOver != null) {
          onGameOver!();
        }
      }

      notifyListeners();

      if (!model.gameOver) {
        _startTurnTimer();
      }
    }
  }

  void undo() {
    if (model.previousBoards.isNotEmpty &&
        model.movePlayerSequence.isNotEmpty) {
      bool lastMoveByCurrentPlayer =
          model.movePlayerSequence.last != model.isPlayer1Turn;

      if (lastMoveByCurrentPlayer) {
        bool wasPlayer1Turn = model.movePlayerSequence.removeLast();

        if ((wasPlayer1Turn && model.player1UndoCount > 0) ||
            (!wasPlayer1Turn && model.player2UndoCount > 0)) {
          model.board = model.previousBoards.removeLast();
          model.markSequence.removeLast();

          if (wasPlayer1Turn) {
            model.player1UndoCount--;
          } else {
            model.player2UndoCount--;
          }

          model.isPlayer1Turn = wasPlayer1Turn;
          model.gameOver = false;
          model.winner = null;

          notifyListeners();
          _startTurnTimer();
        }
      }
    }
  }

  void _startTurnTimer() {
    _wasLastMoveAutomatic = false;
    _remainingSeconds = turnDurationSeconds;
    _countdownTimer?.cancel();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _countdownTimer?.cancel();
        _handleTimeUp();
      }
    });
  }

  void _handleTimeUp() {
    if (model.gameOver && !model.readOnly) {
      _countdownTimer?.cancel();

      return;
    }

    List<int> emptyIndices = List.generate(model.board.length, (i) => i)
        .where((i) => model.board[i].isEmpty)
        .toList();

    if (emptyIndices.isNotEmpty) {
      Random rng = Random();
      int randomIndex = emptyIndices[rng.nextInt(emptyIndices.length)];

      markTile(randomIndex);
    } else {
      _wasLastMoveAutomatic = true;
    }

    if (model.gameOver) {
      _countdownTimer?.cancel();
      notifyListeners();
    } else {
      _startTurnTimer();
    }
  }
}
