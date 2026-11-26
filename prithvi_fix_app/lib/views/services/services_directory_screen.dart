import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/services_data.dart';
import '../../models/service_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/localization_provider.dart';
import '../../widgets/service_card.dart';
import '../../widgets/floating_cart_bar.dart';

/// All 47 Services Directory Screen with category chips and search filter
class ServicesDirectoryScreen extends StatefulWidget {
  final String? initialCategory;
  final CartProvider cart;
  final VoidCallback onViewCart;

  const ServicesDirectoryScreen({
    Key? key,
    this.initialCategory,
    required this.cart,
    required this.onViewCart,
  }) : super(key: key);

  @override
  State<ServicesDirectoryScreen> createState() => _ServicesDirectoryScreenState();
}

class _ServicesDirectoryScreenState extends State<ServicesDirectoryScreen> {
  late String _selectedCategory;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  static const List<String> _categoryTabs = [
    'All',
    'AC & Appliance',
    'Electrician',
    'Plumbing',
    'Carpentry',
    'Painting',
    'Cleaning',
    'Gardening',
    'Caregiving',
    'Driver / Chauffeur',
  ];

  String _getTabLabel(String tab) {
    final lower = tab.toLowerCase();
    final loc = LocalizationProvider.instance;
    if (lower == 'all') return loc.tr('view_all');
    if (lower.contains('plumb')) return loc.tr('cat_plumbing');
    if (lower.contains('elect')) return loc.tr('cat_electrical');
    if (lower.contains('appliance')) return loc.tr('cat_appliance');
    if (lower.contains('carpent')) return loc.tr('cat_carpentry');
    if (lower.contains('paint')) return loc.tr('cat_painting');
    if (lower.contains('clean')) return loc.tr('cat_cleaning');
    if (lower.contains('garden')) return loc.tr('cat_gardening');
    if (lower.contains('care') || lower.contains('elder')) return loc.tr('cat_caregiving');
    if (lower.contains('driv') || lower.contains('chauf')) return loc.tr('cat_driving');
    return tab;
  }

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory ?? 'All';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ServiceItem> get _filteredServices {
    var list = ServicesData.allServices;

    // Filter by Category
    if (_selectedCategory != 'All') {
      list = list.where((s) => s.category.toLowerCase().contains(_selectedCategory.toLowerCase())).toList();
    }

    // Filter by Search Query
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase().trim();
      list = list.where((s) =>
        s.name.toLowerCase().contains(q) ||
        s.description.toLowerCase().contains(q) ||
        s.category.toLowerCase().contains(q)
      ).toList();
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.cart,
      builder: (context, _) {
        final services = _filteredServices;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            elevation: 0,
            leading: Navigator.canPop(context)
                ? IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                    onPressed: () => Navigator.pop(context),
                  )
                : null,
            title: const Text('All 47 Services Catalog'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(105),
              child: Column(
                children: [
                  // Search Input Field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) => setState(() => _searchQuery = val),
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: "Search from all 47 verified services...",
                          hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted, size: 20),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded, size: 18),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),

                  // Category Horizontal Chip Bar
                  SizedBox(
                    height: 48,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      scrollDirection: Axis.horizontal,
                      itemCount: _categoryTabs.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final tab = _categoryTabs[index];
                        final isSelected = _selectedCategory == tab;

                        return GestureDetector(
                          onTap: () => setState(() => _selectedCategory = tab),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : AppColors.surface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? AppColors.primary : AppColors.border,
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                _getTabLabel(tab),
                                style: TextStyle(
                                  color: isSelected ? Colors.white : AppColors.textSecondary,
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Stack(
            children: [
              services.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off_rounded, size: 48, color: AppColors.textMuted),
                          const SizedBox(height: 12),
                          Text(
                            'No services matching "$_searchQuery"',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Try searching for "fan", "ac", "tap", or "cleaning"',
                            style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        final service = services[index];
                        return ServiceCard(
                          service: service,
                          cart: widget.cart,
                        );
                      },
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
}
