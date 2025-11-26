import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Forces tests to run with a predictable English locale.
void setEnglishTestLocale() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  // For modern Flutter (3.10+), set the locales on the platform dispatcher
  // so MaterialApp picks them up.
  // ignore: invalid_use_of_visible_for_testing_member
  binding.platformDispatcher.localesTestValue = const [Locale('en')];
}

/// Pumps a [widget] after ensuring English locale.
Future<void> pumpWithEnglishLocale(WidgetTester tester, Widget widget) async {
  setEnglishTestLocale();
  await tester.pumpWidget(widget);
  await tester.pumpAndSettle();
}

