import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:math';

import '../models/game_model.dart';

class GameController extends ChangeNotifier {
  GameModel model;
  Timer? _countdownTimer;
  static const int turnDurationSeconds = 15;
  bool _wasLastMoveAutomatic = false;
  int _remainingSeconds = turnDurationSeconds;
  Function? onGameOver;

  bool get wasLastMoveAutomatic => _wasLastMoveAutomatic;
  int get remainingSeconds => _remainingSeconds;

  GameController({required this.model});

  static GameController of(BuildContext context, {bool listen = false}) =>
      Provider.of<GameController>(context, listen: listen);

  static GameModel defaultModel() => GameModel.defaultModel();

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void resetLastMoveAutomaticFlag() {
    _wasLastMoveAutomatic = false;
    notifyListeners();
  }

  void markTile(int index) {
    if (!model.gameOver && model.board[index].isEmpty && !model.readOnly) {
      model.previousBoards.add(List.from(model.board));
      model.board[index] =
          model.isPlayer1Turn ? model.player1Mark : model.player2Mark;
      model.markSequence.add(index);
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
      _startTurnTimer();
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
