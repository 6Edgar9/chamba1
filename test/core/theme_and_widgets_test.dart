import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chamba/core/theme/app_colors.dart';
import 'package:chamba/core/widgets/chamba_button.dart';
import 'package:chamba/core/widgets/chamba_badge.dart';
import 'package:chamba/core/widgets/price_dial_stepper.dart';

void main() {
  testWidgets('ChambaButton triggers callback when pressed', (tester) async {
    var pressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChambaButton(
            label: 'Aceptar Oferta',
            onPressed: () => pressed = true,
          ),
        ),
      ),
    );

    expect(find.text('Aceptar Oferta'), findsOneWidget);
    await tester.tap(find.text('Aceptar Oferta'));
    expect(pressed, isTrue);
  });

  testWidgets('ChambaBadge renders negotiating status', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ChambaBadge.negotiating(),
        ),
      ),
    );

    expect(find.text('Negociando'), findsOneWidget);
  });

  testWidgets('PriceDialStepper increments and decrements price', (tester) async {
    double price = 50.0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return PriceDialStepper(
                currentPrice: price,
                onPriceChanged: (newPrice) {
                  setState(() => price = newPrice);
                },
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('50'), findsOneWidget);
    // Tap increment '+'
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(price, equals(55.0));

    // Tap quick pill '+S/.10'
    await tester.tap(find.text('+S/.10'));
    await tester.pump();
    expect(price, equals(65.0));
  });
}
