import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verimart_marketplace/main.dart';

void main() {
  testWidgets('VeriMart Marketplace main screen loads correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(const VeriMartApp());
    await tester.pumpAndSettle();

    expect(find.text('VeriMart'), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Featured Products'), findsOneWidget);
  });

  testWidgets('Tapping product card navigates to product details screen',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const VeriMartApp());
    await tester.pumpAndSettle();

    final productFinder = find.text('Organic Honeycrisp Apples');
    await tester.ensureVisible(productFinder);
    await tester.pumpAndSettle();

    await tester.tap(productFinder);
    await tester.pumpAndSettle();

    expect(find.text('Description'), findsOneWidget);
    expect(find.text('Unit: 1 lb bag'), findsOneWidget);
  });

  testWidgets('Cart and Checkout navigation works', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const VeriMartApp());
    await tester.pumpAndSettle();

    final addToCartFinder = find.text('Add to Cart').first;
    await tester.ensureVisible(addToCartFinder);
    await tester.pumpAndSettle();

    await tester.tap(addToCartFinder);
    await tester.pumpAndSettle();

    // Tap BottomNavigationBar Cart tab
    await tester.tap(find.text('Cart'));
    await tester.pumpAndSettle();

    expect(find.text('Proceed to Checkout'), findsOneWidget);

    await tester.tap(find.text('Proceed to Checkout'));
    await tester.pumpAndSettle();

    expect(find.text('Shipping Address'), findsOneWidget);
    expect(find.text('Place Order'), findsOneWidget);
  });
}
