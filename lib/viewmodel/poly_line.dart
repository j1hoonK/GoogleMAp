import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';


class DrawLine with ChangeNotifier{
  List<LatLng> polylineCoordinates = [];

  static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  static const LatLng destination = LatLng(37.33429383, -122.06600055);

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyBdDI1Fzb4zlASU46cNm5gW35MX1j7GoWQ",
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach(
              (PointLatLng point) => polylineCoordinates.add(
            LatLng(point.latitude, point.longitude),
        ));
      notifyListeners();
      }
    }
  }
