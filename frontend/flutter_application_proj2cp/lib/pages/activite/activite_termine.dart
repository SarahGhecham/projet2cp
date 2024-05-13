import 'dart:convert';
import 'dart:ffi';

import 'package:flutter_application_proj2cp/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_proj2cp/constants/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../rendez-vous_terminée.dart';

class Demande {
  final String name;
  final String orderTime;
  final String demandeImage;
  final Artisan artisan;
  final int demandeId;
  final int rdvId;
  Demande(
      {required this.name,
      required this.orderTime,
      required this.demandeImage,
      required this.artisan,
      required this.demandeId,
      required this.rdvId});
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
  late String _token;

  @override
  void initState() {
    super.initState();
    fetchDemandesTerminees();
  }

  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? '';
    print('Token: $_token');
  }

  Future<void> fetchDemandesTerminees() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final response = await http.get(
        Uri.parse(
            'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/client/AfficherActiviteTerminee'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Demande?> demandes = [];
        print('data: $data');

        for (var item in data) {
          final demande = item['demande'];
          final rdv = item['rdvAffich'];

          if (demande != null && rdv != null) {
            final String name = demande['Prestation']['nomPrestation'] ?? '';

            final String orderTime =
                rdv['DateFin'] + ', ' + rdv['HeureFin'] ?? '';
            final String demandeImage =
                demande['Prestation']['imagePrestation'] ?? '';
            final String nomArtisan =
                demande['Artisans'][0]['NomArtisan'] ?? '';

            final String prenomArtisan =
                demande['Artisans'][0]['PrenomArtisan'] ?? '';
            final String noteAsString = rdv['NoteEvaluation'] ?? '';
            final int points = int.tryParse(noteAsString) ?? 0;
            final int demandeId = demande['id'];
            final int rdvId = rdv['rdvId'];
            demandes.add(Demande(
              name: name,
              orderTime: orderTime,
              demandeImage: demandeImage,
              artisan: Artisan(
                nomArtisan: nomArtisan,
                prenomArtisan: prenomArtisan,
                points: points,
              ),
               demandeId: demandeId,
               rdvId: rdvId,
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
          final r = demande?.rdvId ?? 0;
          final d = demande?.demandeId ?? 0;
          if (demande != null) {
            return GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => rdvclient(
                      demandeID: d,
                      rdvID: r,
                    ),
                  ),
                );
              },
              child: Container(
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
                                  image:
                                      NetworkImage(demande?.demandeImage ?? ''),
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
                                        fontSize: 12,
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
                                        fontSize: 9,
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
                                    '${demande.artisan.nomArtisan}',
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
