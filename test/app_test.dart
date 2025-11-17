import 'package:flutter_test/flutter_test.dart';
import 'package:cloudbarber/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('CloudBarber app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: CloudBarberApp(),
      ),
    );

    // Verify that the app starts without crashing
    expect(find.byType(ProviderScope), findsOneWidget);
  });
}
