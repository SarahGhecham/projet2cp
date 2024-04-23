import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_proj2cp/constants/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Demande {
  final String name;
  final String orderTime;
  final String demandeImage;
  final bool status;

  Demande(
      {required this.name,
      required this.orderTime,
      required this.demandeImage,
      required this.status});
}

class ActiviteEncours {
  final dynamic rdv;
  final dynamic demande;

  ActiviteEncours({required this.rdv, required this.demande});
}

class DemandesEnCours extends StatefulWidget {
  @override
  _DemandesEnCoursState createState() => _DemandesEnCoursState();
}

class _DemandesEnCoursState extends State<DemandesEnCours> {
  List<Demande?> demandesEnCours = [];

  @override
  void initState() {
    super.initState();
    fetchDemandesEnCours();
  }

  Future<void> fetchDemandesEnCours() async {
    try {
      //final prefs = await SharedPreferences.getInstance();
      //final token = prefs.getString('token') ?? '';
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/client/AfficherActiviteEncours/3'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        //print('Fetched data: $data');
        final List<Demande?> demandes = data.map((item) {
          final rdv = item['rdv'];
          final demande = item['demande'];
         // print('RDV: $rdv');
          //print('Demande: $demande');
          if (rdv['accepte'] && !rdv['annule']) {
            // Filter based on accepte and not annulé
            return Demande(
              name: demande['Prestation']['NomPrestation'] as String,
              orderTime: rdv['DateFin'] + ', ' + rdv['HeureFin'] as String,
              demandeImage: demande['Prestation']['imagePrestation'] as String,
              status: rdv['accepte'] as bool,
            );
          } else {
            return null; // Return null for items that don't meet the criteria
          }
        }).toList();

        setState(() {
          demandesEnCours = demandes;
        });
      } else {
        print('Failed to fetch demandes en cours: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching demandes en cours: $error');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight + 70),
        itemCount: demandesEnCours.length,
        itemBuilder: (context, index) {
          final demande = demandesEnCours[index];
          if (demande != null) {
            // Check if demande is not null
            String iconAsset;
            if (demande.status) {
              // Use status directly as it's already a bool
              iconAsset = 'assets/icons/acceptee.png';
            } else {
              iconAsset = 'assets/icons/confirmee.png';
            }

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
                                image: AssetImage(demande.demandeImage ?? ''),
                                // Use ?. to access demandeImage conditionally
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
                                  demande.name ?? '',
                                  // Provide a default value if name is null
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
                                  demande.orderTime ?? '',
                                  // Provide a default value if orderTime is null
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
                      right: 16.0, // Adjust the padding here
                      top: 20,
                      child: Image.asset(
                        iconAsset,
                        width: 20,
                        height: 20,
                      ), // Add the icon here
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
