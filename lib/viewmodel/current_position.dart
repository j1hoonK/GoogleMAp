import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class CurrentPosition with ChangeNotifier{
  double myLatitude = 0.0;
  double myLongitude = 0.0;

  Future<void> getMyCurrentPosition() async {
    LocationPermission permission = await Geolocator.requestPermission();
    print('(current_position.dart) permissionInfo = $permission');
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );
    myLatitude = position.latitude;
    myLongitude = position.longitude;
    notifyListeners();
  }
}