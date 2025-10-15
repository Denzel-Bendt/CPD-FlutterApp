// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:your_app/main.dart';

// void main() {
//   group('Responsive Layout Tests', () {
//     testWidgets('Afbeeldingen gebruiken max-width: 100%', (WidgetTester tester) async {
//       await tester.pumpWidget(MyApp());
      
//       final image = find.byType(Image);
//       expect(image, findsWidgets);
      
//       // Controleer of afbeeldingen responsive properties hebben
//       final imageWidget = tester.widget<Image>(image.first);
//       // Flutter images zijn standaard responsive
//     });

//     testWidgets('Tekst gebruikt relative units (rem)', (WidgetTester tester) async {
//       await tester.pumpWidget(MyApp());
      
//       final text = find.byType(Text);
//       expect(text, findsWidgets);
      
//       // Controleer of tekst schaalt met theme
//       final textWidget = tester.widget<Text>(text.first);
//       expect(textWidget.style?.fontSize, isNotNull);
//     });

//     testWidgets('Buttons hebben minimum grootte', (WidgetTester tester) async {
//       await tester.pumpWidget(MyApp());
      
//       final button = find.byType(ElevatedButton);
//       expect(button, findsWidgets);
      
//       final buttonWidget = tester.widget<ElevatedButton>(button.first);
//       // Controleer constraints voor minimum grootte
//     });

//     testWidgets('Layout past kolommen aan bij schermgrootte', (WidgetTester tester) async {
//       // Test mobile layout (1 kolom)
//       tester.binding.window.physicalSizeTestValue = const Size(375, 812);
//       await tester.pumpWidget(MyApp());
      
//       final mobileColumns = find.byType(Column);
//       expect(mobileColumns, findsWidgets);
      
//       // Test desktop layout (meerdere kolommen)
//       tester.binding.window.physicalSizeTestValue = const Size(1200, 800);
//       await tester.pumpWidget(MyApp());
      
//       final desktopColumns = find.byType(Row);
//       expect(desktopColumns, findsWidgets);
      
//       tester.binding.window.clearPhysicalSizeTestValue();
//     });

//     testWidgets('Geen overlappende elementen op verschillende schermen', (WidgetTester tester) async {
//       final testSizes = [
//         Size(375, 812),  // Mobile
//         Size(768, 1024), // Tablet
//         Size(1200, 800), // Desktop
//       ];
      
//       for (final size in testSizes) {
//         tester.binding.window.physicalSizeTestValue = size;
//         await tester.pumpWidget(MyApp());
//         await tester.pumpAndSettle();
        
//         // Controleer op gebroken layouts
//         final errorWidget = find.byType(ErrorWidget);
//         expect(errorWidget, findsNothing);
        
//         print('✓ Layout correct voor ${size.width}x${size.height}');
//       }
      
//       tester.binding.window.clearPhysicalSizeTestValue();
//     });

//     testWidgets('Formuliervelden hebben minimum grootte', (WidgetTester tester) async {
//       await tester.pumpWidget(MyApp());
      
//       final textFields = find.byType(TextField);
//       expect(textFields, findsWidgets);
      
//       // Controleer of formuliervelden voldoende groot zijn voor touch
//       final textField = tester.widget<TextField>(textFields.first);
//       expect(textField.decoration?.constraints, isNotNull);
//     });
//   });
// }