// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:your_app/main.dart';

// void main() {
//   group('Navigation Component Tests', () {
//     testWidgets('Desktop navigatie toont horizontale balk', (WidgetTester tester) async {
//       // Simuleer desktop scherm
//       tester.binding.window.physicalSizeTestValue = const Size(1200, 800);
      
//       await tester.pumpWidget(MyApp());
      
//       final appBar = find.byType(AppBar);
//       expect(appBar, findsOneWidget);
      
//       // Controleer op horizontale navigatie elementen
//       final burgerMenu = find.byIcon(Icons.menu);
//       expect(burgerMenu, findsOneWidget);
      
//       final pageTitle = find.byType(Text);
//       expect(pageTitle, findsWidgets);
      
//       tester.binding.window.clearPhysicalSizeTestValue();
//     });

//     testWidgets('Mobiele navigatie toont burger menu', (WidgetTester tester) async {
//       // Simuleer mobiel scherm
//       tester.binding.window.physicalSizeTestValue = const Size(375, 812);
      
//       await tester.pumpWidget(MyApp());
      
//       final burgerMenu = find.byIcon(Icons.menu);
//       expect(burgerMenu, findsOneWidget);
      
//       final searchIcon = find.byIcon(Icons.search);
//       expect(searchIcon, findsOneWidget);
      
//       tester.binding.window.clearPhysicalSizeTestValue();
//     });

//     testWidgets('Burger menu opent sidebar', (WidgetTester tester) async {
//       await tester.pumpWidget(MyApp());
      
//       final burgerMenu = find.byIcon(Icons.menu);
//       await tester.tap(burgerMenu);
//       await tester.pumpAndSettle();
      
//       // Controleer of sidebar geopend is
//       final drawer = find.byType(Drawer);
//       expect(drawer, findsOneWidget);
//     });

//     testWidgets('Sidebar bevat alle navigatie links', (WidgetTester tester) async {
//       await tester.pumpWidget(MyApp());
      
//       // Open sidebar
//       final burgerMenu = find.byIcon(Icons.menu);
//       await tester.tap(burgerMenu);
//       await tester.pumpAndSettle();
      
//       // Controleer aanwezigheid van navigatie links
//       final expectedLinks = ['Profiel', 'Instellingen', 'Dashboard', 'Leden'];
      
//       for (final link in expectedLinks) {
//         expect(find.text(link), findsOneWidget);
//       }
//     });

//     testWidgets('Navigatie links werken correct', (WidgetTester tester) async {
//       await tester.pumpWidget(MyApp());
      
//       // Open sidebar
//       final burgerMenu = find.byIcon(Icons.menu);
//       await tester.tap(burgerMenu);
//       await tester.pumpAndSettle();
      
//       // Test navigatie naar profiel
//       final profileLink = find.text('Profiel');
//       await tester.tap(profileLink);
//       await tester.pumpAndSettle();
      
//       // Verifieer dat we op profiel pagina zijn
//       expect(find.text('Gebruikersprofiel'), findsOneWidget);
//     });

//     testWidgets('Pagina titel wordt getoond in navigatiebalk', (WidgetTester tester) async {
//       await tester.pumpWidget(MyApp());
      
//       final pageTitle = find.text('Dashboard'); // Pas aan naar actuele titel
//       expect(pageTitle, findsOneWidget);
//     });

//     testWidgets('Profiel toegankelijk via burger menu', (WidgetTester tester) async {
//       await tester.pumpWidget(MyApp());
      
//       // Open sidebar
//       final burgerMenu = find.byIcon(Icons.menu);
//       await tester.tap(burgerMenu);
//       await tester.pumpAndSettle();
      
//       // Navigeer naar profiel
//       final profileLink = find.text('Profiel');
//       await tester.tap(profileLink);
//       await tester.pumpAndSettle();
      
//       // Verifieer profiel pagina
//       expect(find.byType(UserProfile), findsOneWidget);
//     });
//   });
// }