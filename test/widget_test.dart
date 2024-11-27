// Ce test basique de widget Flutter permet de vérifier le bon fonctionnement
// du compteur dans une application de type "Hello World" ou similaire.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:application/main.dart'; // Assurez-vous que le chemin est correct

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // On lance l'application et déclenche un premier rendu.
    await tester.pumpWidget(const MyApp());

    // On vérifie que le compteur commence à 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // On appuie sur l'icône '+' et on déclenche un nouveau rendu.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // On vérifie que le compteur a bien été incrémenté à 1.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
