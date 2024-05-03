import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWithMarkers extends StatefulWidget {
  const MapWithMarkers({super.key});
  @override
  _MapWithMarkersState createState() => _MapWithMarkersState();
}

class _MapWithMarkersState extends State<MapWithMarkers> {
  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(37.7749, -122.4194);
  static const LatLng _destination = const LatLng(37.773972, -122.431297);

  final Set<Marker> _markers = {
    Marker(markerId: MarkerId('source'), position: _center),
    Marker(markerId: MarkerId('destination'), position: _destination),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voici le chemain '),
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 15.0,
        ),
        markers: _markers,
        polylines: _createPolylines(_center, _destination),
      ),
    );
  }

  Set<Polyline> _createPolylines(LatLng start, LatLng end) {
    Set<Polyline> polylines = {};
    polylines.add(Polyline(
      polylineId: PolylineId('route'),
      color: Colors.blue,
      width: 5,
      points: [start, end],
    ));
    return polylines;
  }
}