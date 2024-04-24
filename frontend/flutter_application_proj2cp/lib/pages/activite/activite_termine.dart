import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_proj2cp/constants/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Demande {
  final String name;
  final String orderTime;
  final String demandeImage;
  final Artisan artisan;
  Demande(
      {required this.name,
      required this.orderTime,
      required this.demandeImage,
      required this.artisan});
}

class Artisan {
  final String nomArtisan;
  final String prenomArtisan;
  final int points; // Use double for rating

  Artisan({
    required this.nomArtisan,
    required this.prenomArtisan,
    required this.points,
  });
}

class ActiviteTerminee {
  final dynamic demande;
  final dynamic rdv;

  ActiviteTerminee({
    required this.demande,
    required this.rdv,
  });
}

class DemandesTermines extends StatefulWidget {
  @override
  _DemandesTerminesState createState() => _DemandesTerminesState();
}

class _DemandesTerminesState extends State<DemandesTermines> {
  List<Demande?> demandesTerminees = [];

  @override
  void initState() {
    super.initState();
    fetchDemandesTerminees();
  }

  Future<void> fetchDemandesTerminees() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/client/AfficherActiviteTerminee/3'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Demande?> demandes = [];
        print('data: $data');

        for (var item in data) {
          final demande = item['demande'];
          final rdv = item['rdvAffich'];
                  print('rdv: $rdv');


          if (demande != null && rdv != null) {
            
            final String name = demande['Prestation']['nomPrestation'] ?? '';
                    print('name: $name');

            final String orderTime = rdv['DateFin'] + ', ' + rdv['HeureFin'] ?? '';
            final String demandeImage =demande['Prestation']['imagePrestation'] ?? '';
            final String nomArtisan = demande['Artisans'][0]['NomArtisan'] ?? '';
                    print('nomArtisan: $nomArtisan');

            final String prenomArtisan = demande['Artisans'][0]['PrenomArtisan'] ?? '';
            final String noteAsString = demande['Artisans'][0]['Note'] ?? '';
            final int points = int.tryParse(noteAsString) ?? 0;

            demandes.add(Demande(
              name: name,
              orderTime: orderTime,
              demandeImage: demandeImage,
              artisan: Artisan(
                nomArtisan: nomArtisan,
                prenomArtisan: prenomArtisan,
                points: points,
              ),
            ));
          }
        }

        setState(() {
          demandesTerminees = demandes;
        });
      } else {
        print('Failed to fetch activite terminee: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching activite terminee: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight + 70),
        itemCount: demandesTerminees.length,
        itemBuilder: (context, index) {
          final demande = demandesTerminees[index];
          if (demande != null) {
            return Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: creme, width: 1),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Container(
                            width: 65,
                            height: 65,
                            decoration: BoxDecoration(
                              color: creme,
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: AssetImage(demande.demandeImage),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 15.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  demande.name,
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  '${demande.orderTime}',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 15.0,
                      child: SizedBox(
                        height: 30,
                        width: 130,
                        child: ElevatedButton(
                          onPressed: () {
                            print(
                                'Navigate to artisan profile for ${demande.artisan.nomArtisan}');
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Text(
                                  '${demande.artisan.nomArtisan}  ${demande.artisan.nomArtisan[0]}.',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: vertFonce,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 4.0),
                              Icon(
                                Icons.star,
                                color: Color.fromARGB(255, 240, 200, 0),
                                size: 16.0,
                              ),
                              SizedBox(width: 3.0),
                              Text(
                                '${demande.artisan.points.toStringAsFixed(1)}',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: vertFonce,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: vertClair,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 15.0,
                              vertical: 5.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Container(); // Return an empty container for null items
          }
        },
      ),
    );
  }
}
