import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:social_bridge/social_bridge.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('plugin initialization test', (WidgetTester tester) async {
    final SocialBridge plugin = SocialBridge();
    expect(plugin, isNotNull);
  });
}
