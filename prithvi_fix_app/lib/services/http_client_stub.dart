abstract class PlatformHttpClient {
  Future<Map<String, dynamic>> get(String url, {Map<String, String>? headers});
  Future<Map<String, dynamic>> post(String url, {Map<String, String>? headers, dynamic body});
}

PlatformHttpClient getPlatformHttpClient() =>
    throw UnsupportedError('Cannot create platform HTTP client on this platform.');
