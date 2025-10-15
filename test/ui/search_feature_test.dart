// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:your_app/main.dart';

// void main() {
//   group('Search Feature Tests', () {
//     testWidgets('Zoekbalk klapt open bij klik vergrootglas', (WidgetTester tester) async {
//       await tester.pumpWidget(MyApp());
      
//       final searchIcon = find.byIcon(Icons.search);
//       await tester.tap(searchIcon);
//       await tester.pumpAndSettle();
      
//       final searchField = find.byType(TextField);
//       expect(searchField, findsOneWidget);
//     });

//     testWidgets('Zoekbalk klapt dicht bij tweede klik', (WidgetTester tester) async {
//       await tester.pumpWidget(MyApp());
      
//       // Open zoekbalk
//       final searchIcon = find.byIcon(Icons.search);
//       await tester.tap(searchIcon);
//       await tester.pumpAndSettle();
      
//       // Sluit zoekbalk
//       await tester.tap(searchIcon);
//       await tester.pumpAndSettle();
      
//       final searchField = find.byType(TextField);
//       expect(searchField, findsNothing);
//     });

//     testWidgets('Toont zoeksuggesties tijdens typen', (WidgetTester tester) async {
//       await tester.pumpWidget(MyApp());
      
//       // Open zoekbalk
//       final searchIcon = find.byIcon(Icons.search);
//       await tester.tap(searchIcon);
//       await tester.pumpAndSettle();
      
//       // Type in zoekbalk
//       final searchField = find.byType(TextField);
//       await tester.enterText(searchField, 'test');
//       await tester.pump();
      
//       // Controleer op suggesties
//       final suggestions = find.byType(ListTile);
//       expect(suggestions, findsWidgets);
//     });

//     testWidgets('Zoekquery wordt bijgehouden in state', (WidgetTester tester) async {
//       await tester.pumpWidget(MyApp());
      
//       // Open zoekbalk
//       final searchIcon = find.byIcon(Icons.search);
//       await tester.tap(searchIcon);
//       await tester.pumpAndSettle();
      
//       // Type zoekterm
//       const testQuery = 'instellingen';
//       final searchField = find.byType(TextField);
//       await tester.enterText(searchField, testQuery);
//       await tester.pump();
      
//       // Verifieer dat query wordt weergegeven
//       expect(find.text(testQuery), findsOneWidget);
//     });

//     testWidgets('Navigatie naar zoekresultaat via Enter', (WidgetTester tester) async {
//       await tester.pumpWidget(MyApp());
      
//       // Open zoekbalk
//       final searchIcon = find.byIcon(Icons.search);
//       await tester.tap(searchIcon);
//       await tester.pumpAndSettle();
      
//       // Type zoekterm en druk Enter
//       final searchField = find.byType(TextField);
//       await tester.enterText(searchField, 'dashboard');
//       await tester.testTextInput.receiveAction(TextInputAction.done);
//       await tester.pumpAndSettle();
      
//       // Verifieer navigatie naar zoekresultaten
//       expect(find.text('Zoekresultaten'), findsOneWidget);
//     });

//     testWidgets('Navigatie naar zoekresultaat via suggestie klik', (WidgetTester tester) async {
//       await tester.pumpWidget(MyApp());
      
//       // Open zoekbalk
//       final searchIcon = find.byIcon(Icons.search);
//       await tester.tap(searchIcon);
//       await tester.pumpAndSettle();
      
//       // Type zoekterm
//       final searchField = find.byType(TextField);
//       await tester.enterText(searchField, 'profiel');
//       await tester.pump();
      
//       // Klik op eerste suggestie
//       final firstSuggestion = find.byType(ListTile).first;
//       await tester.tap(firstSuggestion);
//       await tester.pumpAndSettle();
      
//       // Verifieer navigatie
//       expect(find.text('Profiel'), findsOneWidget);
//     });

//     testWidgets('Lege zoekresultaten worden correct afgehandeld', (WidgetTester tester) async {
//       await tester.pumpWidget(MyApp());
      
//       // Open zoekbalk
//       final searchIcon = find.byIcon(Icons.search);
//       await tester.tap(searchIcon);
//       await tester.pumpAndSettle();
      
//       // Type ongeldige zoekterm
//       final searchField = find.byType(TextField);
//       await tester.enterText(searchField, 'ongeldigezoekterm');
//       await tester.testTextInput.receiveAction(TextInputAction.done);
//       await tester.pumpAndSettle();
      
//       // Verifieer lege state
//       expect(find.text('Geen resultaten gevonden'), findsOneWidget);
//     });

//     testWidgets('Zoekfunctie werkt op zowel mobile als desktop', (WidgetTester tester) async {
//       // Test op mobile
//       tester.binding.window.physicalSizeTestValue = const Size(375, 812);
//       await tester.pumpWidget(MyApp());
      
//       final mobileSearchIcon = find.byIcon(Icons.search);
//       await tester.tap(mobileSearchIcon);
//       await tester.pumpAndSettle();
      
//       expect(find.byType(TextField), findsOneWidget);
      
//       // Test op desktop
//       tester.binding.window.physicalSizeTestValue = const Size(1200, 800);
//       await tester.pumpWidget(MyApp());
      
//       final desktopSearchIcon = find.byIcon(Icons.search);
//       await tester.tap(desktopSearchIcon);
//       await tester.pumpAndSettle();
      
//       expect(find.byType(TextField), findsOneWidget);
      
//       tester.binding.window.clearPhysicalSizeTestValue();
//     });
//   });
// }