
import 'package:flutter_test/flutter_test.dart';
import 'package:cpd_flutterapp/main.dart'; // Zorg ervoor dat dit klopt

void main() {
  testWidgets('HomePage displays correct title and welcome message', (WidgetTester tester) async {
    // Bouw onze app en trigger een frame.
    await tester.pumpWidget(const MyApp());

    // Controleer of de titel correct wordt weergegeven.
    expect(find.text('Team Management Applicatie'), findsOneWidget);
    expect(find.text('Welkom bij de Team Management Applicatie!'), findsOneWidget);
    
    // Hier kun je andere interacties toevoegen die je wilt testen.
  });
}
