import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../core/utilities/utils.dart';
import '../../model/pot_hole_model.dart';

class LocationServices {
  //
  /// ------------------------------------------------------------------ `get CURRENT LOCATION`
  static Future<List?> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    // ---------------- location off
    if (!serviceEnabled) {
      Utils.confirmDialogBox(
        'Alert!',
        'Location services are disabled...\nEnable location?.',
        yesFun: () => Geolocator.openLocationSettings(),
      );
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    // ---------------- permission denied
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        Utils.confirmDialogBox(
          'Alert!',
          'Location permissions are denied, Please enable to proceed.',
          yesFun: () => Geolocator.openAppSettings(),
        );
        return null;
      }
    }

    // ---------------- permission denied forever
    if (permission == LocationPermission.deniedForever) {
      Utils.confirmDialogBox(
        'Alert!',
        'Location permissions are denied permanently, we cannot proceed further.\nPlease enable them',
        yesFun: () => Geolocator.openAppSettings(),
      );
      return null;
    }

    Utils.progressIndctr(label: 'fetching location...');
    final position = await Geolocator.getCurrentPosition();

    Get.back();

    // ------------------------- getting address
    final place = await getAddress(position);

    return [position.latitude, position.longitude, place];
  }

  /// ------------------------------------------------------------------ `open GOOGLE MAP`
  static openGoogleMap(double lat, double long) async {
    String url = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    await launchUrlString(url);
  }

  /// ------------------------------------------------------------------ `get Address`
  static Future<PotholeModel> getAddress(Position position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    final place = PotholeModel(
      id: '',
      image: '',
      name: placemarks[0].name!,
      street: placemarks[0].street!,
      subArea: placemarks[0].subAdministrativeArea!,
      city: placemarks[0].administrativeArea!,
      country: placemarks[0].country!,
      postCode: placemarks[0].postalCode!,
      lat: position.latitude,
      long: position.longitude,
      date: DateTime.now().toIso8601String(),
      createdAt: Timestamp.now(),
      isVerified: 'false',
      description: '',
    );

    return place;
  }
}
