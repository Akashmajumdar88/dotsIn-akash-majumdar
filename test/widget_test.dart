import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dotsin_akashmajumdar/main.dart';

void main() {
  testWidgets('Health Data Hub smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: HealthDataHubApp()),
    );
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
