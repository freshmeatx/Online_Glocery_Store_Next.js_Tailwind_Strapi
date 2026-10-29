class Category {
  final int id;
  final String name;
  final String iconUrl;
  final String colorHex;

  Category({
    required this.id,
    required this.name,
    required this.iconUrl,
    this.colorHex = '0xFF0F766E',
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['attributes']?['name'] ?? json['name'] ?? '',
      iconUrl: json['attributes']?['icon']?['data']?['attributes']?['url'] ??
          json['iconUrl'] ??
          '',
      colorHex: json['colorHex'] ?? '0xFF0F766E',
    );
  }
}

class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final String category;
  final String imageUrl;
  final bool isAvailable;
  final double rating;
  final String unit;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.category,
    required this.imageUrl,
    this.isAvailable = true,
    this.rating = 4.8,
    this.unit = '1 item',
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final attrs = json['attributes'] ?? json;
    return Product(
      id: json['id'] ?? 0,
      name: attrs['name'] ?? '',
      description: attrs['description'] ?? '',
      price: (attrs['mrp'] ?? attrs['price'] ?? 0).toDouble(),
      originalPrice: attrs['originalPrice'] != null
          ? (attrs['originalPrice']).toDouble()
          : null,
      category: attrs['category'] ?? 'General',
      imageUrl: attrs['images']?['data']?[0]?['attributes']?['url'] ??
          attrs['imageUrl'] ??
          '',
      isAvailable: attrs['isAvailable'] ?? true,
      rating: (attrs['rating'] ?? 4.8).toDouble(),
      unit: attrs['unit'] ?? '1 item',
    );
  }
}

class BannerItem {
  final int id;
  final String title;
  final String subtitle;
  final String imageUrl;

  BannerItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;
}

class OrderItem {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime orderDate;
  final String status;
  final String shippingAddress;

  OrderItem({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    required this.status,
    required this.shippingAddress,
  });
}

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });
}
