import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/animations/spring_curves.dart';
import '../../providers/cart_provider.dart';
import '../tracking/live_tracking_screen.dart';

/// Booking Confirmation Screen with Dual-OTP Security Credentials
class OrderSuccessScreen extends StatelessWidget {
  final CartProvider cart;
  final String district;
  final String address;
  final String date;
  final String slot;
  final String paymentMethod;
  final String? arrivalOtp;
  final String? completionOtp;
  final String bookingCode;
  final VoidCallback? onTrackTelemetry;
  final double? bookedAmount;
  final String? bookedServiceName;

  const OrderSuccessScreen({
    Key? key,
    required this.cart,
    required this.district,
    required this.address,
    required this.date,
    required this.slot,
    required this.paymentMethod,
    this.arrivalOtp,
    this.completionOtp,
    required this.bookingCode,
    this.onTrackTelemetry,
    this.bookedAmount,
    this.bookedServiceName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),

              // Animated Green Checkmark
              Container(
                width: 76,
                height: 76,
                decoration: const BoxDecoration(
                  color: AppColors.accentEmeraldLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.accentEmerald,
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Booking Confirmed!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Order #$bookingCode • District: $district',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),

              // 🛡️ DUAL-OTP ANTI-FRAUD CREDENTIALS CARD
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.accentTeal.withOpacity(0.3), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentTeal.withOpacity(0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.verified_user_rounded, color: AppColors.accentTeal, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Anti-Fraud Dual-OTP Security',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // OTP 1: Arrival OTP
                    _buildOtpBox(
                      title: '1. Arrival OTP (Share at Doorstep)',
                      subtitle: arrivalOtp != null && arrivalOtp!.isNotEmpty
                          ? 'Share ONLY when the verified artisan physically reaches your home.'
                          : 'Will unlock automatically once an artisan accepts your order.',
                      code: arrivalOtp != null && arrivalOtp!.isNotEmpty
                          ? arrivalOtp!
                          : '🔒 LOCKED',
                      color: AppColors.primary,
                      bgColor: AppColors.background,
                    ),
                    const SizedBox(height: 12),

                    // OTP 2: Completion OTP
                    _buildOtpBox(
                      title: '2. Completion OTP (Share After Inspection)',
                      subtitle: 'Share ONLY after you test and approve the completed repair work.',
                      code: completionOtp != null && completionOtp!.isNotEmpty
                          ? completionOtp!
                          : '🔒 LOCKED',
                      color: AppColors.accentEmerald,
                      bgColor: AppColors.accentEmeraldLight.withOpacity(0.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Appointment Details Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(Icons.calendar_month_rounded, 'Date & Time', '$date | $slot'),
                    const Divider(height: 18),
                    _buildDetailRow(Icons.location_on_rounded, 'Service Address', address),
                    const Divider(height: 18),
                    _buildDetailRow(Icons.payment_rounded, 'Payment Mode', paymentMethod),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 30-Day Warranty Certificate
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7).withOpacity(0.6),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.shield_rounded, color: AppColors.accentAmber, size: 24),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '30-Day Free Workmanship Warranty has been activated for this booking.',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF92400E),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Track Button
              BouncingWidget(
                onTap: () {
                  if (onTrackTelemetry != null) {
                    onTrackTelemetry!();
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LiveTrackingScreen(
                          bookingCode: bookingCode,
                          district: district,
                          address: address,
                          cart: cart,
                          initialStage: JobStatusStage.requested,
                          arrivalOtp: arrivalOtp,
                          completionOtp: completionOtp,
                          initialAmount: bookedAmount,
                          initialServiceName: bookedServiceName,
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      'Track Live Artisan Telemetry ➔',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Back to Home Button
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Back to Home Screen',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox({
    required String title,
    required String subtitle,
    required String code,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  code,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: code.contains('LOCKED') ? 12 : 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: code.contains('LOCKED') ? 0.5 : 2.0,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.textMuted),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
