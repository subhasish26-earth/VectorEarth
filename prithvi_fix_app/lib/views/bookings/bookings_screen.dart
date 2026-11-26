import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/animations/spring_curves.dart';
import '../../core/config/api_config.dart';
import '../../services/api_service.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../tracking/live_tracking_screen.dart';

/// Active & Past Cooperative Bookings Screen
/// Connects to Supabase PostgreSQL via Vercel Express API for real-time live synchronization.
class BookingsScreen extends StatefulWidget {
  final CartProvider cart;
  final AuthProvider? auth;

  const BookingsScreen({Key? key, required this.cart, this.auth}) : super(key: key);

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  bool _isLoading = false;
  List<Map<String, dynamic>> _liveBookings = [];
  String? _errorMessage;
  Timer? _autoSyncTimer;

  @override
  void initState() {
    super.initState();
    _fetchLiveBookings();
    _startAutoSync();
  }

  @override
  void dispose() {
    _autoSyncTimer?.cancel();
    super.dispose();
  }

  void _startAutoSync() {
    _autoSyncTimer?.cancel();
    _autoSyncTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (mounted && !_isLoading) {
        _fetchLiveBookings(silent: true);
      }
    });
  }

  Future<void> _fetchLiveBookings({bool silent = false}) async {
    if (!mounted) return;
    if (!silent) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final auth = widget.auth ?? AuthProvider.instance;
      final token = await auth.ensureValidToken();

      if (token != null && token.isNotEmpty) {
        final res = await ApiService.instance.getBookings(token: token);
        if (res.isSuccess && res.data != null) {
          if (mounted) {
            setState(() {
              _liveBookings = res.data!.cast<Map<String, dynamic>>();
              _isLoading = false;
            });
            return;
          }
        } else if (!silent) {
          _errorMessage = res.errorMessage;
        }
      }
    } catch (e) {
      if (!silent) {
        _errorMessage = e.toString();
      }
    }

    if (mounted && !silent) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showClaimGuaranteeDialog({
    required dynamic bookingId,
    required String bookingCode,
    required String serviceName,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.verified_user_rounded, color: AppColors.accentTeal, size: 24),
            SizedBox(width: 8),
            Text('Claim 30D Free Warranty', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Has the issue with "$serviceName" recurred?',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            const Text(
              'Under the Prithvi Fix Cooperative Workmanship Code, you are entitled to a 100% Free Master-Artisan Revisit with ₹0 labour fee.',
              style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.accentTeal.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.shield_outlined, color: AppColors.accentTeal, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Zero Labour Charges • Priority Re-dispatch',
                      style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.accentTeal),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              final auth = widget.auth ?? AuthProvider.instance;
              final token = await auth.ensureValidToken();
              if (token != null && bookingId != null) {
                final res = await ApiService.instance.claimGuarantee(token: token, bookingId: bookingId);
                if (mounted) {
                  if (res.isSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('🎉 30-Day Guarantee Activated! A Master Artisan has been dispatched at ₹0.'),
                        backgroundColor: AppColors.accentTeal,
                      ),
                    );
                    _fetchLiveBookings();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(res.errorMessage ?? 'Failed to claim guarantee.'),
                        backgroundColor: AppColors.accentCoral,
                      ),
                    );
                  }
                }
              }
            },
            child: const Text('Confirm Free Re-dispatch', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _showCancelBookingDialog(String bookingCode, {bool isClaim = false}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.cancel_outlined, color: Color(0xFFDC2626), size: 24),
            const SizedBox(width: 8),
            Text(isClaim ? 'Cancel Warranty Claim' : 'Cancel Order', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          ],
        ),
        content: Text(
          isClaim
              ? 'Are you sure you want to cancel warranty re-dispatch #$bookingCode? Your 30-day warranty will be restored so you can re-claim it whenever needed.'
              : 'Are you sure you want to cancel order #$bookingCode? The allocated cooperative artisan will be released.',
          style: const TextStyle(fontSize: 13.5, color: AppColors.textSecondary, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Keep Order', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              final auth = widget.auth ?? AuthProvider.instance;
              final token = await auth.ensureValidToken();
              if (token != null) {
                final res = await ApiService.instance.cancelBooking(
                  token: token,
                  bookingIdOrCode: bookingCode,
                  reason: isClaim ? 'Warranty claim cancelled by customer' : 'Cancelled by customer',
                );
                if (mounted) {
                  if (res.isSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isClaim
                            ? 'Warranty claim #$bookingCode cancelled. Warranty restored.'
                            : 'Order #$bookingCode cancelled successfully.'),
                        backgroundColor: AppColors.accentTeal,
                      ),
                    );
                    _fetchLiveBookings();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(res.errorMessage ?? 'Failed to cancel order.'),
                        backgroundColor: AppColors.accentCoral,
                      ),
                    );
                  }
                }
              }
            },
            child: const Text('Confirm Cancel', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Partition live bookings into active vs past
    final activeBookings = _liveBookings.where((b) {
      final status = (b['status'] ?? '').toString().toUpperCase();
      return status != 'COMPLETED' && status != 'CANCELLED';
    }).toList();

    final pastBookings = _liveBookings.where((b) {
      final status = (b['status'] ?? '').toString().toUpperCase();
      return status == 'COMPLETED' || status == 'CANCELLED';
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Bookings & Orders'),
        actions: [
          IconButton(
            tooltip: 'Sync Real-Time Data',
            icon: _isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.sync_rounded),
            onPressed: _isLoading ? null : _fetchLiveBookings,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchLiveBookings,
        color: AppColors.primary,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. ACTIVE LIVE ORDERS
              if (activeBookings.isNotEmpty) ...[
                const Text(
                  'Active Orders (Real-Time)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 12),
                ...activeBookings.map((b) => _buildLiveActiveCard(b)),
                const SizedBox(height: 24),
              ] else if (_liveBookings.isEmpty && !_isLoading) ...[
                // Default active order fallback for offline/demo if no live bookings yet
                _buildDefaultActiveOrderCard(context),
                const SizedBox(height: 24),
              ],

              // 2. PAST COMPLETED / CANCELLED ORDERS
              const Text(
                'Past Service History',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 12),

              if (pastBookings.isNotEmpty) ...[
                ...pastBookings.map((b) => _buildLivePastCard(b)),
              ] else ...[
                _buildPastOrderCard(
                  context,
                  bookingCode: 'BKG-2026-0742',
                  serviceName: 'Switchboard & MCB Repair',
                  category: 'Electrician',
                  date: '02 May 2026, 04:30 PM',
                  artisan: 'Pradeep Mohapatra (Grade A)',
                  cost: '₹199',
                  warrantyDaysLeft: 22,
                  isCancelled: false,
                ),
                const SizedBox(height: 12),
                _buildPastOrderCard(
                  context,
                  bookingCode: 'BKG-2026-0518',
                  serviceName: 'Bathroom Jet Drain Cleaning',
                  category: 'Plumbing',
                  date: '18 Apr 2026, 11:00 AM',
                  artisan: 'Suresh Chandra Das',
                  cost: '₹349',
                  warrantyDaysLeft: 8,
                  isCancelled: false,
                ),
                const SizedBox(height: 12),
                _buildPastOrderCard(
                  context,
                  bookingCode: 'BKG-2026-0391',
                  serviceName: 'Ceiling Fan Bearing Replacement',
                  category: 'Electrician',
                  date: '27 Mar 2026, 02:15 PM',
                  artisan: 'Pradeep Mohapatra',
                  cost: '₹249',
                  warrantyDaysLeft: 0,
                  isCancelled: false,
                ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLiveSyncBadge() {
    return const SizedBox.shrink();
  }

  Widget _buildLiveActiveCard(Map<String, dynamic> booking) {
    final bookingCode = booking['booking_code']?.toString() ?? 'BKG-LIVE';
    final isClaimOrder = bookingCode.startsWith('GRNT-') || booking['guarantee_claimed'] == 1 || (booking['notes']?.toString().contains('Guarantee Claim') ?? false);
    final serviceName = booking['service_name']?.toString() ?? (isClaimOrder ? '30-Day Guarantee Rework' : 'Cooperative Service');
    final status = (booking['status']?.toString() ?? 'REQUESTED').toUpperCase();
    final workerName = booking['worker_name']?.toString();
    final workerPhone = booking['worker_phone']?.toString();
    final workerCode = booking['worker_code']?.toString();
    final arrivalOtp = booking['arrival_otp']?.toString();
    final district = booking['location_district']?.toString() ?? 'Khordha';
    final address = booking['location_address']?.toString() ?? 'Patia, Bhubaneswar';
    final totalAmount = booking['total_amount'] != null
        ? '₹${booking['total_amount']}'
        : '₹499';

    final Color statusColor;
    final String statusLabel;
    switch (status) {
      case 'REQUESTED':
        statusColor = const Color(0xFFD97706);
        statusLabel = 'SEARCHING FOR ARTISAN';
        break;
      case 'MATCHED':
      case 'ACCEPTED':
        statusColor = AppColors.accentTeal;
        statusLabel = 'ARTISAN ASSIGNED';
        break;
      case 'IN_TRANSIT':
        statusColor = const Color(0xFF2563EB);
        statusLabel = 'ARTISAN EN ROUTE';
        break;
      case 'ARRIVED':
        statusColor = const Color(0xFF7C3AED);
        statusLabel = 'ARTISAN ARRIVED AT DOORSTEP';
        break;
      case 'IN_PROGRESS':
        statusColor = AppColors.accentEmerald;
        statusLabel = 'SERVICE IN PROGRESS';
        break;
      default:
        statusColor = AppColors.primary;
        statusLabel = status;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Live Status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  statusLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
                const Spacer(),
                Text(
                  '#$bookingCode',
                  style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        serviceName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      totalAmount,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  workerName != null && workerName.isNotEmpty
                      ? 'Artisan: $workerName ${workerCode != null ? '• $workerCode' : ''}'
                      : 'Artisan: Broadcasting to nearby guild cooperative members...',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: workerName != null ? AppColors.textSecondary : const Color(0xFFD97706),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Location: $address ($district)',
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 14),

                // OTP Display / Locked Indicator
                if (status == 'REQUESTED' || arrivalOtp == null || arrivalOtp.isEmpty) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.lock_clock, size: 16, color: Color(0xFFD97706)),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Doorstep OTP Locked • Unlocks upon Artisan Acceptance',
                            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF92400E)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.shield_outlined, size: 16, color: AppColors.accentTeal),
                            SizedBox(width: 6),
                            Text(
                              'Doorstep Arrival OTP:',
                              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        Text(
                          arrivalOtp,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.primary, letterSpacing: 1.5),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 14),

                // Open Live Telemetry Button & Cancel Order Option
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: BouncingWidget(
                        onTap: () {
                          JobStatusStage stage = JobStatusStage.requested;
                          if (status == 'MATCHED') stage = JobStatusStage.matched;
                          if (status == 'ACCEPTED' || status == 'IN_TRANSIT' || status == 'ARRIVED') stage = JobStatusStage.inTransit;
                          if (status == 'IN_PROGRESS') stage = JobStatusStage.inProgress;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LiveTrackingScreen(
                                bookingCode: bookingCode,
                                district: district,
                                address: address,
                                cart: widget.cart,
                                initialStage: stage,
                                arrivalOtp: arrivalOtp,
                                completionOtp: booking['completion_otp']?.toString(),
                                workerName: workerName,
                                workerPhone: workerPhone,
                                workerCode: workerCode,
                                workerTier: booking['worker_tier']?.toString(),
                                workerRating: (booking['worker_rating'] is num)
                                    ? (booking['worker_rating'] as num).toDouble()
                                    : double.tryParse(booking['worker_rating']?.toString() ?? ''),
                                serviceCategory: booking['service_category']?.toString(),
                                initialAmount: (booking['total_amount'] is num)
                                    ? (booking['total_amount'] as num).toDouble()
                                    : double.tryParse(booking['total_amount']?.toString() ?? ''),
                                initialServiceName: booking['service_name']?.toString(),
                              ),
                            ),
                          ).then((_) => _fetchLiveBookings());
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              'Track Live ➔',
                              style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: BouncingWidget(
                        onTap: () => _showCancelBookingDialog(bookingCode, isClaim: isClaimOrder),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEE2E2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFFECACA)),
                          ),
                          child: const Center(
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Color(0xFFDC2626), fontSize: 13, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLivePastCard(Map<String, dynamic> booking) {
    final bookingId = booking['id'];
    final bookingCode = booking['booking_code']?.toString() ?? 'BKG-000';
    final serviceName = booking['service_name']?.toString() ?? 'Service';
    final category = booking['service_category']?.toString() ?? 'Home Maintenance';
    final status = (booking['status']?.toString() ?? 'COMPLETED').toUpperCase();
    final workerName = booking['worker_name']?.toString() ?? 'Prithvi Fix Certified Artisan';
    final cost = booking['total_amount'] != null ? '₹${booking['total_amount']}' : '₹349';
    final createdAt = booking['created_at']?.toString() ?? '';
    final isCancelled = status == 'CANCELLED';
    final isGuaranteeClaimed = booking['guarantee_claimed'] == 1 || booking['guarantee_claimed'] == true;

    // Check remaining warranty days
    int warrantyDaysLeft = 30;
    if (booking['guarantee_armed_until'] != null) {
      try {
        final until = DateTime.parse(booking['guarantee_armed_until'].toString());
        final diff = until.difference(DateTime.now()).inDays;
        warrantyDaysLeft = diff > 0 ? diff : 0;
      } catch (_) {}
    }

    String displayDate = createdAt.isNotEmpty && createdAt.length >= 10
        ? createdAt.substring(0, 10)
        : 'Recent';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _buildPastOrderCard(
        context,
        bookingId: bookingId,
        bookingCode: bookingCode,
        serviceName: serviceName,
        category: category,
        date: displayDate,
        artisan: workerName,
        cost: cost,
        warrantyDaysLeft: isCancelled ? 0 : warrantyDaysLeft,
        isCancelled: isCancelled,
        isGuaranteeClaimed: isGuaranteeClaimed,
      ),
    );
  }

  Widget _buildDefaultActiveOrderCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accentTeal.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentTeal.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'NO ACTIVE BOOKINGS RIGHT NOW',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Book a verified cooperative artisan anytime',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Any order you place in the mobile app or web portal syncs instantly here in real-time.',
                  style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPastOrderCard(
    BuildContext context, {
    dynamic bookingId,
    required String bookingCode,
    required String serviceName,
    required String category,
    required String date,
    required String artisan,
    required String cost,
    required int warrantyDaysLeft,
    required bool isCancelled,
    bool isGuaranteeClaimed = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '#$bookingCode',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textMuted),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isCancelled ? const Color(0xFFFEE2E2) : AppColors.accentEmeraldLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(
                      isCancelled ? Icons.cancel_outlined : Icons.check_circle,
                      size: 12,
                      color: isCancelled ? const Color(0xFFDC2626) : AppColors.accentEmerald,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isCancelled ? 'Cancelled' : 'Completed',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: isCancelled ? const Color(0xFFDC2626) : AppColors.accentEmerald,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            serviceName,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            '$category • Serviced by $artisan',
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          Text(
            date,
            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
          ),
          const Divider(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Tariff', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                  Text(
                    cost,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                  ),
                ],
              ),
              if (!isCancelled && warrantyDaysLeft > 0 && !isGuaranteeClaimed)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BouncingWidget(
                      onTap: () {
                        final parsedCost = double.tryParse(cost.replaceAll(RegExp(r'[^0-9.]'), ''));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LiveTrackingScreen(
                              bookingCode: bookingCode,
                              district: 'Khordha',
                              address: 'Patia, Bhubaneswar',
                              cart: widget.cart,
                              initialStage: JobStatusStage.completed,
                              workerName: artisan,
                              initialAmount: parsedCost,
                              initialServiceName: serviceName,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                        margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.receipt_long_rounded, size: 14, color: AppColors.textPrimary),
                            SizedBox(width: 4),
                            Text(
                              'Invoice',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                            ),
                          ],
                        ),
                      ),
                    ),
                    BouncingWidget(
                      onTap: () {
                        _showClaimGuaranteeDialog(bookingId: bookingId, bookingCode: bookingCode, serviceName: serviceName);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.accentTeal.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.accentTeal.withOpacity(0.4)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.verified_user_rounded, size: 14, color: AppColors.accentTeal),
                            SizedBox(width: 4),
                            Text(
                              'Claim 30D ($warrantyDaysLeft d) ➔',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.accentTeal),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              else if (isGuaranteeClaimed)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.handshake_rounded, size: 13, color: Color(0xFFD97706)),
                      SizedBox(width: 4),
                      Text(
                        'Warranty Re-dispatch Claimed',
                        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFFB45309)),
                      ),
                    ],
                  ),
                )
              else if (isCancelled)
                const Text(
                  'Order Cancelled',
                  style: TextStyle(fontSize: 11, color: Color(0xFFDC2626), fontWeight: FontWeight.w600),
                )
              else
                const Text(
                  'Warranty Expired',
                  style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
