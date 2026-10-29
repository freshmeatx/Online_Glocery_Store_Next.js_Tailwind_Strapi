import 'package:flutter/material.dart';
import 'models/models.dart';
import 'providers/providers.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/home_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/profile_screen.dart';
import 'services/api_service.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const VeriMartApp());
}

class VeriMartApp extends StatefulWidget {
  const VeriMartApp({super.key});

  @override
  State<VeriMartApp> createState() => _VeriMartAppState();
}

class _VeriMartAppState extends State<VeriMartApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final ApiService _apiService = ApiService();
  final CartProvider _cartProvider = CartProvider();
  final WishlistProvider _wishlistProvider = WishlistProvider();
  final AuthProvider _authProvider = AuthProvider();

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _cartProvider.addListener(_onStateChange);
    _wishlistProvider.addListener(_onStateChange);
    _authProvider.addListener(_onStateChange);
  }

  @override
  void dispose() {
    _cartProvider.removeListener(_onStateChange);
    _wishlistProvider.removeListener(_onStateChange);
    _authProvider.removeListener(_onStateChange);
    super.dispose();
  }

  void _onStateChange() {
    setState(() {});
  }

  void _navigateToProductDetail(Product product) {
    _navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(
          product: product,
          cartProvider: _cartProvider,
          wishlistProvider: _wishlistProvider,
        ),
      ),
    );
  }

  void _openCheckout() {
    _navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => CheckoutScreen(
          cartProvider: _cartProvider,
          authProvider: _authProvider,
          onOrderPlaced: () {
            setState(() => _currentIndex = 1);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(
        apiService: _apiService,
        cartProvider: _cartProvider,
        wishlistProvider: _wishlistProvider,
        authProvider: _authProvider,
        onProductTap: _navigateToProductDetail,
        onOpenCart: () => setState(() => _currentIndex = 2),
        onCategorySelected: (cat) {},
        onSelectTab: (index) => setState(() => _currentIndex = index),
      ),
      OrdersScreen(authProvider: _authProvider),
      CartScreen(
        cartProvider: _cartProvider,
        authProvider: _authProvider,
        onCheckout: _openCheckout,
        onStartShopping: () => setState(() => _currentIndex = 0),
      ),
      ProfileScreen(authProvider: _authProvider),
    ];

    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'VeriMart Marketplace',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: AppTheme.secondaryTextColor,
          type: BottomNavigationBarType.fixed,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.storefront_outlined),
              activeIcon: Icon(Icons.storefront),
              label: 'Shop',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_outlined),
              activeIcon: Icon(Icons.inventory_2),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                label: Text('${_cartProvider.totalItemCount}'),
                isLabelVisible: _cartProvider.totalItemCount > 0,
                child: const Icon(Icons.shopping_cart_outlined),
              ),
              activeIcon: Badge(
                label: Text('${_cartProvider.totalItemCount}'),
                isLabelVisible: _cartProvider.totalItemCount > 0,
                child: const Icon(Icons.shopping_cart),
              ),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}
