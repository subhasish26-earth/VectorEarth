import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../core/utils/geolocation_helper.dart';
import '../../core/theme/app_colors.dart';
import '../../core/animations/spring_curves.dart';
import '../../core/config/api_config.dart';
import '../../services/api_service.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import 'order_success_screen.dart';

/// 4-Step Interactive Checkout & Booking Wizard
/// Connects live orders directly to Supabase via Vercel Express API.
class CheckoutScreen extends StatefulWidget {
  final CartProvider cart;
  final AuthProvider? auth;

  const CheckoutScreen({
    Key? key,
    required this.cart,
    this.auth,
  }) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _currentStep = 0;
  bool _isSubmitting = false;

  // Step 2: Location
  String _selectedDistrict = 'Khordha';
  bool _isLocatingGps = false;
  double? _gpsLatitude;
  double? _gpsLongitude;
  final TextEditingController _housePlotController = TextEditingController();
  final TextEditingController _streetAreaController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _cityController = TextEditingController(text: 'Bhubaneswar');
  final TextEditingController _pincodeController = TextEditingController(text: '751024');

  final TextEditingController _addressController = TextEditingController(
    text: 'Plot 42, Near KIIT Campus, Patia, Bhubaneswar, 751024',
  );

  // Step 3: Schedule
  bool _isEmergencySquad = false;
  int _selectedDateIndex = 0;
  int _selectedSlotIndex = 0;
  final List<String> _dates = [
    'Today',
    'Tomorrow',
    'Day After',
  ];
  final List<String> _timeSlots = [
    '08:00 AM - 10:00 AM',
    '10:00 AM - 12:00 PM',
    '12:00 PM - 02:00 PM',
    '02:00 PM - 04:00 PM',
    '04:00 PM - 06:00 PM',
    '06:00 PM - 08:00 PM',
  ];

  // Step 4: Payment
  String _selectedPaymentMethod = 'UPI';

