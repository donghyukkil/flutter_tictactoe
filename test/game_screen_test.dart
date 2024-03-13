import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:flutter_tictactoe/controllers/game_controller.dart';
import 'package:flutter_tictactoe/models/game_model.dart';
import 'package:flutter_tictactoe/views/game/game_screen.dart';

void main() {
  testWidgets('Game screen UI test', (WidgetTester tester) async {
    final initialModel = GameModel(
      boardSize: 3,
      winCondition: 3,
      player1Mark: 'X',
      player1Color: Colors.blue,
      player2Mark: 'O',
      player2Color: Colors.red,
      firstPlayer: 'Player 1',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<GameController>(
              create: (_) => GameController(model: initialModel),
            ),
          ],
          child: Builder(builder: (context) {
            return GameScreen(initialModel: initialModel);
          }),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Tic Tac Toe'), findsOneWidget);
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.text('Player 1 (차례)'), findsOneWidget);
    expect(find.text('마크: X'), findsOneWidget);
    expect(find.text('남은 시간: 15 초'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is InkWell,
        description: 'Inkwell Widgets',
      ),
      findsWidgets,
    );
  });
}
