import 'dart:async';
import '../core/config/api_config.dart';
import 'http_client.dart';

class ApiResult<T> {
  final bool isSuccess;
  final T? data;
  final String? errorMessage;
  final int? statusCode;

  ApiResult.success(this.data)
      : isSuccess = true,
        errorMessage = null,
        statusCode = 200;

  ApiResult.failure(this.errorMessage, [this.statusCode])
      : isSuccess = false,
        data = null;
}

/// Central Service for interacting with the Prithvi Fix Vercel/Supabase backend
class ApiService {
  static final ApiService instance = ApiService._internal();
  ApiService._internal();

  final _client = createHttpClient();

  /// Health Check: Tests if Vercel API and Supabase database are reachable
  Future<Map<String, dynamic>> checkHealth() async {
    try {
      var healthUrl = ApiConfig.baseUrl;
      if (healthUrl.endsWith('/api')) {
        healthUrl = '$healthUrl/health';
      } else {
        healthUrl = '$healthUrl/api/health';
      }

      final res = await _client.get(healthUrl);
      return res;
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  /// Authenticate citizen or artisan against live Vercel backend
  Future<ApiResult<Map<String, dynamic>>> login({
    required String emailOrPhone,
    required String password,
  }) async {
    try {
      final res = await _client.post(
        '${ApiConfig.baseUrl}/auth/login',
        body: {
          'emailOrPhone': emailOrPhone,
          'password': password,
        },
      );

      if (res['token'] != null && res['user'] != null) {
        return ApiResult.success(res);
      } else {
        final err = res['message'] ?? res['error'] ?? 'Authentication failed';
        return ApiResult.failure(err.toString());
      }
    } catch (e) {
      return ApiResult.failure('Network connection error: $e');
    }
  }

  /// Register citizen member into Supabase database via Vercel API
  Future<ApiResult<Map<String, dynamic>>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    String role = 'CUSTOMER',
    String district = 'Khordha',
    String city = 'Bhubaneswar',
    String address = '',
  }) async {
    try {
      final res = await _client.post(
        '${ApiConfig.baseUrl}/auth/register',
        body: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'role': role,
          'district': district,
          'city': city,
          'address': address,
        },
      );

      if (res['token'] != null && res['user'] != null) {
        return ApiResult.success(res);
      } else {
        final err = res['message'] ?? res['error'] ?? 'Registration failed';
        return ApiResult.failure(err.toString());
      }
    } catch (e) {
      return ApiResult.failure('Network connection error: $e');
    }
  }

  /// Fetch live service catalog from database
  Future<ApiResult<List<dynamic>>> fetchServices() async {
    try {
      final res = await _client.get('${ApiConfig.baseUrl}/services');
      if (res['services'] is List) {
        return ApiResult.success(res['services'] as List<dynamic>);
      }
      return ApiResult.failure('Unexpected format for services');
    } catch (e) {
      return ApiResult.failure('Failed to fetch services: $e');
    }
  }

  /// Post a new booking order to Vercel/Supabase
  Future<ApiResult<Map<String, dynamic>>> createBooking({
    required String token,
    required Map<String, dynamic> bookingData,
  }) async {
    try {
      final res = await _client.post(
        '${ApiConfig.baseUrl}/bookings',
        headers: {'Authorization': 'Bearer $token'},
        body: bookingData,
      );
      if (res['booking'] != null || res['id'] != null) {
        return ApiResult.success(res);
      }
      return ApiResult.failure(res['message'] ?? 'Booking creation failed');
    } catch (e) {
      return ApiResult.failure('Booking request error: $e');
    }
  }

  /// Verify Doorstep Arrival OTP (Handshake Phase 4)
  Future<ApiResult<Map<String, dynamic>>> verifyArrivalOtp({
    required String token,
    required int bookingId,
    required String otp,
  }) async {
    try {
      final res = await _client.post(
        '${ApiConfig.baseUrl}/bookings/$bookingId/verify-arrival-otp',
        headers: {'Authorization': 'Bearer $token'},
        body: {'otp': otp},
      );
      return ApiResult.success(res);
    } catch (e) {
      return ApiResult.failure('Arrival OTP verification error: $e');
    }
  }

  /// Verify Service Completion OTP (Handshake Phase 7)
  Future<ApiResult<Map<String, dynamic>>> verifyCompletionOtp({
    required String token,
    required int bookingId,
    required String otp,
  }) async {
    try {
      final res = await _client.post(
        '${ApiConfig.baseUrl}/bookings/$bookingId/verify-completion-otp',
        headers: {'Authorization': 'Bearer $token'},
        body: {'otp': otp},
      );
      return ApiResult.success(res);
    } catch (e) {
      return ApiResult.failure('Completion OTP verification error: $e');
    }
  }

  /// Cancel booking order
  Future<ApiResult<Map<String, dynamic>>> cancelBooking({
    required String token,
    required dynamic bookingIdOrCode,
    String reason = 'Cancelled by customer',
  }) async {
    try {
      final res = await _client.post(
        '${ApiConfig.baseUrl}/bookings/$bookingIdOrCode/cancel',
        headers: {'Authorization': 'Bearer $token'},
        body: {'reason': reason},
      );
      if (res['booking'] != null || res['message'] != null) {
        return ApiResult.success(res);
      }
      return ApiResult.failure(res['message'] ?? 'Cancellation failed');
    } catch (e) {
      return ApiResult.failure('Cancellation error: $e');
    }
  }

  /// List customer bookings from Vercel/Supabase
  Future<ApiResult<List<dynamic>>> getBookings({
    required String token,
    String? status,
  }) async {
    try {
      String url = '${ApiConfig.baseUrl}/bookings';
      if (status != null && status.isNotEmpty) {
        url += '?status=$status';
      }
      final res = await _client.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      if (res['bookings'] is List) {
        return ApiResult.success(res['bookings'] as List<dynamic>);
      }
      return ApiResult.failure(res['message'] ?? 'Failed to list bookings');
    } catch (e) {
      return ApiResult.failure('List bookings error: $e');
    }
  }

  /// Fetch a single booking order by ID or booking_code
  Future<ApiResult<Map<String, dynamic>>> getBooking(
    dynamic bookingIdOrCode, {
    String? token,
  }) async {
    try {
      final headers = <String, String>{};
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
      final res = await _client.get(
        '${ApiConfig.baseUrl}/bookings/$bookingIdOrCode',
        headers: headers,
      );
      if (res['booking'] != null) {
        return ApiResult.success(res['booking'] as Map<String, dynamic>);
      }
      return ApiResult.failure(res['message'] ?? 'Booking not found');
    } catch (e) {
      return ApiResult.failure('Error fetching booking: $e');
    }
  }

  /// Claim 30-Day Free Cooperative Repair Guarantee
  Future<ApiResult<Map<String, dynamic>>> claimGuarantee({
    required String token,
    required dynamic bookingId,
  }) async {
    try {
      final res = await _client.post(
        '${ApiConfig.baseUrl}/bookings/$bookingId/claim-guarantee',
        headers: {'Authorization': 'Bearer $token'},
        body: {},
      );
      if (res['success'] == true || res['revisit_booking'] != null || res['message'] != null) {
        return ApiResult.success(res);
      }
      return ApiResult.failure(res['message'] ?? 'Failed to claim warranty');
    } catch (e) {
      return ApiResult.failure('Claim guarantee error: $e');
    }
  }
}
