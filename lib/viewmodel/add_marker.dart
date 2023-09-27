import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/marker_list.dart';
import 'current_position.dart';

class AddMyMarkers {


  final Set<Marker> _marker = <Marker>{};

  get marker => _marker;

  Future<void> addMarkers(double lat, double long) async {
    final markerList = MarkerList();
    // currentPosition.getMyCurrentPosition();
    // print('Start getMyCurrentPosition===================');
    // print('end getMyCurrentPosition===================');
    Map<String,dynamic> aList = {"name": "내위치", "latitude": "$lat", "longitude": "$long", "image": 'images/mypos.png'};
    print('aList == $aList');
    markerList.restaurants.add(aList);
    print('add list done');
    print(markerList.restaurants);
    final markers = await Future.wait(markerList.restaurants.map((e) async {
      final Uint8List? markerIcon = await getBytesFromAsset(e["image"], 150, 150);
      return Marker(
        markerId: MarkerId(e["name"]),
        infoWindow: InfoWindow(title: e["name"]),
        position: LatLng(
            double.parse(e["latitude"]), double.parse(e["longitude"])),
        icon: BitmapDescriptor.fromBytes(markerIcon!),
      );
    }));
    _marker.addAll(markers);
    print('marker == $marker');

  }

  Future<Uint8List?> getBytesFromAsset(String path, int width,
      int height) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(), targetWidth: width, targetHeight: height);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))?.buffer
        .asUint8List();
  }
}