  @override
  void dispose() {
    _housePlotController.dispose();
    _streetAreaController.dispose();
    _landmarkController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _syncFullAddress() {
    final parts = [
      _housePlotController.text.trim(),
      _streetAreaController.text.trim(),
      if (_landmarkController.text.trim().isNotEmpty) 'Near ${_landmarkController.text.trim()}',
      _cityController.text.trim(),
      _selectedDistrict,
      _pincodeController.text.trim(),
    ].where((s) => s.isNotEmpty).toList();

    if (parts.isNotEmpty) {
      _addressController.text = parts.join(', ');
    }
  }

  void _detectCurrentGps() async {
    setState(() => _isLocatingGps = true);
    try {
      final coords = await getCurrentCoordinates();
      if (!mounted) return;
      if (coords != null && coords['lat'] != null && coords['lng'] != null) {
        final lat = coords['lat']!;
        final lng = coords['lng']!;
        setState(() {
          _isLocatingGps = false;
          _gpsLatitude = lat;
          _gpsLongitude = lng;
          _addressController.text = 'Current GPS Location (${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}), Patia, Bhubaneswar, 751024';
          _streetAreaController.text = 'Current Live GPS Location';
          _cityController.text = 'Bhubaneswar';
          _pincodeController.text = '751024';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('📍 Live GPS Latched: ${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}'),
            backgroundColor: AppColors.accentEmerald,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        throw Exception('Location unavailable');
      }
    } catch (err) {
      if (!mounted) return;
      setState(() => _isLocatingGps = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not access GPS. Please enter your address details below.'),
          backgroundColor: AppColors.accentCoral,
        ),
      );
    }
  }

  Future<void> _onConfirmBooking() async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);

    final resolvedAddress = _addressController.text.trim().isEmpty
        ? 'Plot 42, Near KIIT Campus, Patia, Bhubaneswar, 751024'
        : _addressController.text.trim();

    String city = 'Bhubaneswar';
    if (_selectedDistrict == 'Cuttack') city = 'Cuttack';
    if (_selectedDistrict == 'Puri') city = 'Puri';

    final serviceItem = widget.cart.items.isNotEmpty
        ? widget.cart.items.values.first.service
        : null;
    final int serviceId = serviceItem?.id ?? 3;

    final now = DateTime.now();
    final scheduledDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${(now.day + _selectedDateIndex).toString().padLeft(2, '0')}";
    final slot = _isEmergencySquad ? 'Emergency 20-Min Dispatch' : _timeSlots[_selectedSlotIndex];

    String? bookingCode;
    String? arrivalOtp;
    String? completionOtp;

    if (ApiConfig.useLiveBackend) {
      final authProvider = widget.auth ?? AuthProvider();
      final token = await authProvider.ensureValidToken();

      if (token != null) {
        final res = await ApiService.instance.createBooking(
          token: token,
          bookingData: {
            'service_id': serviceId,
            'district': _selectedDistrict,
            'city': city,
            'address': resolvedAddress,
            'pincode': '751024',
            'scheduled_date': scheduledDate,
            'scheduled_time': slot,
            'is_emergency': _isEmergencySquad ? 1 : 0,
            'notes': 'Booked live via Prithvi Fix Mobile App (${widget.cart.totalQuantity} items)',
          },
        );

        if (res.isSuccess && res.data != null) {
          final b = res.data!['booking'] as Map<String, dynamic>?;
          if (b != null) {
            bookingCode = b['booking_code']?.toString();
            arrivalOtp = b['arrival_otp']?.toString();
            completionOtp = b['completion_otp']?.toString();
          }
        }
      }
    }

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    // Fallback if offline
    bookingCode ??= 'BKG-2026-${(10000 + DateTime.now().millisecondsSinceEpoch % 90000)}';

    // Capture cart items snapshots and total amount before clearing cart
    final double bookedAmount = widget.cart.subtotal;
    final String bookedServiceName = widget.cart.items.isNotEmpty
        ? widget.cart.items.values.first.service.name
        : 'Cooperative Service';

    // Clear cart on successful placement
    widget.cart.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => OrderSuccessScreen(
          cart: widget.cart,
          district: _selectedDistrict,
          address: resolvedAddress,
          date: _dates[_selectedDateIndex],
          slot: slot,
          paymentMethod: _selectedPaymentMethod,
          arrivalOtp: arrivalOtp,
          completionOtp: completionOtp,
          bookingCode: bookingCode!,
          bookedAmount: bookedAmount > 0 ? bookedAmount : 129.0,
          bookedServiceName: bookedServiceName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Confirm Booking'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Stepper Progress Header
          _buildProgressStepper(),

          // Active Step Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              child: _buildCurrentStepContent(),
            ),
          ),

