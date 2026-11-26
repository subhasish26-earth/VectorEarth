import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/animations/spring_curves.dart';
import '../../core/constants/app_images.dart';
import '../../core/constants/service_sop_catalog.dart';
import '../../core/constants/locked_parts_catalog.dart';
import '../../models/service_model.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/custom_image.dart';
import '../checkout/checkout_screen.dart';

/// Full-Page Urban Company-Grade Service Detail Screen
/// Features full-bleed hero photo, 5-Step Visual Process Guide, locked parts catalog, and reviews.
class ServiceDetailScreen extends StatefulWidget {
  final ServiceItem service;
  final CartProvider cart;
  final VoidCallback? onProceedToCheckout;

  const ServiceDetailScreen({
    Key? key,
    required this.service,
    required this.cart,
    this.onProceedToCheckout,
  }) : super(key: key);

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  int _activeProcessStep = 0;
  late final ServiceSopData _sopData;
  late final List<LockedPartItem> _lockedSpares;

  @override
  void initState() {
    super.initState();
    _sopData = ServiceSopCatalog.getSopForService(widget.service.name);
    _lockedSpares = ServiceLockedPartsCatalog.getPartsForCategory(widget.service.category, widget.service.name);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.cart,
      builder: (context, _) {
        final qty = widget.cart.getQuantity(widget.service.id);

        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 1. Full-Bleed Collapsible Hero Image Header
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                elevation: 0,
                backgroundColor: AppColors.primary,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      CustomImage(
                        imageInfo: widget.service.imageInfo,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.8),
                              Colors.transparent,
                              Colors.black.withOpacity(0.6),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.accentTeal,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                widget.service.category.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.service.localizedName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Rating, Price & Zero-Surge Card
              SliverToBoxAdapter(
                child: Container(
                  color: AppColors.surface,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.service.formattedPrice,
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.accentEmeraldLight,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  '93% to Artisan',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.accentEmerald,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Dynamic Add button
                          _buildQuantityButton(qty),
                        ],
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: AppColors.accentAmber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.service.rating} (${widget.service.reviewCount} verified reviews)',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
                          ),
                          const SizedBox(width: 14),
                          const Icon(Icons.timer_outlined, color: AppColors.textMuted, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.service.durationMinutes} mins',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      Text(
                        widget.service.description,
                        style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.45),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 12)),

              // 3. 5-STEP VISUAL SERVICE PROCESS GUIDE
              SliverToBoxAdapter(child: _buildVisualProcessSection()),

              const SliverToBoxAdapter(child: SizedBox(height: 12)),

              // 4. LOCKED SPARE PARTS CATALOG PREVIEW
              SliverToBoxAdapter(child: _buildLockedPartsSection()),

              const SliverToBoxAdapter(child: SizedBox(height: 12)),

              // 5. 30-DAY WORKMANSHIP GUARANTEE CARD
              SliverToBoxAdapter(child: _buildWarrantyCard()),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),

          // Bottom Bar
          bottomNavigationBar: _buildBottomCheckoutBar(qty),
        );
      },
    );
  }

  Widget _buildQuantityButton(int qty) {
    if (qty == 0) {
      return BouncingWidget(
        onTap: () => widget.cart.addService(widget.service),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Text(
            'ADD',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => widget.cart.removeService(widget.service),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Icon(Icons.remove, color: Colors.white, size: 16),
              ),
            ),
            Text(
              '$qty',
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800),
            ),
            GestureDetector(
              onTap: () => widget.cart.addService(widget.service),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Icon(Icons.add, color: Colors.white, size: 16),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildVisualProcessSection() {
    final steps = _sopData.steps;
    final currentStep = steps[_activeProcessStep];

    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '5-Step Service Process',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Step ${_activeProcessStep + 1} of ${steps.length}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.accentTeal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Horizontal step indicator pills
          Row(
            children: List.generate(steps.length, (index) {
              final isSelected = _activeProcessStep == index;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _activeProcessStep = index),
                  child: Container(
                    height: 5,
                    margin: EdgeInsets.only(right: index == steps.length - 1 ? 0 : 6),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.accentTeal : AppColors.border,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),

          // Active Step Photo with Left/Right arrow overlay buttons
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CustomImage(
                  imageInfo: currentStep.imageInfo,
                  height: 190,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // Left arrow overlay button
              if (_activeProcessStep > 0)
                Positioned(
                  left: 10,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: () => setState(() => _activeProcessStep--),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.45),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                ),
              // Right arrow overlay button (Next)
              if (_activeProcessStep < steps.length - 1)
                Positioned(
                  right: 10,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: () => setState(() => _activeProcessStep++),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.45),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                ),
              // Step badge on image
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.65),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Step ${_activeProcessStep + 1} of ${steps.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Active Step Title
          Text(
            '${currentStep.step}. ${currentStep.title}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          // Active Step Exact Single Sentence Description
          Text(
            currentStep.sentence,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),

          // Next Step & Navigation Buttons
          Row(
            children: [
              if (_activeProcessStep > 0) ...[
                OutlinedButton.icon(
                  onPressed: () => setState(() => _activeProcessStep--),
                  icon: const Icon(Icons.arrow_back_rounded, size: 16),
                  label: const Text('Previous'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.border, width: 1.2),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (_activeProcessStep < steps.length - 1) {
                        _activeProcessStep++;
                      } else {
                        _activeProcessStep = 0;
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _activeProcessStep < steps.length - 1
                            ? 'Next Step (${_activeProcessStep + 2}/${steps.length})'
                            : 'Restart from Step 1',
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _activeProcessStep < steps.length - 1
                            ? Icons.arrow_forward_rounded
                            : Icons.replay_rounded,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          if (_sopData.equipment.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 14),
            Row(
              children: const [
                Icon(Icons.handyman_rounded, size: 16, color: AppColors.accentTeal),
                SizedBox(width: 6),
                Text(
                  'Required Cooperative Equipment',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _sopData.equipment.map((tool) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  tool,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLockedPartsSection() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.lock_clock_rounded, color: AppColors.accentTeal, size: 20),
              SizedBox(width: 8),
              Text(
                'Locked Cooperative Parts Catalog',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Government-regulated rates. Artisans cannot overcharge for replacements.',
            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 14),

          ..._lockedSpares.map((part) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        part.name,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Warranty: ${part.warranty}',
                        style: const TextStyle(fontSize: 11, color: AppColors.accentEmerald, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      part.coopPrice,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                    ),
                    Text(
                      part.mrp,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildWarrantyCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7).withOpacity(0.5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.3)),
      ),
      child: Row(
        children: const [
          Icon(Icons.shield_rounded, color: AppColors.accentAmber, size: 36),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '30-Day Free Workmanship Warranty',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF92400E)),
                ),
                SizedBox(height: 2),
                Text(
                  'If the same defect resurfaces within 30 days, we re-dispatch a Master Artisan at ₹0 cost.',
                  style: TextStyle(fontSize: 12, color: Color(0xFFB45309)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomCheckoutBar(int qty) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total Regulated Tariff', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                Text(
                  widget.service.formattedPrice,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
          BouncingWidget(
            onTap: () {
              if (qty == 0) widget.cart.addService(widget.service);
              if (widget.onProceedToCheckout != null) {
                widget.onProceedToCheckout!();
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CheckoutScreen(cart: widget.cart),
                  ),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                'Book Service ➔',
                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
