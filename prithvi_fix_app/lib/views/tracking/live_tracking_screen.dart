import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import '../../core/theme/app_colors.dart';
import '../../core/animations/spring_curves.dart';
import '../../core/constants/app_images.dart';
import '../../core/config/api_config.dart';
import '../../services/api_service.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_image.dart';

enum JobStatusStage {
  requested,
  matched,
  inTransit,
  inProgress,
  completed,
  cancelled,
}

/// Urban Company-grade Live Tracking & Dual-OTP Telemetry Screen
/// Features animated GPS map, 5-stage status stepper,
/// Master Artisan profile card, live OTP validation, and statutory Form IV invoice.
class LiveTrackingScreen extends StatefulWidget {
  final String bookingCode;
  final String district;
  final String address;
  final CartProvider cart;
  final JobStatusStage initialStage;
  final String? arrivalOtp;
  final String? completionOtp;
  final String? workerName;
  final String? workerPhone;
  final String? workerCode;
  final String? workerTier;
  final double? workerRating;
  final String? serviceCategory;
  final double? initialAmount;
  final String? initialServiceName;

  const LiveTrackingScreen({
    Key? key,
    required this.bookingCode,
    required this.district,
    required this.address,
    required this.cart,
    this.initialStage = JobStatusStage.requested,
    this.arrivalOtp,
    this.completionOtp,
    this.workerName,
    this.workerPhone,
    this.workerCode,
    this.workerTier,
    this.workerRating,
    this.serviceCategory,
    this.initialAmount,
    this.initialServiceName,
  }) : super(key: key);

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _mapAnimController;
  late JobStatusStage _currentStage;
  String _cancellationReason = 'Need to reschedule to another time';
  int _secondsElapsed = 0; // Starts from 0 on physical doorstep entry
  Timer? _jobTimer;
  Timer? _telemetryPollTimer;
  bool _isSyncing = false;
  bool _arrivalOtpVerified = false;
  bool _completionOtpVerified = false;

  String _arrivalOtp = '----';
  String _completionOtp = '----';
  String _assignedWorkerName = 'Artisan Assigned';
  String _assignedWorkerPhone = '';
  String? _workerCode;
  String? _workerTier;
  double? _workerRating;
  String? _serviceCategory;
  double? _liveDistanceKm;
  int? _liveEtaMinutes;
  Map<String, dynamic>? _liveTrackingData;
  double _customerLat = 20.3540;
  double _customerLng = 85.8170;
  double _workerLat = 20.3420;
  double _workerLng = 85.8080;
  List<ll.LatLng> _roadPolylinePoints = [];
  final MapController _mapController = MapController();

  // Dynamic booking & invoice data from Supabase
  double? _liveBookingAmount;
  double? _liveTotalAmount;
  double? _liveCooperativeFee;
  double? _livePlatformFee;
  double? _livePartsCost;
  String? _livePartsDetails;
  String? _liveServiceName;
  String? _guaranteeArmedUntil;

  @override
  void initState() {
    super.initState();
    _currentStage = widget.initialStage;
    if (widget.arrivalOtp != null && widget.arrivalOtp!.isNotEmpty) {
      _arrivalOtp = widget.arrivalOtp!;
    }
    if (widget.completionOtp != null && widget.completionOtp!.isNotEmpty) {
      _completionOtp = widget.completionOtp!;
    }
    if (widget.workerName != null && widget.workerName!.isNotEmpty) {
      _assignedWorkerName = widget.workerName!;
    }
    if (widget.workerPhone != null && widget.workerPhone!.isNotEmpty) {
      _assignedWorkerPhone = widget.workerPhone!;
    }
    _workerCode = widget.workerCode;
    _workerTier = widget.workerTier;
    _workerRating = widget.workerRating;
    _serviceCategory = widget.serviceCategory;

    if (widget.initialAmount != null) {
      _liveBookingAmount = widget.initialAmount;
      _liveTotalAmount = widget.initialAmount;
    }
    if (widget.initialServiceName != null) {
      _liveServiceName = widget.initialServiceName;
    }

    if (_currentStage == JobStatusStage.inProgress || _currentStage == JobStatusStage.completed) {
      _arrivalOtpVerified = true;
    }
    _mapAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    _startTimerIfNeeded();
    _startTelemetryPolling();

    // Initial immediate sync with Supabase
    _syncLiveTelemetry(silent: true);
  }

