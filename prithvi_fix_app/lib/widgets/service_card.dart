import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/animations/spring_curves.dart';
import '../models/service_model.dart';
import '../providers/cart_provider.dart';
import '../views/services/service_detail_screen.dart';
import 'custom_image.dart';
import 'whats_included_sheet.dart';

/// Urban Company-grade interactive service product card
/// Features 4:3 high-res photo, rating badge, price tag, and dynamic Add/Counter button.
class ServiceCard extends StatelessWidget {
  final ServiceItem service;
  final CartProvider cart;

  const ServiceCard({
    Key? key,
    required this.service,
    required this.cart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final quantity = cart.getQuantity(service.id);

    return BouncingWidget(
      onTap: () => WhatsIncludedSheet.show(context, service, cart),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: High-Res 4:3 Photo with duration badge (tap opens full 5-step details)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ServiceDetailScreen(service: service, cart: cart),
                  ),
                );
              },
              child: Stack(
                children: [
                  CustomImage(
                    imageInfo: service.imageInfo,
                    width: 110,
                    height: 95,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  Positioned(
                    bottom: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${service.durationMinutes}m',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Middle: Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.localizedName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.2,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Rating pill
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: AppColors.accentAmber, size: 15),
                      const SizedBox(width: 3),
                      Text(
                        '${service.rating} (${service.reviewCount})',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Price & Add Button Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        service.formattedPrice,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      // Add / Quantity Controller Button
                      _buildAddButton(context, quantity),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context, int quantity) {
    if (quantity == 0) {
      return BouncingWidget(
        onTap: () => cart.addService(service),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.accentTeal, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentTeal.withOpacity(0.12),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'ADD',
                style: TextStyle(
                  color: AppColors.accentTeal,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(width: 3),
              Icon(Icons.add, color: AppColors.accentTeal, size: 14),
            ],
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => cart.removeService(service),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Icon(Icons.remove, color: Colors.white, size: 14),
              ),
            ),
            Text(
              '$quantity',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
            GestureDetector(
              onTap: () => cart.addService(service),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Icon(Icons.add, color: Colors.white, size: 14),
              ),
            ),
          ],
        ),
      );
    }
  }
}
