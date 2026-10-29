import 'package:flutter/material.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  final ApiService apiService;
  final CartProvider cartProvider;
  final WishlistProvider wishlistProvider;
  final AuthProvider authProvider;
  final Function(Product) onProductTap;
  final VoidCallback onOpenCart;
  final Function(String) onCategorySelected;
  final ValueChanged<int> onSelectTab;

  const HomeScreen({
    super.key,
    required this.apiService,
    required this.cartProvider,
    required this.wishlistProvider,
    required this.authProvider,
    required this.onProductTap,
    required this.onOpenCart,
    required this.onCategorySelected,
    required this.onSelectTab,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<BannerItem> banners = [];
  List<Category> categories = [];
  List<Product> products = [];
  bool isLoading = true;
  String selectedCategory = 'All';
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    final b = await widget.apiService.getBanners();
    final c = await widget.apiService.getCategories();
    final p = await widget.apiService.getAllProducts();
    if (mounted) {
      setState(() {
        banners = b;
        categories = [Category(id: 0, name: 'All', iconUrl: '🛍️'), ...c];
        products = p;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = products.where((p) {
      final matchesCat = selectedCategory == 'All' ||
          p.category.toLowerCase() == selectedCategory.toLowerCase();
      final matchesSearch =
          p.name.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCat && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: CustomHeader(
        title: 'VeriMart',
        cartBadgeCount: widget.cartProvider.totalItemCount,
        onCartPressed: widget.onOpenCart,
      ),
      drawer: AppDrawer(
        onNavigateHome: () => widget.onSelectTab(0),
        onNavigateOrders: () => widget.onSelectTab(1),
        onNavigateProfile: () => widget.onSelectTab(3),
        onNavigateSettings: () => _showSettingsDialog(context),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Bar
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search products, brands, categories...',
                        prefixIcon: const Icon(Icons.search,
                            color: AppTheme.primaryColor),
                        suffixIcon: searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() => searchQuery = '');
                                },
                              )
                            : null,
                      ),
                      onChanged: (val) {
                        setState(() => searchQuery = val);
                      },
                    ),
                    const SizedBox(height: 16),

                    // Banners
                    if (banners.isNotEmpty) ...[
                      SizedBox(
                        height: 140,
                        child: PageView.builder(
                          itemCount: banners.length,
                          itemBuilder: (context, index) {
                            final b = banners[index];
                            return Container(
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: const LinearGradient(
                                  colors: [
                                    AppTheme.primaryColor,
                                    AppTheme.primaryDark,
                                  ],
                                ),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          b.title,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          b.subtitle,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.local_offer_outlined,
                                    color: Colors.white,
                                    size: 48,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Categories
                    const Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final cat = categories[index];
                          return CategoryChip(
                            category: cat,
                            isSelected: selectedCategory == cat.name,
                            onTap: () {
                              setState(() => selectedCategory = cat.name);
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Products Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedCategory == 'All'
                              ? 'Featured Products'
                              : '$selectedCategory Products',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textColor,
                          ),
                        ),
                        Text(
                          '${filteredProducts.length} items',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Products Grid
                    filteredProducts.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Center(
                              child: Text('No products found.'),
                            ),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.65,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: filteredProducts.length,
                            itemBuilder: (context, index) {
                              final p = filteredProducts[index];
                              return ProductCard(
                                product: p,
                                isWishlisted:
                                    widget.wishlistProvider.isWishlisted(p.id),
                                onTap: () => widget.onProductTap(p),
                                onAddToCart: () {
                                  widget.cartProvider.addToCart(p);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Added ${p.name} to cart!'),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                                onToggleWishlist: () {
                                  widget.wishlistProvider.toggleWishlist(p.id);
                                },
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('VeriMart Settings'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('App Version: 1.0.0'),
            SizedBox(height: 8),
            Text('Application ID: com.verimart.marketplace'),
            SizedBox(height: 8),
            Text('Marketplace Identity: VeriMart Marketplace'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
