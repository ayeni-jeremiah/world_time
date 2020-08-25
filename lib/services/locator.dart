import 'package:geolocator/geolocator.dart';

class Locator {
  Position currentPosition;
  String currentAddress = "";
  double lat = 0, lon = 0;
  String locality = "", postalcode = "", country = "";

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;


  Future<void> getCurrentLocation() async {
    await geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
       currentPosition = position;
      lat = currentPosition.latitude;
      lon = currentPosition.longitude;
      print('$lat, $lon');
    }).catchError((e) {
      print(e);
    });
  }

  // ignore: unused_element
  void _getAddressFromLatLng(lat, lon) async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          lat, lon);

      Placemark place = p[0];

      currentAddress =
          "${place.locality}, ${place.postalCode}, ${place.country}";

      print(currentAddress);
      locality = place.locality;
      postalcode = place.postalCode;
      country = place.country;
    } catch (e) {
      print(e);
    }
  }
}
