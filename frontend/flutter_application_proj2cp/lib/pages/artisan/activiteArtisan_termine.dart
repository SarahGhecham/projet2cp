import 'dart:convert';
import 'dart:ffi';
import 'package:flutter_application_proj2cp/config.dart';
import 'package:flutter_application_proj2cp/pages/artisan/rendez_vous_termine_artisan.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final int demandeId;
  final int rdvId;
  Demande({
    required this.name,
    required this.orderTime,
    required this.demandeImage,
    required this.demandeId,
    required this.rdvId,
  });
}

class ActiviteTerminee {
  final dynamic demande;

  ActiviteTerminee({
    required this.demande,
  });
}

class DemandesTerminesArtisan extends StatefulWidget {
  @override
  _DemandesTerminesArtisanState createState() =>
      _DemandesTerminesArtisanState();
}

class _DemandesTerminesArtisanState extends State<DemandesTerminesArtisan> {
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
            'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/artisan/AfficherActiviteTerminee'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<Demande?> demandes = [];

      for (var item in data) {
        final demande = item; 
        if (demande != null) {
          final String name = demande['Prestation']['nomPrestation'] ?? '';
          final String orderTime =
              demande['RDV']['DateFin'] + ', ' + demande['RDV']['HeureFin'] ?? '';
          final String demandeImage =
              demande['Prestation']['imagePrestation'] ?? '';
          final int demandeId = demande['id'];
          final int rdvId = demande['RDV']['id'];
          demandes.add(Demande(
            name: name,
            orderTime: orderTime,
            demandeImage: demandeImage,
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
                  MaterialPageRoute(builder: (context) => rdvterminee(demandeID: d, rdvID: r,)),
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
