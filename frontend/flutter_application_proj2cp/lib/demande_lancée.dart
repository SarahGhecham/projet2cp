import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DemandelanceePage extends StatefulWidget {
  const DemandelanceePage({super.key});

  @override
  State<DemandelanceePage> createState() => _DemandelanceePageState();
}

class _DemandelanceePageState extends State<DemandelanceePage> {

  List <LatLng> coordinates = [
    LatLng(-33.86, 151.20),
    LatLng(-34.0, 150.0),
    LatLng(-37.81, 144.96),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map with Markers Example'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(-37.422, 140.084),
          zoom: 6.0,
        ),
        markers: Set <Marker>.from(coordinates.map((LatLng coordinate) {
          return Marker(
            markerId: MarkerId(
                '${coordinate.latitude}-${coordinate.longitude}'),
            position: coordinate,
          );
        })),
      ),
    );
  }
}