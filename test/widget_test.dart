import 'package:flutter_test/flutter_test.dart';
import 'package:entrytud_app/main.dart';

void main() {
  testWidgets('App starts with splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const EntryTudApp());
    expect(find.text('EntryTUD'), findsOneWidget);
  });
}
