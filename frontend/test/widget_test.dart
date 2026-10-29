import 'package:flutter_test/flutter_test.dart';
import 'package:menly_app/main.dart';

void main() {
  testWidgets('App khoi dong', (tester) async {
    await tester.pumpWidget(const MenlyApp());
    expect(find.byType(MenlyApp), findsOneWidget);
  });
}
