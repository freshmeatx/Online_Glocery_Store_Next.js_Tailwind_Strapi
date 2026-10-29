import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class ApiService {
  final String baseUrl;
  final http.Client _client;

  ApiService({
    this.baseUrl = 'http://127.0.0.1:1337/api',
    http.Client? client,
  }) : _client = client ?? http.Client();

  static final List<BannerItem> _defaultBanners = [
    BannerItem(
      id: 1,
      title: 'VeriMart Fresh Market',
      subtitle: 'Get up to 30% off organic fresh produce',
      imageUrl: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800',
    ),
    BannerItem(
      id: 2,
      title: 'Daily Essentials & Grocery',
      subtitle: 'Free Express Delivery on orders over \$35',
      imageUrl: 'https://images.unsplash.com/photo-1578916171728-46686eac8d58?w=800',
    ),
    BannerItem(
      id: 3,
      title: 'Top Verified Sellers',
      subtitle: 'Quality verified products straight to your door',
      imageUrl: 'https://images.unsplash.com/photo-1608686207856-001b95cf60ca?w=800',
    ),
  ];

  static final List<Category> _defaultCategories = [
    Category(id: 1, name: 'Fruits & Veggies', iconUrl: '🍎'),
    Category(id: 2, name: 'Dairy & Eggs', iconUrl: '🥛'),
    Category(id: 3, name: 'Bakery & Snacks', iconUrl: '🍞'),
    Category(id: 4, name: 'Beverages', iconUrl: '🧃'),
    Category(id: 5, name: 'Meat & Seafood', iconUrl: '🥩'),
    Category(id: 6, name: 'Pantry & Organic', iconUrl: '🌾'),
  ];

  static final List<Product> _defaultProducts = [
    Product(
      id: 101,
      name: 'Organic Honeycrisp Apples',
      description: 'Crisp, sweet, and locally sourced premium organic apples.',
      price: 3.99,
      originalPrice: 4.99,
      category: 'Fruits & Veggies',
      imageUrl: 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=600',
      isAvailable: true,
      rating: 4.9,
      unit: '1 lb bag',
    ),
    Product(
      id: 102,
      name: 'Fresh Farm Whole Milk',
      description: 'Pasteurized, nutrient-rich fresh whole milk from grass-fed cows.',
      price: 4.29,
      originalPrice: 4.89,
      category: 'Dairy & Eggs',
      imageUrl: 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=600',
      isAvailable: true,
      rating: 4.8,
      unit: '1 Gallon',
    ),
    Product(
      id: 103,
      name: 'Artisanal Sourdough Bread',
      description: 'Freshly baked daily with natural starter and no preservatives.',
      price: 5.49,
      originalPrice: 6.29,
      category: 'Bakery & Snacks',
      imageUrl: 'https://images.unsplash.com/photo-1589367920969-ab8e050bbb04?w=600',
      isAvailable: true,
      rating: 4.7,
      unit: '1 Loaf',
    ),
    Product(
      id: 104,
      name: 'Cold-Pressed Orange Juice',
      description: '100% pure squeezed Florida oranges with pulpy goodness.',
      price: 4.99,
      category: 'Beverages',
      imageUrl: 'https://images.unsplash.com/photo-1621506289937-a8e4df240d0b?w=600',
      isAvailable: true,
      rating: 4.9,
      unit: '59 fl oz',
    ),
    Product(
      id: 105,
      name: 'Grass-Fed Ribeye Steak',
      description: 'USDA Prime tender, juicy ribeye steak cut fresh daily.',
      price: 18.99,
      originalPrice: 21.99,
      category: 'Meat & Seafood',
      imageUrl: 'https://images.unsplash.com/photo-1603048588665-791ca8aea617?w=600',
      isAvailable: true,
      rating: 5.0,
      unit: '16 oz',
    ),
    Product(
      id: 106,
      name: 'Extra Virgin Olive Oil',
      description: 'Cold-extracted Mediterranean organic olive oil for gourmet cooking.',
      price: 12.99,
      originalPrice: 15.00,
      category: 'Pantry & Organic',
      imageUrl: 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=600',
      isAvailable: true,
      rating: 4.8,
      unit: '750 ml bottle',
    ),
  ];

  Future<List<BannerItem>> getBanners() async {
    try {
      final response = await _client
          .get(Uri.parse('$baseUrl/sliders?populate=*'))
          .timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] is List && (data['data'] as List).isNotEmpty) {
          return (data['data'] as List).map((json) {
            final attrs = json['attributes'] ?? json;
            return BannerItem(
              id: json['id'] ?? 0,
              title: attrs['title'] ?? 'VeriMart Marketplace',
              subtitle: attrs['subtitle'] ?? 'Quality verified products',
              imageUrl: attrs['imageUrl'] ?? 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800',
            );
          }).toList();
        }
      }
    } catch (_) {}
    return _defaultBanners;
  }

  Future<List<Category>> getCategories() async {
    try {
      final response = await _client
          .get(Uri.parse('$baseUrl/categories?populate=*'))
          .timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] is List && (data['data'] as List).isNotEmpty) {
          return (data['data'] as List)
              .map((json) => Category.fromJson(json))
              .toList();
        }
      }
    } catch (_) {}
    return _defaultCategories;
  }

  Future<List<Product>> getAllProducts() async {
    try {
      final response = await _client
          .get(Uri.parse('$baseUrl/products?populate=*'))
          .timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] is List && (data['data'] as List).isNotEmpty) {
          return (data['data'] as List)
              .map((json) => Product.fromJson(json))
              .toList();
        }
      }
    } catch (_) {}
    return _defaultProducts;
  }

  Future<List<Product>> getProductsByCategory(String categoryName) async {
    try {
      final response = await _client
          .get(Uri.parse(
              '$baseUrl/products?filters[categories][name][\$in]=$categoryName&populate=*'))
          .timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] is List && (data['data'] as List).isNotEmpty) {
          return (data['data'] as List)
              .map((json) => Product.fromJson(json))
              .toList();
        }
      }
    } catch (_) {}
    return _defaultProducts
        .where((p) => p.category.toLowerCase() == categoryName.toLowerCase())
        .toList();
  }

  Future<List<Product>> searchProducts(String query) async {
    final all = await getAllProducts();
    if (query.trim().isEmpty) return all;
    return all
        .where((p) =>
            p.name.toLowerCase().contains(query.toLowerCase()) ||
            p.description.toLowerCase().contains(query.toLowerCase()) ||
            p.category.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
