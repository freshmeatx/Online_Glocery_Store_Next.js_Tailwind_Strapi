import 'package:flutter_test/flutter_test.dart';
import 'package:verimart_marketplace/models/models.dart';
import 'package:verimart_marketplace/providers/providers.dart';
import 'package:verimart_marketplace/services/api_service.dart';

void main() {
  group('CartProvider Unit Tests', () {
    late CartProvider cartProvider;
    late Product sampleProduct;

    setUp(() {
      cartProvider = CartProvider();
      sampleProduct = Product(
        id: 1,
        name: 'Test Apple',
        description: 'Fresh apple',
        price: 2.50,
        category: 'Fruits',
        imageUrl: 'https://example.com/apple.jpg',
      );
    });

    test('Initial cart is empty', () {
      expect(cartProvider.items, isEmpty);
      expect(cartProvider.totalItemCount, equals(0));
      expect(cartProvider.subtotal, equals(0.0));
    });

    test('Adding product increases item count and subtotal', () {
      cartProvider.addToCart(sampleProduct, quantity: 2);
      expect(cartProvider.items.length, equals(1));
      expect(cartProvider.totalItemCount, equals(2));
      expect(cartProvider.subtotal, equals(5.00));
    });

    test('Updating quantity adjusts cart totals', () {
      cartProvider.addToCart(sampleProduct, quantity: 1);
      cartProvider.updateQuantity(sampleProduct.id, 5);
      expect(cartProvider.totalItemCount, equals(5));
      expect(cartProvider.subtotal, equals(12.50));
    });

    test('Removing product clears items from cart', () {
      cartProvider.addToCart(sampleProduct, quantity: 2);
      cartProvider.removeFromCart(sampleProduct.id);
      expect(cartProvider.items, isEmpty);
      expect(cartProvider.totalItemCount, equals(0));
    });
  });

  group('ApiService Unit Tests', () {
    late ApiService apiService;

    setUp(() {
      apiService = ApiService();
    });

    test('Fetch banners returns items', () async {
      final banners = await apiService.getBanners();
      expect(banners, isNotEmpty);
      expect(banners.first.title, contains('VeriMart'));
    });

    test('Fetch categories returns list of categories', () async {
      final categories = await apiService.getCategories();
      expect(categories, isNotEmpty);
    });

    test('Search products filters by name query', () async {
      final results = await apiService.searchProducts('Apple');
      expect(results, isNotEmpty);
      expect(results.first.name, contains('Apple'));
    });
  });
}
