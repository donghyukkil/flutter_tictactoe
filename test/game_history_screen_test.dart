import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:flutter_tictactoe/controllers/game_history_provider.dart';
import 'package:flutter_tictactoe/views/game_history/game_history_screen.dart';

void main() {
  testWidgets('Game history screen renders properly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<GameHistoryProvider>(
            create: (_) => GameHistoryProvider(),
          ),
        ],
        child: const MaterialApp(
          home: GameHistoryScreen(),
        ),
      ),
    );

    expect(find.text('저장된 게임'), findsOneWidget);
  });
}
