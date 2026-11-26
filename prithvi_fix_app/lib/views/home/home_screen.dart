import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/animations/spring_curves.dart';
import '../../core/constants/app_images.dart';
import '../../data/services_data.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/custom_image.dart';
import '../../widgets/floating_cart_bar.dart';
import '../../widgets/whats_included_sheet.dart';
import '../../providers/auth_provider.dart';
import '../../providers/localization_provider.dart';
import '../services/services_directory_screen.dart';
import '../auth/login_screen.dart';
import '../account/account_screen.dart';

/// Urban Company-grade Visual-First Home Screen
class HomeScreen extends StatefulWidget {
  final CartProvider cart;
  final VoidCallback onViewCart;
  final AuthProvider? auth;

  const HomeScreen({
    Key? key,
    required this.cart,
    required this.onViewCart,
    this.auth,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBannerIndex = 0;
  String _currentDistrict = 'Khordha';
  late PageController _pageController;
  Timer? _bannerTimer;

  static const List<String> _districts = [
    'Khordha',
    'Cuttack',
    'Puri',
  ];

  void _showLanguageDialog() {
    final loc = LocalizationProvider.instance;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Select Language / ଭାଷା ଚୟନ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English (Default)'),
              trailing: loc.currentLanguage == AppLanguage.english ? const Icon(Icons.check, color: AppColors.primary) : null,
              onTap: () {
                loc.setLanguage(AppLanguage.english);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('ଓଡ଼ିଆ (Odia)'),
              trailing: loc.currentLanguage == AppLanguage.odia ? const Icon(Icons.check, color: AppColors.primary) : null,
              onTap: () {
                loc.setLanguage(AppLanguage.odia);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('हिन्दी (Hindi)'),
              trailing: loc.currentLanguage == AppLanguage.hindi ? const Icon(Icons.check, color: AppColors.primary) : null,
              onTap: () {
                loc.setLanguage(AppLanguage.hindi);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const Text(
              'Select Service District',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Prithvi Fix Operating District',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
            const SizedBox(height: 16),
            ..._districts.map((district) {
              final isSelected = district == _currentDistrict;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.accentTealLight.withOpacity(0.4) : AppColors.background,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? AppColors.accentTeal : AppColors.border,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  leading: CircleAvatar(
                    backgroundColor: isSelected ? AppColors.accentTeal : AppColors.surface,
                    radius: 18,
                    child: Icon(
                      Icons.location_city_rounded,
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      size: 18,
                    ),
                  ),
                  title: Text(
                    '$district District',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  subtitle: const Text(
                    'Regional Federation Certified Services • Odisha',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle_rounded, color: AppColors.accentTeal, size: 22)
                      : null,
                  onTap: () {
                    setState(() {
                      _currentDistrict = district;
                    });
                    Navigator.pop(ctx);
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startBannerAutoScroll();
  }

  void _startBannerAutoScroll() {
    _bannerTimer?.cancel();
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final nextIndex = (_currentBannerIndex + 1) % ServicesData.heroBanners.length;
      _pageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToCategory(String categoryName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ServicesDirectoryScreen(
          initialCategory: categoryName,
          cart: widget.cart,
          onViewCart: widget.onViewCart,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.cart,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // 1. Sticky App Bar with Location & Search
                  _buildSliverHeader(),

                  // 2. Hero Promotional Carousel
                  SliverToBoxAdapter(child: _buildHeroCarousel()),

                  // 3. Category Visual Grid Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            LocalizationProvider.instance.tr('categories'),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.4,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _navigateToCategory('All'),
                            child: Text(
                              LocalizationProvider.instance.tr('view_all'),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.accentTeal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 4. 9 Category Visual Grid (3x3)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: _buildCategoryGrid(),
                  ),

                  // 5. Most Booked Services Horizontal Rail
                  SliverToBoxAdapter(child: _buildMostBookedSection()),

                  // 6. Prithvi Fix Trust & Value Guarantee
                  SliverToBoxAdapter(child: _buildTrustSection()),

                  // Bottom padding for floating cart
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),

              // Floating Cart Bar
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: FloatingCartBar(
                  cart: widget.cart,
                  onViewCart: widget.onViewCart,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSliverHeader() {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 2,
      backgroundColor: AppColors.surface,
      toolbarHeight: 64,
      title: BouncingWidget(
        onTap: _showLocationPicker,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on_rounded, color: AppColors.accentTeal, size: 18),
                const SizedBox(width: 4),
                Text(
                  '$_currentDistrict District',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary, size: 18),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.accentTealLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'ODISHA',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: AppColors.accentTeal,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            const Text(
              'Tap to select your district',
              style: TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
      actions: [
        if (widget.auth != null)
          AnimatedBuilder(
            animation: widget.auth!,
            builder: (context, _) {
              final isLoggedIn = widget.auth!.isLoggedIn;
              final user = widget.auth!.currentUser;
              return GestureDetector(
                onTap: () {
                  if (isLoggedIn) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AccountScreen(auth: widget.auth!)),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen(auth: widget.auth!)),
                    );
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 14),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isLoggedIn ? AppColors.accentEmeraldLight : AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isLoggedIn ? AppColors.accentEmerald : AppColors.primary,
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isLoggedIn ? Icons.account_circle : Icons.login_rounded,
                        size: 15,
                        color: isLoggedIn ? AppColors.accentEmerald : AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isLoggedIn ? (user?.name.split(' ').first ?? 'Profile') : 'Sign In',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: isLoggedIn ? AppColors.accentEmerald : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        // Language Switcher Icon Button
        IconButton(
          icon: const Icon(Icons.translate_rounded, color: AppColors.accentTeal),
          tooltip: 'Change Language / ଭାଷା',
          onPressed: _showLanguageDialog,
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No new statutory tariff or escrow notifications.'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: GestureDetector(
            onTap: () => _navigateToCategory('All'),
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.search_rounded, color: AppColors.textMuted, size: 20),
                  SizedBox(width: 10),
                  Text(
                    "Search for 'AC Foam Jet', 'Fan Repair'...",
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCarousel() {
    final banners = ServicesData.heroBanners;

    return Column(
      children: [
        const SizedBox(height: 12),
        SizedBox(
          height: 165,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentBannerIndex = index),
            itemCount: banners.length,
            itemBuilder: (context, index) {
              final b = banners[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BouncingWidget(
                  onTap: () => _navigateToCategory(b['categoryId']),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CustomImage(
                          imageInfo: b['imageInfo'],
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.75),
                                Colors.black.withOpacity(0.2),
                                Colors.transparent,
                              ],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          bottom: 16,
                          right: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.accentTeal,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  b['tag'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                b['title'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                b['subtitle'],
                                style: const TextStyle(
                                  color: Color(0xFFE2E8F0),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),

        // Dots Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(banners.length, (index) {
            final isSelected = _currentBannerIndex == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isSelected ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.border,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }

  String _getLocalizedCategoryName(String cat) {
    final lower = cat.toLowerCase();
    final loc = LocalizationProvider.instance;
    if (lower.contains('plumb')) return loc.tr('cat_plumbing');
    if (lower.contains('elect')) return loc.tr('cat_electrical');
    if (lower.contains('appliance')) return loc.tr('cat_appliance');
    if (lower.contains('carpent')) return loc.tr('cat_carpentry');
    if (lower.contains('paint')) return loc.tr('cat_painting');
    if (lower.contains('clean')) return loc.tr('cat_cleaning');
    if (lower.contains('garden')) return loc.tr('cat_gardening');
    if (lower.contains('care') || lower.contains('elder')) return loc.tr('cat_caregiving');
    if (lower.contains('driv') || lower.contains('chauf')) return loc.tr('cat_driving');
    return cat;
  }

  Widget _buildCategoryGrid() {
    final categories = ServicesData.categories;

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final cat = categories[index];

          return BouncingWidget(
            onTap: () => _navigateToCategory(cat.name),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.015),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomImage(
                    imageInfo: cat.imageInfo,
                    width: 58,
                    height: 58,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getLocalizedCategoryName(cat.name),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${cat.serviceCount} services',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        childCount: categories.length,
      ),
    );
  }

  Widget _buildMostBookedSection() {
    final services = ServicesData.mostBookedServices;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 28, 16, 12),
          child: Text(
            'Most Booked Services',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.4,
            ),
          ),
        ),
        SizedBox(
          height: 240,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: services.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final s = services[index];
              final qty = widget.cart.getQuantity(s.id);

              return BouncingWidget(
                onTap: () => WhatsIncludedSheet.show(context, s, widget.cart),
                child: Container(
                  width: 170,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 4:3 Image
                      CustomImage(
                        imageInfo: s.imageInfo,
                        height: 105,
                        width: double.infinity,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      const SizedBox(height: 8),

                      // Title
                      Text(
                        s.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.2,
                          height: 1.25,
                        ),
                      ),
                      const Spacer(),

                      // Rating
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: AppColors.accentAmber, size: 14),
                          const SizedBox(width: 3),
                          Text(
                            '${s.rating} (${s.reviewCount})',
                            style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Price and Add button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            s.formattedPrice,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          BouncingWidget(
                            onTap: () => widget.cart.addService(s),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: qty > 0 ? AppColors.primary : AppColors.surface,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: qty > 0 ? AppColors.primary : AppColors.accentTeal,
                                  width: 1.2,
                                ),
                              ),
                              child: Text(
                                qty > 0 ? '$qty in cart' : 'ADD',
                                style: TextStyle(
                                  color: qty > 0 ? Colors.white : AppColors.accentTeal,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTrustSection() {
    final trustCards = [
      {
        'title': '100% Verified Artisans',
        'desc': 'Police verified & skill accredited members',
        'badge': 'Govt Certified',
        'icon': Icons.verified_user_rounded,
        'image': AppImages.trustVerifiedArtisan,
        'color': const Color(0xFF0D9488),
        'bgGradient': [const Color(0xFFF0FDFA), const Color(0xFFFFFFFF)],
      },
      {
        'title': '93% Direct Living Wage',
        'desc': 'Zero aggregator commissions or surge fees',
        'badge': 'Fair Pay',
        'icon': Icons.currency_rupee_rounded,
        'image': AppImages.trustFairWage,
        'color': const Color(0xFF059669),
        'bgGradient': [const Color(0xFFECFDF5), const Color(0xFFFFFFFF)],
      },
      {
        'title': 'Dual-OTP Protection',
        'desc': 'Arrival OTP + Completion OTP verification',
        'badge': 'Anti-Fraud',
        'icon': Icons.lock_outline_rounded,
        'image': AppImages.trustDualOtp,
        'color': const Color(0xFF2563EB),
        'bgGradient': [const Color(0xFFEFF6FF), const Color(0xFFFFFFFF)],
      },
      {
        'title': '30-Day Free Warranty',
        'desc': 'Cooperative guaranteed zero-cost rework',
        'badge': 'Zero Risk',
        'icon': Icons.shield_rounded,
        'image': AppImages.trust30DayWarranty,
        'color': const Color(0xFFD97706),
        'bgGradient': [const Color(0xFFFFFBEB), const Color(0xFFFFFFFF)],
      },
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 22,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'The Prithvi Fix Promise',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.4,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Cooperative public utility standards backing every doorstep visit',
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: trustCards.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final c = trustCards[index];
              final color = c['color'] as Color;
              final gradient = c['bgGradient'] as List<Color>;
              final badge = c['badge'] as String;

              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: color.withOpacity(0.18), width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: color.withOpacity(0.2)),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.12),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(c['icon'] as IconData, color: color, size: 21),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                c['title'] as String,
                                style: const TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  badge,
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w800,
                                    color: color,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            c['desc'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary.withOpacity(0.9),
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 13,
                      color: color.withOpacity(0.4),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
