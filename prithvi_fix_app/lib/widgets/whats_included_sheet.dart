import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/animations/spring_curves.dart';
import '../models/service_model.dart';
import '../providers/cart_provider.dart';
import '../views/services/service_detail_screen.dart';
import 'custom_image.dart';

/// Bottom modal displaying full-bleed photo, itemized checklist, and instant add
class WhatsIncludedSheet extends StatelessWidget {
  final ServiceItem service;
  final CartProvider cart;

  const WhatsIncludedSheet({
    Key? key,
    required this.service,
    required this.cart,
  }) : super(key: key);

  static void show(BuildContext context, ServiceItem service, CartProvider cart) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => WhatsIncludedSheet(service: service, cart: cart),
    );
  }

  @override
  Widget build(BuildContext context) {
    final quantity = cart.getQuantity(service.id);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 12),
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),

          // High-Res Hero Photo
          CustomImage(
            imageInfo: service.imageInfo,
            height: 200,
            borderRadius: BorderRadius.circular(16),
          ),
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service Title
                Text(
                  service.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),

                // Rating & Duration row
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: AppColors.accentAmber, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '${service.rating} (${service.reviewCount} reviews)',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.schedule_rounded, color: AppColors.textMuted, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${service.durationMinutes} mins',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Price pill
                Row(
                  children: [
                    Text(
                      service.formattedPrice,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.accentEmeraldLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Zero Surge Fee',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accentEmerald,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Description
                Text(
                  service.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),

                // What's Included Section
                if (service.included.isNotEmpty) ...[
                  const Text(
                    "What's Included",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...service.included.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle_rounded, color: AppColors.accentEmerald, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item,
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  )),
                  const SizedBox(height: 12),
                ],

                // Action Buttons
                const SizedBox(height: 10),
                BouncingWidget(
                  onTap: () {
                    cart.addService(service);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        quantity > 0 ? 'Add Another (${quantity} in cart)' : 'Add to Cart • ${service.formattedPrice}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                BouncingWidget(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ServiceDetailScreen(service: service, cart: cart),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Center(
                      child: Text(
                        'View 5-Step Process & Certified Parts ➔',
                        style: TextStyle(
                          color: AppColors.accentTeal,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
