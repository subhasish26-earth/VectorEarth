import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/animations/spring_curves.dart';
import '../../core/config/api_config.dart';
import '../../services/api_service.dart';
import '../../providers/auth_provider.dart';
import '../../providers/localization_provider.dart';
import '../auth/login_screen.dart';

/// User Profile & Cooperative Citizen Member Account Screen
class AccountScreen extends StatefulWidget {
  final AuthProvider auth;

  const AccountScreen({
    Key? key,
    required this.auth,
  }) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String _selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    widget.auth.addListener(_onAuthChanged);
  }

  @override
  void dispose() {
    widget.auth.removeListener(_onAuthChanged);
    super.dispose();
  }

  void _onAuthChanged() {
    if (mounted) setState(() {});
  }

  void _showCharterModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Statutory 93-2-5 Cooperative Charter',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              const Text(
                'Under the Cooperative Societies Framework, Prithvi Fix operates as a zero-middleman public digital utility:',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 16),
              _buildCharterPoint('93% Direct Living Wage', '93% of the tariff you pay is transferred directly into the verified bank account of the artisan who serviced your home, ensuring fair remuneration.'),
              _buildCharterPoint('5% Mini-PF & Social Security', 'Deposited into the registered Artisan Welfare Pool for healthcare, accidental insurance, and retirement support.'),
              _buildCharterPoint('2% Platform Upkeep', 'Dedicated strictly to server bandwidth, automated dispatch, and safety verification. Zero private venture capital extraction.'),
              const SizedBox(height: 16),
              BouncingWidget(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Text('Understood', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildCharterPoint(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_rounded, color: AppColors.accentTeal, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(desc, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.35)),
              ],
            ),
          ),
        ],
      ),
    );
  }

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

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: AppColors.accentCoral, size: 22),
            SizedBox(width: 8),
            Text('Log Out?'),
          ],
        ),
        content: const Text(
          'Are you sure you want to log out of your Prithvi Fix citizen account?',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentCoral,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              widget.auth.logout();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully. You are now browsing as Guest.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Log Out', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _showCloudSyncDialog() {
    final controller = TextEditingController(text: ApiConfig.baseUrl);
    bool isTesting = false;
    String? statusMessage;
    bool isSuccess = false;
    bool liveBackendEnabled = ApiConfig.useLiveBackend;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.cloud_sync_rounded, color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Cloud Sync & DB', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                      Text('Vercel API + Supabase DB', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your website on Vercel runs the API at /api, which connects to your Supabase PostgreSQL database.',
                    style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Vercel API Base URL',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'https://your-project.vercel.app/api',
                      hintStyle: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                      prefixIcon: const Icon(Icons.link_rounded, size: 20, color: AppColors.primary),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                    style: const TextStyle(fontSize: 13, fontFamily: 'monospace'),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Enable Live Sync', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
                    subtitle: Text(
                      liveBackendEnabled ? 'Live Vercel + Supabase sync active' : 'Offline local demo mode active',
                      style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                    ),
                    value: liveBackendEnabled,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      setDialogState(() => liveBackendEnabled = val);
                    },
                  ),
                  if (statusMessage != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSuccess ? AppColors.accentEmeraldLight : AppColors.accentCoralLight,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSuccess
                              ? AppColors.accentEmerald.withOpacity(0.3)
                              : AppColors.accentCoral.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSuccess ? Icons.check_circle_rounded : Icons.error_outline_rounded,
                            color: isSuccess ? AppColors.accentEmerald : AppColors.accentCoral,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              statusMessage!,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: isSuccess ? AppColors.accentEmerald : AppColors.accentCoral,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: isTesting
                    ? null
                    : () async {
                        setDialogState(() {
                          isTesting = true;
                          statusMessage = 'Pinging ${controller.text.trim()}...';
                        });
                        ApiConfig.baseUrl = controller.text.trim();
                        final res = await ApiService.instance.checkHealth();
                        setDialogState(() {
                          isTesting = false;
                          if (res['status'] == 'ok' || res['database'] != null) {
                            isSuccess = true;
                            statusMessage = 'Connected! Database: ${res['database'] ?? "PostgreSQL"} (Live)';
                          } else {
                            isSuccess = false;
                            statusMessage = 'Ping failed: ${res['message'] ?? res['error'] ?? "Unreachable"}';
                          }
                        });
                      },
                child: isTesting
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Test Connection', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                onPressed: () {
                  ApiConfig.setVercelUrl(controller.text);
                  ApiConfig.useLiveBackend = liveBackendEnabled;
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(liveBackendEnabled
                          ? '✅ Live Cloud Sync Enabled (${ApiConfig.baseUrl})'
                          : 'ℹ️ Local Offline Mode Active'),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                  setState(() {});
                },
                child: const Text('Save & Apply', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ],
          );
        },
      ),
    );
  }

  void _navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(auth: widget.auth),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = widget.auth.isLoggedIn;
    final user = widget.auth.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Cooperative Account'),
        actions: [
          if (isLoggedIn)
            IconButton(
              icon: const Icon(Icons.logout_rounded, color: AppColors.accentCoral),
              tooltip: 'Log Out',
              onPressed: _confirmLogout,
            )
          else
            TextButton.icon(
              icon: const Icon(Icons.login_rounded, size: 18, color: AppColors.primary),
              label: const Text('Sign In', style: TextStyle(fontWeight: FontWeight.w700)),
              onPressed: _navigateToLogin,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // 1. CITIZEN PROFILE CARD OR GUEST CALLOUT
            if (isLoggedIn && user != null)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: user.role == 'ARTISAN' ? AppColors.accentTeal : AppColors.primary,
                      child: Text(
                        user.name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join(),
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
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
                                user.name,
                                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.verified_rounded, color: AppColors.accentTeal, size: 18),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${user.phone} • ${user.district}',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.accentEmeraldLight,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              user.role == 'ARTISAN'
                                  ? 'OD-KHD-ART-88240 • POLICE VERIFIED'
                                  : 'CO-OP CITIZEN: OD-KHD-CIT-${user.id.toString().padLeft(5, "0")}',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: AppColors.accentEmerald,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else
              // Guest Callout Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.accentTeal.withOpacity(0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentTeal.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: AppColors.background,
                          child: Icon(Icons.person_outline_rounded, size: 28, color: AppColors.textSecondary),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Browsing as Guest',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Sign in to sync your bookings, view living wage savings, and track artisans.',
                                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    BouncingWidget(
                      onTap: _navigateToLogin,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'Sign In / Create Account',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // 2. CUMULATIVE CITIZEN ESCROW SAVINGS (If logged in)
            if (isLoggedIn)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF064E3B), Color(0xFF047857)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF064E3B).withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'COOPERATIVE SURGE SAVINGS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF6EE7B7),
                            letterSpacing: 0.8,
                          ),
                        ),
                        Icon(Icons.shield_rounded, color: Color(0xFF6EE7B7), size: 18),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '₹1,420 Saved',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Compared to private gig-broker peak commissions & surge pricing in Khordha district.',
                      style: TextStyle(fontSize: 11.5, color: Colors.white70, height: 1.3),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // 3. STATUTORY CHARTER & MENU LIST
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildMenuTile(
                    icon: Icons.account_balance_rounded,
                    title: 'Statutory 93-2-5 Tariff Breakdown',
                    subtitle: 'Prithvi Fix Cooperative Labour Charter',
                    onTap: _showCharterModal,
                  ),
                  _buildDivider(),
                  _buildMenuTile(
                    icon: Icons.verified_user_rounded,
                    title: 'Master Artisan Registry',
                    subtitle: 'Skill India & Police verified trade credentials',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('All 480 artisans are registered with Prithvi Fix Cooperative Federation.')),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildMenuTile(
                    icon: Icons.translate_rounded,
                    title: 'Language / ଭାଷା',
                    subtitle: LocalizationProvider.instance.languageName,
                    onTap: _showLanguageDialog,
                  ),
                  _buildDivider(),
                  _buildMenuTile(
                    icon: Icons.support_agent_rounded,
                    title: 'Citizen Support & Escalation',
                    subtitle: '24/7 Cooperative grievance desk (Toll-Free 1800-XXX)',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Connecting to Prithvi Fix Consumer Helpdesk: 1800-345-FIX')),
                      );
                    },
                  ),
                  if (isLoggedIn) ...[
                    _buildDivider(),
                    _buildMenuTile(
                      icon: Icons.logout_rounded,
                      title: 'Log Out',
                      subtitle: 'Sign out of this device',
                      onTap: _confirmLogout,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Footer branding
            const Center(
              child: Column(
                children: [
                  Text(
                    'PRITHVI FIX • DIGITAL COOPERATIVE UTILITY',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.textMuted, letterSpacing: 0.8),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'v2.4.0 Production Build • Certified Public Utility',
                    style: TextStyle(fontSize: 10.5, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: icon == Icons.logout_rounded ? AppColors.accentCoralLight : AppColors.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 20,
                color: icon == Icons.logout_rounded ? AppColors.accentCoral : AppColors.primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: icon == Icons.logout_rounded ? AppColors.accentCoral : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: icon == Icons.logout_rounded ? AppColors.accentCoral : AppColors.textMuted),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, indent: 56, endIndent: 16);
  }
}
