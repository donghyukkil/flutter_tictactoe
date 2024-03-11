import 'package:flutter/material.dart';

class GameHistoryProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _gameHistory = [];

  List<Map<String, dynamic>> get gameHistory => _gameHistory;

  void addGameResult(Map<String, dynamic> gameResult) {
    _gameHistory.add(gameResult);
    notifyListeners();
  }
}