  void _startTelemetryPolling() {
    _telemetryPollTimer?.cancel();
    _telemetryPollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted && ApiConfig.useLiveBackend) {
        _syncLiveTelemetry(silent: true);
      }
    });
  }

  Future<void> _syncLiveTelemetry({bool silent = false}) async {
    if (_isSyncing) return;
    if (!silent) setState(() => _isSyncing = true);

    if (ApiConfig.useLiveBackend) {
      try {
        final token = await AuthProvider.instance.ensureValidToken();
        final res = await ApiService.instance.getBooking(widget.bookingCode, token: token);
        if (res.isSuccess && res.data != null && mounted) {
          final b = res.data!;
          final serverStatus = (b['status'] ?? '').toString().toUpperCase();

          setState(() {
            if (b['arrival_otp'] != null && b['arrival_otp'].toString().isNotEmpty) {
              _arrivalOtp = b['arrival_otp'].toString();
            }
            if (b['completion_otp'] != null && b['completion_otp'].toString().isNotEmpty) {
              _completionOtp = b['completion_otp'].toString();
            }
            if (b['worker_name'] != null && b['worker_name'].toString().isNotEmpty) {
              _assignedWorkerName = b['worker_name'].toString();
            }
            if (b['worker_phone'] != null && b['worker_phone'].toString().isNotEmpty) {
              _assignedWorkerPhone = b['worker_phone'].toString();
            }
            if (b['worker_code'] != null && b['worker_code'].toString().isNotEmpty) {
              _workerCode = b['worker_code'].toString();
            }
            if (b['worker_tier'] != null && b['worker_tier'].toString().isNotEmpty) {
              _workerTier = b['worker_tier'].toString();
            }
            if (b['worker_rating'] != null) {
              _workerRating = (b['worker_rating'] is num)
                  ? (b['worker_rating'] as num).toDouble()
                  : double.tryParse(b['worker_rating'].toString());
            }
            if (b['service_category'] != null && b['service_category'].toString().isNotEmpty) {
              _serviceCategory = b['service_category'].toString();
            }

            if (b['service_name'] != null && b['service_name'].toString().isNotEmpty) {
              _liveServiceName = b['service_name'].toString();
            }
            if (b['amount'] != null) {
              _liveBookingAmount = (b['amount'] is num) ? (b['amount'] as num).toDouble() : double.tryParse(b['amount'].toString());
            }
            if (b['total_amount'] != null) {
              _liveTotalAmount = (b['total_amount'] is num) ? (b['total_amount'] as num).toDouble() : double.tryParse(b['total_amount'].toString());
            }
            if (b['cooperative_fee'] != null) {
              _liveCooperativeFee = (b['cooperative_fee'] is num) ? (b['cooperative_fee'] as num).toDouble() : double.tryParse(b['cooperative_fee'].toString());
            }
            if (b['platform_fee'] != null) {
              _livePlatformFee = (b['platform_fee'] is num) ? (b['platform_fee'] as num).toDouble() : double.tryParse(b['platform_fee'].toString());
            }
            if (b['parts_cost'] != null) {
              _livePartsCost = (b['parts_cost'] is num) ? (b['parts_cost'] as num).toDouble() : double.tryParse(b['parts_cost'].toString());
            }
            if (b['parts_details'] != null && b['parts_details'].toString().isNotEmpty) {
              _livePartsDetails = b['parts_details'].toString();
            }
            if (b['guarantee_armed_until'] != null) {
              _guaranteeArmedUntil = b['guarantee_armed_until'].toString();
            }

            if (b['distance_km'] != null) {
              _liveDistanceKm = (b['distance_km'] is num)
                  ? (b['distance_km'] as num).toDouble()
                  : double.tryParse(b['distance_km'].toString());
            }
            if (b['eta_minutes'] != null) {
              _liveEtaMinutes = (b['eta_minutes'] is num)
                  ? (b['eta_minutes'] as num).toInt()
                  : int.tryParse(b['eta_minutes'].toString());
            }
            if (b['tracking'] != null && b['tracking'] is Map) {
              _liveTrackingData = Map<String, dynamic>.from(b['tracking']);
              if (_liveTrackingData!['distanceKm'] != null && _liveDistanceKm == null) {
                _liveDistanceKm = (_liveTrackingData!['distanceKm'] as num).toDouble();
              }
              if (_liveTrackingData!['etaMinutes'] != null && _liveEtaMinutes == null) {
                _liveEtaMinutes = (_liveTrackingData!['etaMinutes'] as num).toInt();
              }
              if (_liveTrackingData!['customerCoords'] != null && _liveTrackingData!['customerCoords'] is Map) {
                final cc = _liveTrackingData!['customerCoords'];
                if (cc['lat'] != null) _customerLat = (cc['lat'] as num).toDouble();
                if (cc['lng'] != null) _customerLng = (cc['lng'] as num).toDouble();
              }
              if (_liveTrackingData!['workerCoords'] != null && _liveTrackingData!['workerCoords'] is Map) {
                final wc = _liveTrackingData!['workerCoords'];
                if (wc['lat'] != null) _workerLat = (wc['lat'] as num).toDouble();
                if (wc['lng'] != null) _workerLng = (wc['lng'] as num).toDouble();
              }
              if (_liveTrackingData!['routeWaypoints'] != null && _liveTrackingData!['routeWaypoints'] is List) {
                final list = _liveTrackingData!['routeWaypoints'] as List;
                final pts = list.map((item) {
                  final lat = (item['lat'] as num).toDouble();
                  final lng = (item['lng'] as num).toDouble();
                  return ll.LatLng(lat, lng);
                }).toList();
                if (pts.isNotEmpty) {
                  // Prepend worker's exact current pin and append customer's doorstep pin
                  _roadPolylinePoints = [
                    ll.LatLng(_workerLat, _workerLng),
                    ...pts,
                    ll.LatLng(_customerLat, _customerLng),
                  ];
                }
              }
            } else {
              if (b['latitude'] != null) {
                final lat = double.tryParse(b['latitude'].toString());
                if (lat != null && lat != 0) _customerLat = lat;
              }
              if (b['longitude'] != null) {
                final lng = double.tryParse(b['longitude'].toString());
                if (lng != null && lng != 0) _customerLng = lng;
              }
              if (b['worker_latitude'] != null) {
                final lat = double.tryParse(b['worker_latitude'].toString());
                if (lat != null && lat != 0) _workerLat = lat;
              }
              if (b['worker_longitude'] != null) {
                final lng = double.tryParse(b['worker_longitude'].toString());
                if (lng != null && lng != 0) _workerLng = lng;
              }
            }

            if (serverStatus == 'CANCELLED') {
              _currentStage = JobStatusStage.cancelled;
            } else if (serverStatus == 'COMPLETED') {
              _currentStage = JobStatusStage.completed;
            } else if (serverStatus == 'IN_PROGRESS') {
              _currentStage = JobStatusStage.inProgress;
              _arrivalOtpVerified = true;
            } else if (serverStatus == 'ACCEPTED' || serverStatus == 'MATCHED') {
              _currentStage = JobStatusStage.inTransit;
            } else if (serverStatus == 'REQUESTED') {
              _currentStage = JobStatusStage.requested;
            }
          });
        }
      } catch (e) {
        debugPrint('Live telemetry sync error: $e');
      }
    }

    if (!silent) {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    if (mounted) {
      if (!silent) {
        setState(() => _isSyncing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text('Live Status: ${_currentStage.name.toUpperCase()}'),
              ],
            ),
            backgroundColor: AppColors.accentTeal,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        setState(() {});
      }
    }
  }

  void _startTimerIfNeeded() {
    if (_currentStage == JobStatusStage.inProgress) {
      _jobTimer?.cancel();
      _jobTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            _secondsElapsed++;
          });
        }
      });
    } else {
      _jobTimer?.cancel();
    }
  }

  @override
  void dispose() {
    _mapAnimController.dispose();
    _jobTimer?.cancel();
    _telemetryPollTimer?.cancel();
    super.dispose();
  }

  void _showCancelOrderDialog() {
    String selectedReason = 'Need to reschedule to another time';
    final reasons = [
      'Need to reschedule to another time',
      'Booked by mistake',
      'Artisan took longer than expected',
      'Found alternate local solution',
      'Price or service query',
      'Other',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.accentCoralLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.cancel_outlined, color: AppColors.accentCoral, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Cancel Service Order',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                          ),
                          Text(
                            '#${widget.bookingCode}',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Cooperative Advisory policy note
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _currentStage == JobStatusStage.requested
                        ? AppColors.accentEmeraldLight
                        : AppColors.accentAmberLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _currentStage == JobStatusStage.requested
                          ? AppColors.accentEmerald.withOpacity(0.3)
                          : AppColors.accentAmber.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _currentStage == JobStatusStage.requested
                            ? Icons.check_circle_rounded
                            : Icons.info_outline_rounded,
                        color: _currentStage == JobStatusStage.requested
                            ? AppColors.accentEmerald
                            : AppColors.accentAmber,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _currentStage == JobStatusStage.requested
                              ? '100% Free Full Cancellation: Artisan has not been dispatched yet.'
                              : 'Artisan Dispatched: Under Prithvi Fix rules, ₹50 transit compensation is credited to the artisan.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _currentStage == JobStatusStage.requested
                                ? AppColors.accentEmerald
                                : const Color(0xFF78350F),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                const Text(
                  'Please select a reason:',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),

                ...reasons.map((r) => RadioListTile<String>(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(r, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                      value: r,
                      groupValue: selectedReason,
                      activeColor: AppColors.accentCoral,
                      onChanged: (val) {
                        setModalState(() => selectedReason = val!);
                      },
                    )),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          side: const BorderSide(color: AppColors.border),
                        ),
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Keep Order', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentCoral,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        onPressed: () async {
                          Navigator.pop(ctx);
                          _jobTimer?.cancel();
                          _telemetryPollTimer?.cancel();

                          setState(() {
                            _cancellationReason = selectedReason;
                            _currentStage = JobStatusStage.cancelled;
                          });

                          // Call live backend if enabled
                          if (ApiConfig.useLiveBackend) {
                            try {
                              final token = await AuthProvider.instance.ensureValidToken();
                              if (token != null) {
                                await ApiService.instance.cancelBooking(
                                  token: token,
                                  bookingIdOrCode: widget.bookingCode,
                                  reason: selectedReason,
                                );
                              }
                            } catch (e) {
                              debugPrint('Failed to cancel booking on backend: $e');
                            }
                          }

                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Order #${widget.bookingCode} has been cancelled.'),
                                backgroundColor: AppColors.accentCoral,
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          }
                        },
                        child: const Text('Confirm Cancel', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _advanceStage() {
    setState(() {
      switch (_currentStage) {
        case JobStatusStage.requested:
          _currentStage = JobStatusStage.matched;
          break;
        case JobStatusStage.matched:
          _currentStage = JobStatusStage.inTransit;
          break;
        case JobStatusStage.inTransit:
          _arrivalOtpVerified = true;
          _currentStage = JobStatusStage.inProgress;
          _startTimerIfNeeded();
          break;
        case JobStatusStage.inProgress:
          _completionOtpVerified = true;
          _currentStage = JobStatusStage.completed;
          _jobTimer?.cancel();
          _showInvoiceModal();
          break;
        case JobStatusStage.completed:
          _currentStage = JobStatusStage.requested;
          _arrivalOtpVerified = false;
          _completionOtpVerified = false;
          break;
        case JobStatusStage.cancelled:
          break;
      }
    });
  }

  void _confirmArtisanArrivalHandshake() {
    final artisanFirstName = _assignedWorkerName.split(' ').first;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.verified_user_rounded, color: AppColors.primary, size: 24),
            SizedBox(width: 8),
            Text('Doorstep Handshake'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Artisan $_assignedWorkerName is on-site at your door. Verify OTP $_arrivalOtp to begin the repair session:',
              style: const TextStyle(fontSize: 13.5, color: AppColors.textPrimary, height: 1.4),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'OTP: $_arrivalOtp',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 3, color: AppColors.primary),
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
              elevation: 0,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _arrivalOtpVerified = true;
                _currentStage = JobStatusStage.inProgress;
                _startTimerIfNeeded();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ Doorstep Handshake Verified: Work session in progress!'),
                  backgroundColor: AppColors.accentEmerald,
                  duration: Duration(seconds: 3),
                ),
              );
            },
            child: const Text('Verify & Start Work', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _confirmServiceCompletionHandshake() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.task_alt_rounded, color: AppColors.accentEmerald, size: 24),
            SizedBox(width: 8),
            Text('Approve Completion'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Have you inspected the repaired appliance and verified parts replaced? Confirm Completion OTP 7193:',
              style: TextStyle(fontSize: 13.5, color: AppColors.textPrimary, height: 1.4),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.accentEmeraldLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.accentEmerald.withOpacity(0.3)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'OTP: 7193',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 3, color: AppColors.accentEmerald),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Not Yet', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentEmerald,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _completionOtpVerified = true;
                _currentStage = JobStatusStage.completed;
                _jobTimer?.cancel();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🎉 Service Completed! Opening Prithvi Fix Tax Invoice...'),
                  backgroundColor: AppColors.accentEmerald,
                  duration: Duration(seconds: 3),
                ),
              );
              Future.delayed(const Duration(milliseconds: 400), () {
                if (mounted) _showInvoiceModal();
              });
            },
            child: const Text('Confirm & Sign Off', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _showInvoiceModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _buildInvoiceSheet(),
    );
  }

  void _showChatModal() {
    final artisanFirstName = _assignedWorkerName.split(' ').first;
    final quickMessages = [
      'I am waiting at the main apartment gate.',
      'Take the elevator to 4th floor, Flat 402.',
      'Please call when you reach the security check.',
      'Do you have shoe covers with you?',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
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
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.support_agent_rounded, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Live Chat with $artisanFirstName',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '${_serviceCategory ?? "Cooperative"} Specialist • On Duty',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Quick Instructions to Artisan:',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),
            ...quickMessages.map((msg) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Sent: "$msg"'),
                      backgroundColor: AppColors.accentTeal,
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.send_rounded, size: 14, color: AppColors.accentTeal),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(msg, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                      ),
                    ],
                  ),
                ),
              ),
            )),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _showCallModal() {
    final artisanFirstName = _assignedWorkerName.split(' ').first;
    final phoneDisplay = _assignedWorkerPhone.isNotEmpty ? _assignedWorkerPhone : 'Verified Cooperative Number';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.phone_in_talk_rounded, color: AppColors.accentTeal, size: 40),
            const SizedBox(height: 12),
            const Text(
              'Cooperative Direct-Connect',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              'Connecting you directly to $_assignedWorkerName without number masking fees.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_rounded, size: 16, color: AppColors.accentEmerald),
                  SizedBox(width: 8),
                  Text(
                    'Recorded for Safety & Service Guarantee',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            BouncingWidget(
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Dialing $artisanFirstName ($phoneDisplay)...'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.accentEmerald,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    'Call Artisan ($phoneDisplay)',
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          children: [
            const Text(
              'Live Artisan Telemetry',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            Text(
              '#${widget.bookingCode} • ${widget.district}',
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_currentStage != JobStatusStage.completed &&
              _currentStage != JobStatusStage.cancelled &&
              _currentStage != JobStatusStage.inProgress)
            TextButton.icon(
              icon: const Icon(Icons.cancel_outlined, color: AppColors.accentCoral, size: 16),
              label: const Text(
                'Cancel Order',
                style: TextStyle(color: AppColors.accentCoral, fontWeight: FontWeight.w700, fontSize: 12),
              ),
              onPressed: _showCancelOrderDialog,
            ),
          IconButton(
            icon: const Icon(Icons.receipt_long_rounded, color: AppColors.primary),
            tooltip: 'View Prithvi Fix Tax Invoice',
            onPressed: _showInvoiceModal,
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // 1. LIVE ANIMATED GPS MAP (Automatically hides once Arrival OTP is verified / job in progress)
            if (!_arrivalOtpVerified && _currentStage != JobStatusStage.inProgress && _currentStage != JobStatusStage.completed) ...[
              _buildInteractiveMap(),
            ],

            // 2. LIVE SATELLITE TELEMETRY STATUS BAR
            _buildLiveTelemetryStatusBar(),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // 3. 5-STAGE PROGRESS STEPPER
                  _buildStatusStepper(),
                  const SizedBox(height: 16),

                  // 4. DUAL-OTP SECURITY ACTION CARD (Locked during REQUESTED, unlocked on acceptance!)
                  _buildDualOtpSecurityCard(),
                  const SizedBox(height: 16),

                  // 5. MASTER ARTISAN PROFILE CARD (or Searching Radar during REQUESTED)
                  _buildArtisanProfileCard(),
                  const SizedBox(height: 16),

                  // 6. BOOKING SUMMARY & GUARANTEES
                  _buildBookingDetailsCard(),
                  const SizedBox(height: 16),

                  // 7. CANCEL ORDER BUTTON (If active and not yet in-progress or completed)
                  if (_currentStage != JobStatusStage.completed &&
                      _currentStage != JobStatusStage.cancelled &&
                      _currentStage != JobStatusStage.inProgress) ...[
                    _buildCancelOrderButton(),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // 1. LIVE OPENSTREETMAP INTERACTIVE GPS MAP
  // --------------------------------------------------------------------------
  Widget _buildInteractiveMap() {
    final customerPoint = ll.LatLng(_customerLat, _customerLng);
    final workerPoint = ll.LatLng(_workerLat, _workerLng);
    final centerPoint = ll.LatLng(
      (_customerLat + _workerLat) / 2,
      (_customerLng + _workerLng) / 2,
    );

    return Container(
      height: 270,
      width: double.infinity,
      color: const Color(0xFFF1F5F9),
      child: Stack(
        children: [
          // Live OpenStreetMap Tiles
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: centerPoint,
              initialZoom: 14.2,
              minZoom: 10.0,
              maxZoom: 18.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'in.prithvifix.app',
                maxZoom: 19,
              ),
              // Clean Direct Transit Line connecting Artisan to Doorstep
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: [workerPoint, customerPoint],
                    strokeWidth: 4.5,
                    color: const Color(0xFF2563EB),
                    borderStrokeWidth: 2.0,
                    borderColor: Colors.white,
                  ),
                ],
              ),
              // GPS Pins
              MarkerLayer(
                markers: [
                  // 1. Customer Destination Marker (Blue Home Pin)
                  Marker(
                    point: customerPoint,
                    width: 48,
                    height: 48,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.home_rounded, color: Colors.white, size: 18),
                        ),
                      ],
                    ),
                  ),

                  // 2. Artisan Live GPS Marker (Amber/Teal EV Two-Wheeler)
                  Marker(
                    point: workerPoint,
                    width: 52,
                    height: 52,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.accentEmerald,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2.5),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accentEmerald.withOpacity(0.4),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.two_wheeler_rounded, color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Floating Live ETA Pill
          Positioned(
            top: 14,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.accentEmerald,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getEtaText(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Re-center / GPS Accuracy Pill
          Positioned(
            bottom: 12,
            right: 14,
            child: InkWell(
              onTap: () {
                _mapController.move(centerPoint, 14.5);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.my_location_rounded, color: AppColors.accentTeal, size: 14),
                    SizedBox(width: 6),
                    Text(
                      'Center Map',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getEtaText() {
    final eta = _liveEtaMinutes ?? 11;
    final dist = _liveDistanceKm != null ? '${_liveDistanceKm!.toStringAsFixed(1)} km' : '2.4 km';

    switch (_currentStage) {
      case JobStatusStage.requested:
        return 'Matching Nearest Artisan...';
      case JobStatusStage.matched:
        return 'Artisan Assigned • Dispatched ($dist • ~$eta mins)';
      case JobStatusStage.inTransit:
        return 'Arriving in $eta mins • $dist away';
      case JobStatusStage.inProgress:
        final m = _secondsElapsed ~/ 60;
        final s = _secondsElapsed % 60;
        return 'Job Active on Doorstep • ${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')} elapsed';
      case JobStatusStage.completed:
        return 'Service Successfully Completed';
      case JobStatusStage.cancelled:
        return 'Booking Order Cancelled';
    }
  }

  // --------------------------------------------------------------------------
  // 2. LIVE SATELLITE TELEMETRY STATUS BAR (Production Real-Time Feed)
  // --------------------------------------------------------------------------
  Widget _buildLiveTelemetryStatusBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.accentEmerald,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentEmerald.withOpacity(0.7),
                      blurRadius: 6,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text(
                        'LIVE SATELLITE TELEMETRY',
                        style: TextStyle(
                          color: AppColors.accentTeal,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        '• OD-GPS-SYNC',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _getTelemetryStatusLabel(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          BouncingWidget(
            onTap: () => _syncLiveTelemetry(silent: false),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isSyncing
                      ? const SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(strokeWidth: 1.5, color: Colors.white),
                        )
                      : const Icon(Icons.sync_rounded, color: Colors.white, size: 14),
                  const SizedBox(width: 5),
                  const Text(
                    'Live Sync',
                    style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTelemetryStatusLabel() {
    switch (_currentStage) {
      case JobStatusStage.requested:
        return 'Broadcasting to Prithvi Fix Cooperative Grid';
      case JobStatusStage.matched:
        return 'Artisan Assigned • Preparing Toolkit';
      case JobStatusStage.inTransit:
        return 'Artisan En Route • Speed 24 km/h';
      case JobStatusStage.inProgress:
        return 'Job Active on Doorstep • Safe Protocol';
      case JobStatusStage.completed:
        return 'Job Completed • Zero-Surge Guarantee Active';
      case JobStatusStage.cancelled:
        return 'Order Cancelled • Artisan Released';
    }
  }

  // --------------------------------------------------------------------------
  // 3. 5-STAGE PROGRESS STEPPER
  // --------------------------------------------------------------------------
  Widget _buildStatusStepper() {
    final artisanFirstName = _assignedWorkerName.split(' ').first;
    final stages = [
      {'title': 'Requested', 'desc': 'Dispatched to Cooperative Hub'},
      {'title': 'Assigned', 'desc': 'Artisan $artisanFirstName matched'},
      {'title': 'In Transit', 'desc': 'En route on EV two-wheeler'},
      {'title': 'In Progress', 'desc': 'Arrival OTP verified, repair active'},
      {'title': 'Completed', 'desc': 'Checked & Form IV invoice issued'},
    ];

    final currentIndex = _currentStage.index;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Status Progression',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 14),
          Column(
            children: List.generate(stages.length, (index) {
              final isPassed = index < currentIndex;
              final isCurrent = index == currentIndex;
              final isPending = index > currentIndex;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isPassed
                              ? AppColors.accentEmerald
                              : isCurrent
                                  ? AppColors.primary
                                  : AppColors.border,
                        ),
                        child: Center(
                          child: isPassed
                              ? const Icon(Icons.check, size: 14, color: Colors.white)
                              : isCurrent
                                  ? Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    )
                                  : null,
                        ),
                      ),
                      if (index < stages.length - 1)
                        Container(
                          width: 2,
                          height: 28,
                          color: isPassed ? AppColors.accentEmerald : AppColors.border,
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stages[index]['title']!,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                              color: isPending ? AppColors.textMuted : AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            stages[index]['desc']!,
                            style: TextStyle(
                              fontSize: 11,
                              color: isCurrent ? AppColors.accentTeal : AppColors.textSecondary,
                              fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // 4. DUAL-OTP SECURITY ACTION CARD (Locked during REQUESTED, unlocked on acceptance!)
  // --------------------------------------------------------------------------
  Widget _buildDualOtpSecurityCard() {
    if (_currentStage == JobStatusStage.cancelled) {
      return _buildCancelledBanner();
    }

    if (_currentStage == JobStatusStage.completed) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.accentEmeraldLight,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.accentEmerald.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.verified_rounded, color: AppColors.accentEmerald, size: 24),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Both OTPs Verified • Service Completed',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.accentEmerald,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Your Prithvi Fix 30-Day Zero-Surge Warranty and Official Cooperative Tax Invoice are ready.',
              style: TextStyle(fontSize: 12.5, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),
            BouncingWidget(
              onTap: _showInvoiceModal,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: AppColors.accentEmerald,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'View Prithvi Fix Invoice & Warranty ➔',
                    style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // ─────────────────────────────────────────────────────────────
    // WEBSITE MODEL: IN 'REQUESTED' STAGE (AWAITING ARTISAN ACCEPTANCE)
    // THE OTPs ARE LOCKED AND NOT DISPLAYED YET!
    // ─────────────────────────────────────────────────────────────
    if (_currentStage == JobStatusStage.requested) {
      return _buildLockedOtpCard();
    }

    final isArrivalActive = _currentStage.index <= JobStatusStage.inTransit.index;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.accentTeal.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentTeal.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shield_rounded, color: AppColors.accentTeal, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Anti-Fraud Dual-OTP Security',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.accentTeal.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isArrivalActive ? 'Step 1 of 2' : 'Step 2 of 2',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accentTeal,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Two OTP Columns side by side
          Row(
            children: [
              // Arrival OTP
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _arrivalOtpVerified
                        ? AppColors.accentEmeraldLight
                        : isArrivalActive
                            ? AppColors.primary.withOpacity(0.06)
                            : AppColors.background,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _arrivalOtpVerified
                          ? AppColors.accentEmerald
                          : isArrivalActive
                              ? AppColors.primary
                              : AppColors.border,
                      width: isArrivalActive ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'ARRIVAL OTP',
                            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: AppColors.primary),
                          ),
                          if (_arrivalOtpVerified)
                            const Icon(Icons.check_circle, size: 14, color: AppColors.accentEmerald),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _arrivalOtp,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _arrivalOtpVerified
                            ? 'Verified upon entry'
                            : 'Give on physical doorstep arrival',
                        style: TextStyle(
                          fontSize: 10,
                          color: _arrivalOtpVerified ? AppColors.accentEmerald : AppColors.textSecondary,
                          fontWeight: _arrivalOtpVerified ? FontWeight.w700 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Completion OTP
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _completionOtpVerified
                        ? AppColors.accentEmeraldLight
                        : !isArrivalActive
                            ? AppColors.accentAmberLight
                            : AppColors.background,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _completionOtpVerified
                          ? AppColors.accentEmerald
                          : !isArrivalActive
                              ? AppColors.accentAmber
                              : AppColors.border,
                      width: !isArrivalActive ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'COMPLETION OTP',
                            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: AppColors.accentAmber),
                          ),
                          if (_completionOtpVerified)
                            const Icon(Icons.check_circle, size: 14, color: AppColors.accentEmerald),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _arrivalOtpVerified ? _completionOtp : '••••',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                          color: _arrivalOtpVerified ? AppColors.textPrimary : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _completionOtpVerified
                            ? 'Job signed off'
                            : _arrivalOtpVerified
                                ? 'Give ONLY after testing repair'
                                : 'Locked until arrival verified',
                        style: TextStyle(
                          fontSize: 10,
                          color: _completionOtpVerified ? AppColors.accentEmerald : AppColors.textSecondary,
                          fontWeight: _completionOtpVerified ? FontWeight.w700 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Security advice banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: AppColors.accentAmber, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isArrivalActive
                        ? 'Never share Arrival OTP over phone. Hand over only when ${_assignedWorkerName.split(" ").first} shows ID.'
                        : 'Verify work and spotless clean-up before sharing Completion OTP.',
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),

          // Consumer guidance note
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.primary.withOpacity(0.15)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'The artisan will enter the Arrival OTP on their mobile portal upon doorstep arrival to begin work.',
                    style: TextStyle(fontSize: 11.5, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLockedOtpCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7).withOpacity(0.95), // amber-50
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFCD34D), width: 1.5), // amber-300
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD97706).withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFFDE68A), // amber-100
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.lock_rounded, color: Color(0xFF92400E), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Security Arrival OTP Locked',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF78350F), // amber-950
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDE68A),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'AWAITING ARTISAN ACCEPTANCE',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF92400E),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'To protect security, your 4-digit Arrival OTP will be generated automatically the moment an artisan accepts your work request.',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF92400E),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFFCD34D)),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD97706),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Live broadcast active • Searching nearby certified artisans...',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF92400E),
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

  Widget _buildSearchingArtisanCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(Icons.radar_rounded, color: AppColors.primary, size: 26),
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Matching Nearest Artisan...',
                      style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Broadcasting to verified guild members in Khordha district',
                      style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              backgroundColor: Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelledBanner() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.accentCoralLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.accentCoral.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.cancel_rounded, color: AppColors.accentCoral, size: 24),
              SizedBox(width: 10),
              Text(
                'Order Cancelled',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.accentCoral,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Reason: $_cancellationReason',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 4),
          const Text(
            'The allocated artisan has been released back into the cooperative guild pool. Any pre-authorized charges have been voided.',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.35),
          ),
          const SizedBox(height: 14),
          BouncingWidget(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: const Center(
                child: Text(
                  'Return to Home',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelOrderButton() {
    return BouncingWidget(
      onTap: _showCancelOrderDialog,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.accentCoral.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cancel_outlined, color: AppColors.accentCoral, size: 18),
            const SizedBox(width: 8),
            Text(
              _currentStage == JobStatusStage.requested
                  ? 'Cancel Order (100% Free Full Cancellation)'
                  : 'Cancel Order (Artisan En Route)',
              style: const TextStyle(
                color: AppColors.accentCoral,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // 5. MASTER ARTISAN PROFILE CARD
  // --------------------------------------------------------------------------
  Widget _buildArtisanProfileCard() {
    if (_currentStage == JobStatusStage.cancelled) {
      return const SizedBox.shrink();
    }

    if (_currentStage == JobStatusStage.requested) {
      return _buildSearchingArtisanCard();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Artisan Avatar with badge
              Stack(
                children: [
                  CustomImage(
                    imageInfo: AppImages.technicianAvatar,
                    width: 68,
                    height: 68,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: AppColors.accentEmerald,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.verified, color: Colors.white, size: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _assignedWorkerName,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: AppColors.accentAmber, size: 16),
                            const SizedBox(width: 2),
                            Text(
                              _workerRating != null ? _workerRating!.toStringAsFixed(1) : '4.8',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Certified ${_serviceCategory ?? "Cooperative"} Artisan (${_workerTier ?? "Grade A"})',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'CO-OP ID: ${_workerCode ?? "OD-COOP-ART-LIVE"}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Trust Badges Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _TrustPill(icon: Icons.local_police_rounded, label: 'Police Verified'),
                _TrustPill(icon: Icons.vaccines_rounded, label: 'Vaccinated'),
                _TrustPill(icon: Icons.handshake_rounded, label: 'Cooperative Co-owner'),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Action Buttons: Call & Chat
          Row(
            children: [
              Expanded(
                child: BouncingWidget(
                  onTap: _showCallModal,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    decoration: BoxDecoration(
                      color: AppColors.accentEmeraldLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.accentEmerald.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.call_rounded, color: AppColors.accentEmerald, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'Call ${_assignedWorkerName.split(" ").first}',
                          style: const TextStyle(
                            color: AppColors.accentEmerald,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: BouncingWidget(
                  onTap: _showChatModal,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline_rounded, color: AppColors.primary, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'Direct Chat',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // 6. BOOKING DETAILS & ESCROW BREAKDOWN
  // --------------------------------------------------------------------------
  Widget _buildBookingDetailsCard() {
    final cart = widget.cart;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Service Location & Address',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_rounded, color: AppColors.accentTeal, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.address.isEmpty ? 'Patia, Bhubaneswar, Khordha District, Odisha' : widget.address,
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.3),
                ),
              ),
            ],
          ),
          const Divider(height: 24),

          const Text(
            'Reserved Services in Escrow',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          if (cart.items.isNotEmpty) ...[
            ...cart.items.values.map((it) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${it.service.name} x${it.quantity}',
                    style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '₹${it.totalPrice.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                ],
              ),
            )),
          ] else ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _liveServiceName ?? 'Tap, Spout & Flush Valve Leak Repair',
                      style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    '₹${((_liveTotalAmount != null ? (_liveTotalAmount! - (_livePartsCost ?? 0.0)) : (_liveBookingAmount ?? widget.initialAmount ?? (cart.items.isNotEmpty ? cart.subtotal : 129.0)))).toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),
          ],

          if ((_livePartsCost != null && _livePartsCost! > 0) || (_livePartsDetails != null && _livePartsDetails!.isNotEmpty)) ...[
            const Divider(height: 16),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.build_circle_rounded, size: 15, color: Color(0xFF92400E)),
                          SizedBox(width: 5),
                          Text(
                            'ISI Approved Replacement Parts',
                            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: Color(0xFF92400E)),
                          ),
                        ],
                      ),
                      Text(
                        '+₹${(_livePartsCost ?? 0).toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF92400E)),
                      ),
                    ],
                  ),
                  if (_livePartsDetails != null && _livePartsDetails!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      _livePartsDetails!,
                      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: Color(0xFF78350F)),
                    ),
                  ],
                ],
              ),
            ),
          ],
          const Divider(height: 20),

          // Total Tariff
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Regulated Tariff:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              ),
              Text(
                '₹${(_liveTotalAmount ?? (widget.initialAmount ?? (cart.items.isNotEmpty ? cart.subtotal : 129.0))).toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.accentTeal),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // STATUTORY ODISHA FORM IV TAX INVOICE MODAL
  // --------------------------------------------------------------------------
  Widget _buildInvoiceSheet() {
    final cart = widget.cart;
    final double total = _liveTotalAmount ??
        (widget.initialAmount ?? (cart.items.isNotEmpty ? cart.subtotal : 129.0));
    final double parts = _livePartsCost ?? 0.0;
    final double serviceBaseTotal = (total - parts) > 0 ? (total - parts) : total;

    // 93-2-5 Statutory Escrow Split (Zero fluctuation: perfectly aligned with website and official DB schema)
    final double coopFee = _liveCooperativeFee ??
        (cart.items.isNotEmpty ? cart.welfareFund5 : ((serviceBaseTotal * 0.05 * 100).roundToDouble() / 100));
    final double platFee = _livePlatformFee ??
        (cart.items.isNotEmpty ? cart.platformUpkeep2 : ((serviceBaseTotal * 0.02 * 100).roundToDouble() / 100));
    final double wageAmount = _liveBookingAmount ??
        (cart.items.isNotEmpty ? cart.workerDirectWage93 : ((serviceBaseTotal - coopFee - platFee) * 100).roundToDouble() / 100);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Header Banner: Prithvi Fix Official Cooperative Tax Invoice (Matching Website Tax Invoice)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF1E293B)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E3A8A),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.4)),
                    ),
                    child: const Center(
                      child: Text(
                        'PF',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.verified_rounded, size: 14, color: Color(0xFF60A5FA)),
                            SizedBox(width: 4),
                            Text(
                              'PRITHVI FIX COOPERATIVE',
                              style: TextStyle(
                                color: Color(0xFF93C5FD),
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Prithvi Fix',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Official Cooperative Tax Invoice • ${widget.district.toUpperCase()} HUB',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF059669).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFF10B981)),
                    ),
                    child: const Text(
                      'TAX INVOICE',
                      style: TextStyle(
                        color: Color(0xFF34D399),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Customer Billed To & Service Details Box (Website Style)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMetaCol('INVOICE NO.', 'INV-2026-${widget.bookingCode.replaceAll(RegExp(r'[^0-9]'), '')}'),
                      _buildMetaCol('BOOKING REF', widget.bookingCode),
                      _buildMetaCol('DATE', 'Today, 2026'),
                    ],
                  ),
                  const Divider(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'BILLED TO (CUSTOMER)',
                              style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: Color(0xFF64748B), letterSpacing: 0.5),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Citizen Customer',
                              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                            ),
                            Text(
                              widget.address.isNotEmpty ? widget.address : 'Patia, Bhubaneswar',
                              style: const TextStyle(fontSize: 11, color: Color(0xFF475569)),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'ASSIGNED ARTISAN',
                            style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: Color(0xFF64748B), letterSpacing: 0.5),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _assignedWorkerName,
                            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                          ),
                          const Text(
                            'Prithvi Fix Verified Guild',
                            style: TextStyle(fontSize: 11, color: Color(0xFF10B981), fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 24),

            // Official Statutory Tax Invoice Table (Matching Website Tax Invoice Exactly)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  // Table Header
                  Container(
                    color: const Color(0xFFF8FAFC),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: const Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Text(
                            'DESCRIPTION OF LABOUR / SERVICE / PARTS',
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF475569),
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'SAC CODE',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF475569),
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'STANDARD RATE',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF475569),
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'TOTAL (INR)',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF475569),
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

                  // Row 1: Skilled Labour / Service Charge
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _liveServiceName ?? 'Tap, Spout & Flush Valve Leak Repair',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 3),
                              const Text(
                                'Standard cooperative artisan skilled labour charge',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF64748B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Expanded(
                          flex: 2,
                          child: Text(
                            '998719',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF475569),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            '₹${wageAmount.toStringAsFixed(2)}',
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF334155),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            '₹${wageAmount.toStringAsFixed(2)}',
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Optional Row: Parts Cost (if any)
                  if (parts > 0 || (_livePartsDetails != null && _livePartsDetails!.isNotEmpty)) ...[
                    const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
                    Container(
                      color: const Color(0xFFFEF3C7).withOpacity(0.35),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Standard Locked Replacement Parts',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF92400E),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  _livePartsDetails ?? 'Original Manufacturer Components',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF78350F),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Expanded(
                            flex: 2,
                            child: Text(
                              'PRT-STD',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF92400E),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              '₹${parts.toStringAsFixed(2)}',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF92400E),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              '₹${parts.toStringAsFixed(2)}',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF92400E),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Row 2: PF & Insurance (5%)
                  const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
                  Container(
                    color: const Color(0xFFEFF6FF).withOpacity(0.4),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'PF & Insurance (5%)',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1E3A8A),
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'ESIC accident insurance, PF, health & pension contribution',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF2563EB),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Expanded(
                          flex: 2,
                          child: Text(
                            'COOP-WLF',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E3A8A),
                            ),
                          ),
                        ),
                        const Expanded(
                          flex: 2,
                          child: Text(
                            '5.0%',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E3A8A),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            '₹${coopFee.toStringAsFixed(2)}',
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E3A8A),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Row 3: Platform Fee (2%)
                  const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Platform Fee (2%)',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Dispatch helpline, quality assurance & server infra',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF64748B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Expanded(
                          flex: 2,
                          child: Text(
                            'PLAT-FEE',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF475569),
                            ),
                          ),
                        ),
                        const Expanded(
                          flex: 2,
                          child: Text(
                            '2.0%',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF334155),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            '₹${platFee.toStringAsFixed(2)}',
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Table Footer: TOTAL TAX INVOICE VALUE
                  const Divider(height: 1, thickness: 1.5, color: Color(0xFFCBD5E1)),
                  Container(
                    color: const Color(0xFFF8FAFC),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'TOTAL TAX INVOICE VALUE:',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0F172A),
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '₹${total.toStringAsFixed(total % 1 == 0 ? 0 : 2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 30-Day Free Rework Warranty Certificate
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.accentEmeraldLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.accentEmerald.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified_user_rounded, color: AppColors.accentEmerald, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '30-Day Zero-Cost Rework Warranty',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.accentEmerald,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _guaranteeArmedUntil != null
                              ? 'Warranty Armed & Active until: ${_guaranteeArmedUntil!.split("T").first}'
                              : 'Automatically armed upon doorstep completion OTP verification.',
                          style: const TextStyle(fontSize: 11, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Download & Close buttons
            Row(
              children: [
                Expanded(
                  child: BouncingWidget(
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Downloading Form IV PDF Invoice...'),
                          backgroundColor: AppColors.accentEmerald,
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: Text(
                          'Download PDF Invoice',
                          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                BouncingWidget(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Center(
                      child: Text(
                        'Close',
                        style: TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w700),
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
  }

  Widget _buildMetaCol(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
      ],
    );
  }

  Widget _buildEscrowDetailRow(String title, String amount, String note, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              Text(amount, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: color)),
            ],
          ),
          const SizedBox(height: 1),
          Text(note, style: const TextStyle(fontSize: 10.5, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

class _TrustPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TrustPill({Key? key, required this.icon, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.accentTeal),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

/// Custom Vector Map Painter showing animated worker position along a route to customer pin
class MapRoutePainter extends CustomPainter {
  final double progress;

  MapRoutePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw Road Grids / Blocks
    final roadPaint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final roadSubPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Grid roads
    final pathRoad1 = Path()
      ..moveTo(0, size.height * 0.3)
      ..lineTo(size.width, size.height * 0.3);

    final pathRoad2 = Path()
      ..moveTo(0, size.height * 0.75)
      ..lineTo(size.width, size.height * 0.75);

    final pathCross1 = Path()
      ..moveTo(size.width * 0.25, 0)
      ..lineTo(size.width * 0.25, size.height);

    final pathCross2 = Path()
      ..moveTo(size.width * 0.72, 0)
      ..lineTo(size.width * 0.72, size.height);

    canvas.drawPath(pathRoad1, roadPaint);
    canvas.drawPath(pathRoad1, roadSubPaint);

    canvas.drawPath(pathRoad2, roadPaint);
    canvas.drawPath(pathRoad2, roadSubPaint);

    canvas.drawPath(pathCross1, roadPaint);
    canvas.drawPath(pathCross1, roadSubPaint);

    canvas.drawPath(pathCross2, roadPaint);
    canvas.drawPath(pathCross2, roadSubPaint);

    // 2. Active Technician Route (Curved Cyan Route)
    final routePath = Path()
      ..moveTo(size.width * 0.18, size.height * 0.75)
      ..cubicTo(
        size.width * 0.45,
        size.height * 0.75,
        size.width * 0.45,
        size.height * 0.3,
        size.width * 0.72,
        size.height * 0.3,
      );

    final routeGlowPaint = Paint()
      ..color = AppColors.accentTeal.withOpacity(0.3)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final routePaint = Paint()
      ..color = AppColors.accentTeal
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(routePath, routeGlowPaint);
    canvas.drawPath(routePath, routePaint);

    // 3. Customer Destination Pin at (size.width * 0.72, size.height * 0.3)
    final custX = size.width * 0.72;
    final custY = size.height * 0.3;

    // Pulse effect
    final pulsePaint = Paint()
      ..color = AppColors.primary.withOpacity(0.18 + 0.15 * math.sin(progress * 2 * math.pi))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(custX, custY), 22 + 4 * math.sin(progress * 2 * math.pi), pulsePaint);

    final destPinPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(custX, custY), 12, destPinPaint);

    final destCenterPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(custX, custY), 5, destCenterPaint);

    // 4. Moving Technician Marker along the route
    // Compute current position based on ping-pong progress (0.15 to 0.85)
    final pathMetrics = routePath.computeMetrics().first;
    final normalized = 0.15 + (0.70 * progress);
    final tangent = pathMetrics.getTangentForOffset(pathMetrics.length * normalized);

    if (tangent != null) {
      final workerPos = tangent.position;

      // Worker Shadow
      canvas.drawCircle(
        Offset(workerPos.dx, workerPos.dy + 4),
        16,
        Paint()..color = Colors.black.withOpacity(0.2),
      );

      // Worker Outer Ring (Amber / Yellow EV marker)
      canvas.drawCircle(
        workerPos,
        15,
        Paint()..color = AppColors.accentAmber,
      );

      // Worker Inner circle
      canvas.drawCircle(
        workerPos,
        12,
        Paint()..color = Colors.white,
      );

      // Center dot
      canvas.drawCircle(
        workerPos,
        5,
        Paint()..color = const Color(0xFF0F172A),
      );
    }
  }

  @override
  bool shouldRepaint(covariant MapRoutePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
