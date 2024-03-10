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
      board[index] = isPlayer1Turn ? player1Mark : player2Mark;
      isPlayer1Turn = !isPlayer1Turn;
    }
  }
}
