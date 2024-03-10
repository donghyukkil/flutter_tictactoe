import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './models/game_model.dart';
import 'views/home/home_screen.dart';
import './controllers/game_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider<GameController>(
        create: (_) => GameController(model: GameModel.defaultModel()),
        child: const HomeScreen(),
      ),
    );
  }
}
