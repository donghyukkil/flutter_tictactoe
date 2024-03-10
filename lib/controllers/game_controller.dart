import 'package:flutter/material.dart';

import '../models/game_model.dart';

class GameController {
  GameModel model;
  VoidCallback? onStateChanged;

  GameController({required this.model});

  void markTile(int index) {
    model.markTile(index);
    onStateChanged?.call();
  }
}
