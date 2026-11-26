import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'http_client_stub.dart';
export 'http_client_stub.dart';

PlatformHttpClient getPlatformHttpClient() => IoHttpClient();

class IoHttpClient implements PlatformHttpClient {
  final HttpClient _client = HttpClient()
    ..connectionTimeout = const Duration(seconds: 10);

  @override
  Future<Map<String, dynamic>> get(String url, {Map<String, String>? headers}) async {
    try {
      final uri = Uri.parse(url);
      final request = await _client.getUrl(uri);
      request.headers.set('Accept', 'application/json');
      headers?.forEach((k, v) => request.headers.set(k, v));
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> post(String url, {Map<String, String>? headers, dynamic body}) async {
    try {
      final uri = Uri.parse(url);
      final request = await _client.postUrl(uri);
      request.headers.contentType = ContentType.json;
      request.headers.set('Accept', 'application/json');
      headers?.forEach((k, v) => request.headers.set(k, v));
      if (body != null) {
        request.write(body is String ? body : jsonEncode(body));
      }
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      return jsonDecode(responseBody) as Map<String, dynamic>;
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }
}
