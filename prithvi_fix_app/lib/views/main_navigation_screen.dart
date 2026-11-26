import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/localization_provider.dart';
import 'home/home_screen.dart';
import 'services/services_directory_screen.dart';
import 'ai/ai_fix_screen.dart';
import 'cart/cart_sheet.dart';
import 'checkout/checkout_screen.dart';
import 'bookings/bookings_screen.dart';
import 'account/account_screen.dart';

/// Main Application Shell with Urban Company Navigation Bar
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  final CartProvider _cart = CartProvider();
  final AuthProvider _auth = AuthProvider();

  void _onViewCart() {
    CartSheet.show(
      context,
      _cart,
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CheckoutScreen(cart: _cart, auth: _auth),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(cart: _cart, onViewCart: _onViewCart, auth: _auth),
      ServicesDirectoryScreen(cart: _cart, onViewCart: _onViewCart),
      AiFixScreen(auth: _auth),
      BookingsScreen(cart: _cart, auth: _auth),
      AccountScreen(auth: _auth),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: AnimatedBuilder(
          animation: LocalizationProvider.instance,
          builder: (context, _) {
            final loc = LocalizationProvider.instance;
            return BottomNavigationBar(
              currentIndex: _currentIndex,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: const Color(0xFF0D9488),
              unselectedItemColor: const Color(0xFF94A3B8),
              selectedFontSize: 11,
              unselectedFontSize: 11,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
              onTap: (index) => setState(() => _currentIndex = index),
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home_filled),
                  label: loc.tr('nav_home'),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.grid_view_rounded),
                  label: loc.tr('nav_services'),
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _currentIndex == 2 ? const Color(0xFFCCFBF1) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      color: _currentIndex == 2 ? const Color(0xFF0D9488) : const Color(0xFF94A3B8),
                      size: 20,
                    ),
                  ),
                  label: loc.tr('nav_ai_fix'),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.receipt_long_rounded),
                  label: loc.tr('nav_bookings'),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.person_rounded),
                  label: loc.tr('nav_account'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
