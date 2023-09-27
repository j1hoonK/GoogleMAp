import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../view/google_map.dart';
import '../viewmodel/current_position.dart';

double? myLatitude;
double? myLongitude;

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyLocation();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMapApp();
  }
}

void getMyLocation() async {
  CurrentPosition currentPosition = CurrentPosition();
  await currentPosition.getMyCurrentPosition();

  myLatitude = currentPosition.myLatitude;
  myLongitude = currentPosition.myLongitude;
  print("(loading.dart) (위도, 경도) = ($myLatitude, $myLongitude)");


  Future<void> goToMyLocation() async {
  final Completer<GoogleMapController> controller0 = Completer();
  final CameraPosition initialPosition = CameraPosition(
    target: LatLng(myLatitude!, myLongitude!),
    zoom: 15,
  );
    final GoogleMapController controller = await controller0.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(initialPosition));
  }
}
