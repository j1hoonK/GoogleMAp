import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../view/location_test.dart';

class RealtimeLoc {

  OrderTrackingPageState orderTrackingPage = OrderTrackingPageState();
  LocationData? currentLocation;
  void getCurrentLocation() async {
    Location location = Location();
    location.getLocation().then(
      (location) {
        currentLocation = location;
      },
    );
    GoogleMapController googleMapController = await orderTrackingPage.controller.future;
    location.onLocationChanged.listen(
      (newLoc) {
        currentLocation = newLoc;
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 13.5,
              target: LatLng(
                newLoc.latitude!,
                newLoc.longitude!,
              ),
            ),
          ),
        );
      },
    );
  }
}
