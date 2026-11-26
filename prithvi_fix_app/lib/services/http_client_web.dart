import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'http_client_stub.dart';
export 'http_client_stub.dart';

PlatformHttpClient getPlatformHttpClient() => WebHttpClient();

class WebHttpClient implements PlatformHttpClient {
  @override
  Future<Map<String, dynamic>> get(String url, {Map<String, String>? headers}) async {
    try {
      final req = await html.HttpRequest.request(
        url,
        method: 'GET',
        requestHeaders: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          ...?headers,
        },
      );
      final text = req.responseText ?? '{}';
      return jsonDecode(text) as Map<String, dynamic>;
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  @override
  Future<Map<String, dynamic>> post(String url, {Map<String, String>? headers, dynamic body}) async {
    try {
      final req = await html.HttpRequest.request(
        url,
        method: 'POST',
        sendData: body is String ? body : (body != null ? jsonEncode(body) : null),
        requestHeaders: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          ...?headers,
        },
      );
      final text = req.responseText ?? '{}';
      return jsonDecode(text) as Map<String, dynamic>;
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }
}
