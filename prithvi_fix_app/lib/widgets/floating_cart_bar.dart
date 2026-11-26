import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/animations/spring_curves.dart';
import '../providers/cart_provider.dart';

/// Urban Company-grade floating bottom cart bar
/// Slides up smoothly from the bottom whenever items are present in cart.
class FloatingCartBar extends StatelessWidget {
  final CartProvider cart;
  final VoidCallback onViewCart;

  const FloatingCartBar({
    Key? key,
    required this.cart,
    required this.onViewCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasItems = cart.totalItemCount > 0;

    return AnimatedSlide(
      offset: hasItems ? Offset.zero : const Offset(0, 1.5),
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: hasItems ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 250),
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            gradient: AppColors.cartGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              // Items count & Total Price
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.accentTeal,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${cart.totalItemCount} ${cart.totalItemCount == 1 ? "SERVICE" : "SERVICES"}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '₹${cart.subtotal.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      '93% goes directly to certified artisan',
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Action button
              BouncingWidget(
                onTap: onViewCart,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.accentTeal,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View Cart',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
