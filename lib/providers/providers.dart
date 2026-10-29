import 'package:flutter/foundation.dart';
import '../models/models.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalItemCount =>
      _items.fold(0, (previous, item) => previous + item.quantity);

  double get subtotal =>
      _items.fold(0.0, (previous, item) => previous + item.totalPrice);

  double get deliveryFee => subtotal > 35.0 || _items.isEmpty ? 0.0 : 3.99;

  double get estimatedTax => subtotal * 0.08;

  double get grandTotal => subtotal + deliveryFee + estimatedTax;

  void addToCart(Product product, {int quantity = 1}) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  void updateQuantity(int productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index].quantity = quantity;
      notifyListeners();
    }
  }

  void removeFromCart(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

class WishlistProvider extends ChangeNotifier {
  final Set<int> _wishlistProductIds = {};

  Set<int> get wishlistProductIds => Set.unmodifiable(_wishlistProductIds);

  bool isWishlisted(int productId) => _wishlistProductIds.contains(productId);

  void toggleWishlist(int productId) {
    if (_wishlistProductIds.contains(productId)) {
      _wishlistProductIds.remove(productId);
    } else {
      _wishlistProductIds.add(productId);
    }
    notifyListeners();
  }
}

class AuthProvider extends ChangeNotifier {
  UserProfile? _user;
  final List<OrderItem> _orders = [];

  UserProfile? get user => _user;
  bool get isAuthenticated => _user != null;
  List<OrderItem> get orders => List.unmodifiable(_orders);

  AuthProvider() {
    // Default logged in user for testing/demo
    _user = UserProfile(
      id: 'usr_001',
      name: 'VeriMart Customer',
      email: 'customer@verimart.com',
      phone: '+1 (555) 019-2834',
      address: '742 Evergreen Terrace, Springfield, OR',
    );
  }

  void login(String email, String password) {
    _user = UserProfile(
      id: 'usr_001',
      name: email.split('@').first,
      email: email,
      phone: '+1 (555) 019-2834',
      address: '742 Evergreen Terrace, Springfield, OR',
    );
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }

  void placeOrder(List<CartItem> cartItems, double totalAmount) {
    final order = OrderItem(
      id: 'VM-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
      items: List.from(cartItems),
      totalAmount: totalAmount,
      orderDate: DateTime.now(),
      status: 'Processing',
      shippingAddress: _user?.address ?? 'Standard Express Delivery Address',
    );
    _orders.insert(0, order);
    notifyListeners();
  }
}
