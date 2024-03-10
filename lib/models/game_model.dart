import 'package:flutter/material.dart';
import 'dart:math';

class GameModel {
  int boardSize;
  int winCondition;
  List<String> board;
  bool isPlayer1Turn;
  String player1Mark;
  Color player1Color;
  String player2Mark;
  Color player2Color;
  bool gameOver = false;
  String? winner;

  int player1UndoCount = 3;
  int player2UndoCount = 3;
  List<List<String>> previousBoards = [];

  GameModel({
    required this.boardSize,
    required this.winCondition,
    required this.player1Mark,
    required this.player1Color,
    required this.player2Mark,
    required this.player2Color,
    String firstPlayer = "Random",
  })  : board = List.filled(boardSize * boardSize, ''),
        isPlayer1Turn = firstPlayer == "Player 1" ||
            (firstPlayer == "Random" && Random().nextBool());

  void markTile(int index) {
    if (board[index].isEmpty && !gameOver) {
      previousBoards.add(List.from(board));
      board[index] = isPlayer1Turn ? player1Mark : player2Mark;
      checkWinCondition();
      isPlayer1Turn = !isPlayer1Turn;
    }
  }

  void checkWinCondition() {
    List<List<String>> boardGrid = [];

    for (int i = 0; i < boardSize; i++) {
      boardGrid.add(board.sublist(i * boardSize, (i + 1) * boardSize));
    }

    for (int row = 0; row < boardSize; row++) {
      for (int col = 0; col <= boardSize - winCondition; col++) {
        String firstCell = boardGrid[row][col];
        if (firstCell.isNotEmpty) {
          bool isWinningSequence = true;

          for (int offset = 1; offset < winCondition; offset++) {
            if (boardGrid[row][col + offset] != firstCell) {
              isWinningSequence = false;

              break;
            }
          }

          if (isWinningSequence) {
            gameOver = true;
            winner = firstCell;

            return;
          }
        }
      }
    }

    for (int col = 0; col < boardSize; col++) {
      for (int row = 0; row <= boardSize - winCondition; row++) {
        String firstCell = boardGrid[row][col];

        if (firstCell.isNotEmpty) {
          bool isWinningSequence = true;

          for (int offset = 1; offset < winCondition; offset++) {
            if (boardGrid[row + offset][col] != firstCell) {
              isWinningSequence = false;

              break;
            }
          }
          if (isWinningSequence) {
            gameOver = true;
            winner = firstCell;

            return;
          }
        }
      }
    }

    for (int row = 0; row <= boardSize - winCondition; row++) {
      for (int col = 0; col <= boardSize - winCondition; col++) {
        String firstCell = boardGrid[row][col];

        if (firstCell.isNotEmpty) {
          bool isWinningSequence = true;

          for (int offset = 1; offset < winCondition; offset++) {
            if (boardGrid[row + offset][col + offset] != firstCell) {
              isWinningSequence = false;

              break;
            }
          }
          if (isWinningSequence) {
            gameOver = true;
            winner = firstCell;

            return;
          }
        }
      }
    }

    for (int row = 0; row <= boardSize - winCondition; row++) {
      for (int col = winCondition - 1; col < boardSize; col++) {
        String firstCell = boardGrid[row][col];

        if (firstCell.isNotEmpty) {
          bool isWinningSequence = true;

          for (int offset = 1; offset < winCondition; offset++) {
            if (boardGrid[row + offset][col - offset] != firstCell) {
              isWinningSequence = false;

              break;
            }
          }
          if (isWinningSequence) {
            gameOver = true;
            winner = firstCell;

            return;
          }
        }
      }
    }

    if (!board.contains('')) {
      gameOver = true;
      winner = 'Draw';
    }
  }
}
