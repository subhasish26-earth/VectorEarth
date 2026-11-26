import 'dart:html' as html;

Future<Map<String, double>?> getCoordinates() async {
  try {
    final pos = await html.window.navigator.geolocation.getCurrentPosition();
    final lat = pos.coords?.latitude?.toDouble();
    final lng = pos.coords?.longitude?.toDouble();
    if (lat != null && lng != null) {
      return {'lat': lat, 'lng': lng};
    }
    return null;
  } catch (e) {
    return null;
  }
}
