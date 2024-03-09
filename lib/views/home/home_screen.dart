import 'package:flutter/material.dart';

import '../game_settings/game_settings_screen.dart';
import '../game_history/game_history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const GameSettingsScreen()),
                );
              },
              child: const Text('게임 시작'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const GameHistoryScreen()),
                );
              },
              child: const Text('기록된 게임 보기'),
            ),
          ],
        ),
      ),
    );
  }
}
