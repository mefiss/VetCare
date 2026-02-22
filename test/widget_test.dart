import 'package:flutter_test/flutter_test.dart';
import 'package:petcare/main.dart';

void main() {
  testWidgets('PetCare app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PetCareApp());
    expect(find.text('Bienvenido Diego \u{1F44B}'), findsOneWidget);
  });
}
