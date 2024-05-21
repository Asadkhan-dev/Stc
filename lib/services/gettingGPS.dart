import 'package:geolocator/geolocator.dart';

class locationService {
  static Future<Map<String, dynamic>> getLocation() async {
    bool serviceEnable = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnable) {
      Map<String, dynamic> myMap = {
        "locationIsPicked": false,
        "lat": "",
        "long": ""
      };
      return myMap;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Map<String, dynamic> myMap = {
          "locationIsPicked": false,
          "lat": "",
          "long": ""
        };
        return myMap;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Map<String, dynamic> myMap = {
        "locationIsPicked": false,
        "lat": "",
        "long": ""
      };
      return myMap;
    }
    var u = await Geolocator.getCurrentPosition();

    Map<String, dynamic> myMap = {
      "locationIsPicked": true,
      "lat": u.latitude.toString(),
      "long": u.longitude.toString()
    };
    return myMap;
  }
}
