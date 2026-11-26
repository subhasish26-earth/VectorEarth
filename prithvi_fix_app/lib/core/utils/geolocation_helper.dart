import 'geolocation_stub.dart'
    if (dart.library.html) 'geolocation_web.dart';

Future<Map<String, double>?> getCurrentCoordinates() => getCoordinates();
