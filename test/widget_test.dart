import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aplicacion/core/widgets/primary_button.dart';

void main() {
  testWidgets('PrimaryButton shows its label and reacts to taps', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrimaryButton(
            label: 'Continuar',
            onPressed: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Continuar'), findsOneWidget);

    await tester.tap(find.text('Continuar'));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('PrimaryButton shows a spinner and ignores taps while loading',
      (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrimaryButton(
            label: 'Continuar',
            isLoading: true,
            onPressed: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.tap(find.byType(PrimaryButton));
    await tester.pump();

    expect(tapped, isFalse);
  });
}
