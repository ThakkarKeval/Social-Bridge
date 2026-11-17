import 'package:flutter_test/flutter_test.dart';
import 'package:social_bridge_example/main.dart';

void main() {
  testWidgets('Verify example app buttons render', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Sign in with Google'), findsOneWidget);
    expect(find.text('Sign in with Apple'), findsOneWidget);
    expect(find.text('Sign Out'), findsOneWidget);
  });
}
