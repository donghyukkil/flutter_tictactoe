import 'package:flutter/material.dart';
import 'dart:math';

class GameModel {
  int boardSize;
  int winCondition;
  List<String> board;
  late bool isPlayer1Turn;
  String player1Mark;
  Color player1Color;
  String player2Mark;
  Color player2Color;
  bool gameOver = false;
  String? winner;
  int player1UndoCount = 3;
  int player2UndoCount = 3;
  List<List<String>> previousBoards = [];
  List<int> markSequence = [];
  bool readOnly = false;

  GameModel({
    required this.boardSize,
    required this.winCondition,
    required this.player1Mark,
    required this.player1Color,
    required this.player2Mark,
    required this.player2Color,
    String firstPlayer = "Random",
  }) : board = List.filled(boardSize * boardSize, '') {
    isPlayer1Turn = firstPlayer == "Player 1"
        ? true
        : firstPlayer == "Player 2"
            ? false
            : Random().nextBool();
  }

  GameModel.fromHistory({
    required this.boardSize,
    required this.winCondition,
    required this.board,
    required this.markSequence,
    this.readOnly = false,
  })  : player1Mark = 'X',
        player1Color = Colors.blue,
        player2Mark = 'O',
        player2Color = Colors.red {
    isPlayer1Turn = true;
  }

  static GameModel defaultModel() {
    return GameModel(
      boardSize: 3,
      winCondition: 3,
      player1Mark: 'X',
      player1Color: Colors.blue,
      player2Mark: 'O',
      player2Color: Colors.red,
    );
  }

  void markTile(int index) {
    if (board[index].isEmpty && !gameOver) {
      previousBoards.add(List.from(board));
      board[index] = isPlayer1Turn ? player1Mark : player2Mark;
      markSequence.add(index);
      checkWinCondition();
      isPlayer1Turn = !isPlayer1Turn;
    }
  }

  void undo() {
    if (previousBoards.isNotEmpty) {
      board = previousBoards.removeLast();
      gameOver = false;
      winner = null;
    }
  }

  void checkWinCondition() {
    bool hasWinningSequence(int startRow, int startCol, int dRow, int dCol) {
      String firstCell = board[startRow * boardSize + startCol];
      if (firstCell.isEmpty) {
        return false;
      }

      for (int i = 1; i < winCondition; ++i) {
        int row = startRow + dRow * i;
        int col = startCol + dCol * i;
        if (board[row * boardSize + col] != firstCell) {
          return false;
        }
      }

      return true;
    }

    for (int row = 0; row < boardSize; ++row) {
      for (int col = 0; col < boardSize; ++col) {
        if (col <= boardSize - winCondition &&
                hasWinningSequence(row, col, 0, 1) ||
            row <= boardSize - winCondition &&
                hasWinningSequence(row, col, 1, 0) ||
            row <= boardSize - winCondition &&
                col <= boardSize - winCondition &&
                hasWinningSequence(row, col, 1, 1) ||
            row <= boardSize - winCondition &&
                col >= winCondition - 1 &&
                hasWinningSequence(row, col, 1, -1)) {
          gameOver = true;
          winner = board[row * boardSize + col];
          return;
        }
      }
    }

    if (!board.contains('')) {
      gameOver = true;
      winner = 'Draw';
    }
  }
}
