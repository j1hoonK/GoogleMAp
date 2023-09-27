import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_map/model/marker_list.dart';
import 'package:google_map/viewmodel/add_marker.dart';
import 'package:google_map/viewmodel/current_position.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class GoogleMapApp extends StatefulWidget {
  @override
  State<GoogleMapApp> createState() => _GoogleMapAppState();
}

class _GoogleMapAppState extends State<GoogleMapApp> {
  final Completer<GoogleMapController> _controller = Completer();
  AddMyMarkers addMyMarkers = AddMyMarkers();
  MarkerList markerList = MarkerList();

  @override
  void initState() {
    print('initState Start');
    final currentPos = Provider.of<CurrentPosition>(context, listen: false);
    currentPos.getMyCurrentPosition().then((_) {
      print('아니좀돼라');
      print(currentPos.myLongitude);
      addMyMarkers
          .addMarkers(currentPos.myLatitude, currentPos.myLongitude)
          .then((_) {
        setState(() {});
      });
      print('currentPos = ${currentPos.myLatitude}, ${currentPos.myLongitude}');
      setState(() {});
    });
    //addMyMarkers.addMarkers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var currentPos = Provider.of<CurrentPosition>(context, listen: false);
    var myLatitude = currentPos.myLatitude;
    var myLongitude = currentPos.myLongitude;
    // addMyMarkers.addMarkers(myLatitude, myLongitude);

    final CameraPosition initialPosition = CameraPosition(
      tilt: 10,
      target: LatLng(myLatitude, myLongitude),
      zoom: 17,
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
            onPressed: () {},
          )
        ],
      ),
      body: myLatitude == 0.0
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Flexible(
                  flex: 8,
                  child: GoogleMap(
                    markers: addMyMarkers.marker,
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
