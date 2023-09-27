import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map/viewmodel/current_position.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'config/loading.dart';
import 'model/marker_list.dart';

class GoogleMapApp extends StatefulWidget {
  @override
  State<GoogleMapApp> createState() => _GoogleMapAppState();
}

class _GoogleMapAppState extends State<GoogleMapApp> {
  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    Provider.of<CurrentPosition>(context, listen: false)
        .getMyCurrentPosition()
        .then((_) {
      setState(() {});
    });

    _marker.addAll(markerList.restaurants.map((e) => Marker(
      markerId: MarkerId(e["name"]),  // MarkerId를 사용하여 고유한 ID를 할당합니다.
      infoWindow: InfoWindow(title: e["name"]),
      position: LatLng(double.parse(e["latitude"]), double.parse(e["longitude"])),  // String에서 double로 변환
      icon: BitmapDescriptor
    )));

    super.initState();
  }

  void setCustomMapPin() async {
    markerIcon = await getBytesFromAsset('assets/img/marker.png', 130);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  final Set<Marker> _marker = <Marker>{};
  MarkerList markerList = MarkerList();

  @override
  Widget build(BuildContext context) {
    var currentPos = Provider.of<CurrentPosition>(context, listen: false);
    var myLatitude = currentPos.myLatitude;
    var myLongitude = currentPos.myLongitude;

    final CameraPosition initialPosition = CameraPosition(
      //bearing: 192.8334901395799,
      tilt: 10,
      target: LatLng(myLatitude, myLongitude),
      zoom: 16,
    );

    Future<void> goToMyLocation() async {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(initialPosition));
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined),
          onPressed: () {},
        ),
        title: Text('내 주변'),
        actions: [
          IconButton(
              icon: Icon(
                Icons.search,
              ),
              onPressed: () {})
        ],
      ),
      body: myLatitude == 0.0
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Flexible(
                  flex: 8,
                  child: GoogleMap(
                    markers: _marker,
                    mapType: MapType.normal,
                    initialCameraPosition: initialPosition,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  ),
                ),
                Flexible(child: Text(myLatitude.toString())),
                Text(myLongitude.toString()),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: goToMyLocation,
        label: Text('My Position'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }
}
