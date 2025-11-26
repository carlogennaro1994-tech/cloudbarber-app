import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloudbarber/main.dart';

import 'test_utils.dart';

void main() {
  testWidgets('Initial route is Login and app builds', (WidgetTester tester) async {
    await pumpWithEnglishLocale(
      tester,
      const ProviderScope(child: CloudBarberApp()),
    );

    // Expect to see the Login button text from l10n
    expect(find.text('Login'), findsOneWidget);
  });
}

