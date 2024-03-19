import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_tictactoe/views/home/home_screen.dart';
import 'package:flutter_tictactoe/controllers/game_controller.dart';
import 'package:flutter_tictactoe/controllers/game_history_provider.dart';
import 'package:flutter_tictactoe/models/game_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => GameController(model: GameModel.defaultModel())),
        ChangeNotifierProvider(create: (_) => GameHistoryProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}
