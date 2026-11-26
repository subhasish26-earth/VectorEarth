import 'package:flutter_test/flutter_test.dart';
import 'package:prithvi_fix_app/main.dart';

void main() {
  testWidgets('Prithvi Fix App launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PrithviFixApp());
    expect(find.byType(PrithviFixApp), findsOneWidget);
  });
}
