import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_proj2cp/pages/mademande.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DemandelanceePage extends StatefulWidget {
  final List <LatLng> coordinates;
  final String adresse;
  final LatLng coords;
  final int demandeId;
  @override
  const DemandelanceePage({Key? key,required this.coordinates,required this.adresse,required this.coords,required this.demandeId}): super(key: key);

  @override
  State<DemandelanceePage> createState() => _DemandelanceePageState();
}

class _DemandelanceePageState extends State<DemandelanceePage> {

  //List <LatLng> coordinates = [];
  //var adresse = "Oued Smar";//la le l'adresse (appellation)
  void _navigateToNextPage(BuildContext context,int demandeId) {
    Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Mademande(demandeId: demandeId,)
    ),
  );}
   @override
  void initState() {
    super.initState();
    print(widget.coordinates);
    print(widget.adresse);
    print(widget.coords);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           Container(
             height: 42,
             width: 250,
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(10),
               color: Color(0xFFD6E3DC),
             ),
             child: Row(
               children: [
                 SvgPicture.asset("assets/pin_light.svg"),
                 Text(
                   widget.adresse,
                   style: GoogleFonts.poppins(fontSize: 16, color: Color(0xFF777777)),
                 ),
               ],
             ),
           ),
            SvgPicture.asset("assets/cancel.svg"),
          ],
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.coords,// là met l'adresse du clien (coordonnées)
              zoom: 15.0,
            ),
            markers: Set <Marker>.from(widget.coordinates.map((LatLng coordinate) {
              return Marker(
                markerId: MarkerId(
                    '${coordinate.latitude}-${coordinate.longitude}'),
                position: coordinate,
              );
            })),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 240, // Adjust height as needed
              decoration: BoxDecoration(
                color: Color(0xFFD6E3DC),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Votre demande a été envoyé au artisans du coin',
                        style: GoogleFonts.poppins(fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: (){_navigateToNextPage(context,widget.demandeId);},
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all<Size>(const Size(315, 55)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          backgroundColor:
                          MaterialStateProperty.all<Color>(const Color(0xFF05564B)),
                        ),
                        child: Text(
                          "Voir ma demande",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}