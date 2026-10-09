import 'package:flutter_test/flutter_test.dart';
import 'package:chamba/main.dart';

void main() {
  testWidgets('ChambaApp smoke test loads WelcomeScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const ChambaApp());
    await tester.pumpAndSettle();

    expect(find.text('CHAMBA'), findsOneWidget);
    expect(find.text('Empezar Ahora'), findsOneWidget);
  });
}
