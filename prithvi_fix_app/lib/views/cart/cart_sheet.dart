import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/animations/spring_curves.dart';
import '../../providers/cart_provider.dart';

/// Itemized Cart Drawer & 93-2-5 Statutory Escrow Tariff Transparency Card
class CartSheet extends StatelessWidget {
  final CartProvider cart;
  final VoidCallback onProceedToCheckout;

  const CartSheet({
    Key? key,
    required this.cart,
    required this.onProceedToCheckout,
  }) : super(key: key);

  static void show(BuildContext context, CartProvider cart, VoidCallback onProceed) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AnimatedBuilder(
        animation: cart,
        builder: (context, _) => CartSheet(cart: cart, onProceedToCheckout: onProceed),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = cart.items.values.toList();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 44,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Service Cart (${cart.totalItemCount})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              if (items.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    cart.clearCart();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Clear All',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentCoral,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Items List
          if (items.isEmpty)
            const Expanded(
              child: Center(
                child: Text('Your cart is empty.'),
              ),
            )
          else
            Expanded(
              child: ListView(
                children: [
                  // Itemized Cards
                  ...items.map((item) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.service.name,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                item.service.formattedPrice,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.accentTeal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Counter
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => cart.removeService(item.service),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                  child: Icon(Icons.remove, size: 14, color: AppColors.textPrimary),
                                ),
                              ),
                              Text(
                                '${item.quantity}',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                              ),
                              GestureDetector(
                                onTap: () => cart.addService(item.service),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                  child: Icon(Icons.add, size: 14, color: AppColors.textPrimary),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),

                  const SizedBox(height: 12),

                  // 🏛️ STATUTORY 93-2-5 ESCROW TRANSPARENCY CARD
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF1A365D).withOpacity(0.06),
                          const Color(0xFF0D9488).withOpacity(0.08),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFF0D9488).withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.account_balance_rounded, color: AppColors.primary, size: 18),
                            SizedBox(width: 8),
                            Text(
                              '93-2-5 Cooperative Escrow Tariff',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _buildEscrowRow('93% Direct Living Wage to Artisan:', '₹${cart.workerDirectWage93.toStringAsFixed(2)}', isBold: true),
                        _buildEscrowRow('5% Worker Mini-PF & ESIC Insurance:', '₹${cart.welfareFund5.toStringAsFixed(2)}'),
                        _buildEscrowRow('2% Cooperative Platform Upkeep:', '₹${cart.platformUpkeep2.toStringAsFixed(2)}'),
                        const Divider(height: 18),
                        _buildEscrowRow('Total Regulated Tariff:', '₹${cart.subtotal.toStringAsFixed(2)}', isBold: true, highlight: true),
                        const SizedBox(height: 6),
                        const Text(
                          'Zero middleman commission • 100% transparent statutory pricing',
                          style: TextStyle(fontSize: 10.5, color: AppColors.textMuted, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          if (items.isNotEmpty) ...[
            const SizedBox(height: 16),
            BouncingWidget(
              onTap: () {
                Navigator.pop(context);
                onProceedToCheckout();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    'Proceed to Booking Slot • ₹${cart.subtotal.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEscrowRow(String label, String value, {bool isBold = false, bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: highlight ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              color: highlight ? AppColors.accentTeal : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
