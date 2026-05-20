import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_project/main.dart';

void main() {
  testWidgets('Uygulama başlığı ve alt menü görünür', (WidgetTester tester) async {
    await tester.pumpWidget(const HavaDurumuApp());
    await tester.pump();

    expect(find.text('Hava Durumu Notları'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Şehir Ara'), findsOneWidget);
    expect(find.text('Notlar'), findsOneWidget);
  });
}