          // Bottom Action Bar
          _buildBottomAction(),
        ],
      ),
    );
  }

  Widget _buildProgressStepper() {
    final steps = ['Cart', 'Address', 'Time Slot', 'Payment'];

    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: List.generate(steps.length, (index) {
          final isDone = index < _currentStep;
          final isCurrent = index == _currentStep;

          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDone
                              ? AppColors.accentEmerald
                              : isCurrent
                                  ? AppColors.primary
                                  : AppColors.border,
                        ),
                        child: Center(
                          child: isDone
                              ? const Icon(Icons.check, size: 16, color: Colors.white)
                              : Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: isCurrent ? Colors.white : AppColors.textMuted,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        steps[index],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                          color: isCurrent ? AppColors.primary : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                if (index < steps.length - 1)
                  Container(
                    width: 20,
                    height: 2,
                    color: index < _currentStep ? AppColors.accentEmerald : AppColors.border,
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStep1Summary();
      case 1:
        return _buildStep2Address();
      case 2:
        return _buildStep3Schedule();
      case 3:
        return _buildStep4EscrowPayment();
      default:
        return const SizedBox();
    }
  }

  // STEP 1: SUMMARY
  Widget _buildStep1Summary() {
    final items = widget.cart.items.values.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selected Services',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 12),
        ...items.map((item) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
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
                      item.service.name,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Qty: ${item.quantity} • ${item.service.formattedPrice}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              Text(
                '₹${item.totalPrice.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.accentTeal),
              ),
            ],
          ),
        )),
      ],
    );
  }

  // STEP 2: ADDRESS & DISTRICT SELECTION
  Widget _buildStep2Address() {
    final districts = ['Khordha', 'Cuttack', 'Puri'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Service District (Odisha)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 6),
        const Text(
          'Choose your registered district for artisan cooperative dispatch',
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 10),
        Row(
          children: districts.map((d) {
            final isSel = _selectedDistrict == d;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDistrict = d;
                    if (_cityController.text.isEmpty ||
                        _cityController.text == 'Bhubaneswar' ||
                        _cityController.text == 'Cuttack' ||
                        _cityController.text == 'Puri') {
                      _cityController.text = d == 'Khordha' ? 'Bhubaneswar' : d;
                      _syncFullAddress();
                    }
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSel ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: isSel ? AppColors.primary : AppColors.border),
                  ),
                  child: Center(
                    child: Text(
                      d,
                      style: TextStyle(
                        color: isSel ? Colors.white : AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),

        // CHOICE 1: LIVE GPS
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF86EFAC)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.accentEmerald.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.my_location_rounded, color: AppColors.accentEmerald, size: 20),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Option 1: Quick GPS Pinpoint',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF166534)),
                        ),
                        Text(
                          'Latch precise coordinates for your doorstep technician',
                          style: TextStyle(fontSize: 11.5, color: Color(0xFF15803D)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLocatingGps ? null : _detectCurrentGps,
                  icon: _isLocatingGps
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.navigation_rounded, size: 18),
                  label: Text(_isLocatingGps ? 'Locating via GPS...' : '📍 Use Current GPS Location'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentEmerald,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              if (_gpsLatitude != null && _gpsLongitude != null) ...[
                const SizedBox(height: 8),
                Text(
                  '✓ GPS Latched: ${_gpsLatitude!.toStringAsFixed(5)}, ${_gpsLongitude!.toStringAsFixed(5)}',
                  style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF166534)),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 20),

        // DIVIDER
        const Row(
          children: [
            Expanded(child: Divider(color: AppColors.border)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'OR ENTER DETAILS MANUALLY',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.textMuted, letterSpacing: 0.5),
              ),
            ),
            Expanded(child: Divider(color: AppColors.border)),
          ],
        ),

        const SizedBox(height: 16),

        // CHOICE 2: DETAILED MANUAL ENTRY
        const Text(
          'Option 2: Detailed Doorstep Address',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 12),

        _buildAddressInputField(
          controller: _housePlotController,
          label: 'House / Flat / Plot / Building No.',
          hint: 'e.g. Flat 302, Plot No. B-45',
          icon: Icons.home_outlined,
        ),
        const SizedBox(height: 10),

        _buildAddressInputField(
          controller: _streetAreaController,
          label: 'Street / Colony / Locality',
          hint: 'e.g. Infocity Road, Patia',
          icon: Icons.place_outlined,
        ),
        const SizedBox(height: 10),

        _buildAddressInputField(
          controller: _landmarkController,
          label: 'Landmark (Optional)',
          hint: 'e.g. Near KIIT Campus 3 or Apollo Pharmacy',
          icon: Icons.flag_outlined,
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              flex: 3,
              child: _buildAddressInputField(
                controller: _cityController,
                label: 'City / Town',
                hint: 'e.g. Bhubaneswar',
                icon: Icons.location_city_outlined,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: _buildAddressInputField(
                controller: _pincodeController,
                label: 'Pincode',
                hint: '751024',
                icon: Icons.markunread_mailbox_outlined,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddressInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 13.5, color: AppColors.textPrimary),
            onChanged: (_) => _syncFullAddress(),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              prefixIcon: Icon(icon, size: 18, color: AppColors.textMuted),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 12.5, color: AppColors.textMuted),
            ),
          ),
        ),
      ],
    );
  }

  // STEP 3: SCHEDULE
  Widget _buildStep3Schedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Emergency Toggle
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _isEmergencySquad ? const Color(0xFFFEE2E2) : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _isEmergencySquad ? AppColors.accentCoral : AppColors.border),
          ),
          child: Row(
            children: [
              Icon(Icons.bolt_rounded, color: _isEmergencySquad ? AppColors.accentCoral : AppColors.textMuted, size: 24),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '24/7 Priority Emergency Dispatch',
                      style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                    ),
                    Text(
                      'Artisan dispatches under 20 mins • Zero surge pricing',
                      style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _isEmergencySquad,
                activeColor: AppColors.accentCoral,
                onChanged: (val) => setState(() => _isEmergencySquad = val),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        if (!_isEmergencySquad) ...[
          const Text(
            'Select Appointment Date',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(_dates.length, (index) {
              final isSel = _selectedDateIndex == index;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedDateIndex = index),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSel ? AppColors.primary : AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: isSel ? AppColors.primary : AppColors.border),
                    ),
                    child: Center(
                      child: Text(
                        _dates[index],
                        style: TextStyle(
                          color: isSel ? Colors.white : AppColors.textSecondary,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),

          const Text(
            'Select 2-Hour Time Window',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 10),
          ...List.generate(_timeSlots.length, (index) {
            final isSel = _selectedSlotIndex == index;
            return GestureDetector(
              onTap: () => setState(() => _selectedSlotIndex = index),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSel ? AppColors.accentTeal.withOpacity(0.08) : AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: isSel ? AppColors.accentTeal : AppColors.border, width: isSel ? 1.5 : 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _timeSlots[index],
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                        color: isSel ? AppColors.accentTeal : AppColors.textPrimary,
                      ),
                    ),
                    if (isSel) const Icon(Icons.check_circle_rounded, color: AppColors.accentTeal, size: 20),
                  ],
                ),
              ),
            );
          }),
        ],
      ],
    );
  }

  // STEP 4: ESCROW & PAYMENT
  Widget _buildStep4EscrowPayment() {
    final paymentMethods = [
      {'id': 'UPI', 'name': 'Instant UPI (GPay / PhonePe / QR)', 'icon': Icons.qr_code_scanner_rounded},
      {'id': 'CARD', 'name': 'RuPay / Credit / Debit Card', 'icon': Icons.credit_card_rounded},
      {'id': 'NET_BANKING', 'name': 'Net Banking (All Indian Banks)', 'icon': Icons.account_balance_rounded},
      {'id': 'COD', 'name': 'Pay After Service (Cash / UPI on Site)', 'icon': Icons.handshake_rounded},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🏛️ ESCROW DISTRIBUTION
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.shield_outlined, color: AppColors.primary, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Statutory 93-2-5 Escrow Distribution',
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildRow('93% Direct Living Wage to Artisan:', '₹${widget.cart.workerDirectWage93.toStringAsFixed(2)}', isBold: true),
              _buildRow('5% Worker Mini-PF & ESIC Insurance:', '₹${widget.cart.welfareFund5.toStringAsFixed(2)}'),
              _buildRow('2% Cooperative Platform Upkeep:', '₹${widget.cart.platformUpkeep2.toStringAsFixed(2)}'),
              const Divider(height: 16),
              _buildRow('Final Total Amount:', '₹${widget.cart.subtotal.toStringAsFixed(2)}', isBold: true, highlight: true),
            ],
          ),
        ),
        const SizedBox(height: 20),

        const Text(
          'Select Payment Method',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 10),

        ...paymentMethods.map((m) {
          final isSel = _selectedPaymentMethod == m['id'];
          return GestureDetector(
            onTap: () => setState(() => _selectedPaymentMethod = m['id'] as String),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isSel ? AppColors.primary.withOpacity(0.06) : AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isSel ? AppColors.primary : AppColors.border, width: isSel ? 1.5 : 1),
              ),
              child: Row(
                children: [
                  Icon(m['icon'] as IconData, color: isSel ? AppColors.primary : AppColors.textSecondary, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      m['name'] as String,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  if (isSel) const Icon(Icons.radio_button_checked, color: AppColors.primary, size: 20),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildRow(String label, String value, {bool isBold = false, bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: isBold ? FontWeight.w700 : FontWeight.w500, color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              color: highlight ? AppColors.accentTeal : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Row(
        children: [
          if (_currentStep > 0) ...[
            BouncingWidget(
              onTap: () => setState(() => _currentStep -= 1),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary, size: 20),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: BouncingWidget(
              onTap: _isSubmitting
                  ? () {}
                  : () {
                      if (_currentStep < 3) {
                        setState(() => _currentStep += 1);
                      } else {
                        _onConfirmBooking();
                      }
                    },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: _currentStep == 3 ? AppColors.accentTeal : AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(
                          _currentStep == 3
                              ? 'Confirm Order & Sync Live Data ➔'
                              : 'Continue (${_currentStep + 1}/4) ➔',
                          style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
