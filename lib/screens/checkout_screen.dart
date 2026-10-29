import 'package:flutter/material.dart';
import '../providers/providers.dart';
import '../theme/app_theme.dart';

class CheckoutScreen extends StatefulWidget {
  final CartProvider cartProvider;
  final AuthProvider authProvider;
  final VoidCallback onOrderPlaced;

  const CheckoutScreen({
    super.key,
    required this.cartProvider,
    required this.authProvider,
    required this.onOrderPlaced,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String selectedPaymentMethod = 'Credit Card';

  @override
  Widget build(BuildContext context) {
    final user = widget.authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Shipping Address',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.location_on, color: AppTheme.primaryColor),
                title: Text(user?.name ?? 'VeriMart Customer'),
                subtitle: Text(user?.address ?? 'Standard Delivery Address'),
                trailing: TextButton(
                  onPressed: () {},
                  child: const Text('Change'),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Payment Method',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.credit_card, color: AppTheme.primaryColor),
                    title: const Text('Credit or Debit Card'),
                    trailing: selectedPaymentMethod == 'Credit Card'
                        ? const Icon(Icons.check_circle, color: AppTheme.primaryColor)
                        : null,
                    onTap: () => setState(() => selectedPaymentMethod = 'Credit Card'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.account_balance_wallet, color: AppTheme.primaryColor),
                    title: const Text('VeriMart Pay / Wallet'),
                    trailing: selectedPaymentMethod == 'VeriMart Pay'
                        ? const Icon(Icons.check_circle, color: AppTheme.primaryColor)
                        : null,
                    onTap: () => setState(() => selectedPaymentMethod = 'VeriMart Pay'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.payments, color: AppTheme.primaryColor),
                    title: const Text('Cash on Delivery (COD)'),
                    trailing: selectedPaymentMethod == 'COD'
                        ? const Icon(Icons.check_circle, color: AppTheme.primaryColor)
                        : null,
                    onTap: () => setState(() => selectedPaymentMethod = 'COD'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Order Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Items (${widget.cartProvider.totalItemCount})'),
                        Text('\$${widget.cartProvider.subtotal.toStringAsFixed(2)}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Delivery'),
                        Text(widget.cartProvider.deliveryFee == 0
                            ? 'FREE'
                            : '\$${widget.cartProvider.deliveryFee.toStringAsFixed(2)}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tax'),
                        Text('\$${widget.cartProvider.estimatedTax.toStringAsFixed(2)}'),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${widget.cartProvider.grandTotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  widget.authProvider.placeOrder(
                    widget.cartProvider.items,
                    widget.cartProvider.grandTotal,
                  );
                  widget.cartProvider.clearCart();
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (ctx) => AlertDialog(
                      title: const Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green, size: 28),
                          SizedBox(width: 8),
                          Text('Order Placed!'),
                        ],
                      ),
                      content: const Text(
                        'Thank you for shopping at VeriMart Marketplace! Your order is now processing.',
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            Navigator.pop(context);
                            widget.onOrderPlaced();
                          },
                          child: const Text('Back to Home'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Place Order'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
