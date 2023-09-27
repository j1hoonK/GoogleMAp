import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_map/viewmodel/poly_line.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({Key? key}) : super(key: key);

  @override
  State<OrderTrackingPage> createState() => OrderTrackingPageState();
}

class OrderTrackingPageState extends State<OrderTrackingPage> {
  @override
  void initState() {
    Provider.of<DrawLine>(context, listen:false).getPolyPoints();
    super.initState();
  }

  final Completer<GoogleMapController> _controller = Completer();
  get controller => _controller;
  static const LatLng initialPos = LatLng(37.334651545, -122.049361215);
  static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  static const LatLng destination = LatLng(37.33429383, -122.06600055);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DrawLine>(builder: (context, provider, child) =>
          GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: initialPos,
            zoom: 13.5,
          ),
          markers: {
            const Marker(
              markerId: MarkerId("source"),
              position: sourceLocation,
              draggable: false,
            ),
            const Marker(
              markerId: MarkerId("destination"),
              position: destination,
              draggable: false,
            ),
          },
          onMapCreated: (mapController) {
            _controller.complete(mapController);
          },
          polylines: {
              Polyline(
                polylineId: PolylineId("route"),
                points: provider.polylineCoordinates,
                color: Colors.purpleAccent,
                width: 8,
              ),
            }),
      ),
    );
  }
}
