import 'package:flutter_test/flutter_test.dart';
import 'package:socratic_ai_mobile/app.dart';

void main() {
  testWidgets('renders onboarding copy', (tester) async {
    await tester.pumpWidget(const SocraticAiApp());

    expect(find.text('Learn by Thinking'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
