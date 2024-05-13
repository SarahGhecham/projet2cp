import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/constants/constants.dart';
import 'package:flutter_application_proj2cp/pages/artisan/detail_demande_acceptee.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_proj2cp/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class Demande {
  final String name;
  final String orderTime;
  final String demandeImage;
  final bool status;
  final int demandeId;
  final int rdvId;


  Demande({
    required this.name,
    required this.orderTime,
    required this.demandeImage,
    required this.status,
    required this.demandeId,
    required this.rdvId,
  });
}

class DemandesEnCoursArtisan extends StatefulWidget {

  @override
  _DemandesEnCoursArtisanState createState() => _DemandesEnCoursArtisanState();
}

class _DemandesEnCoursArtisanState extends State<DemandesEnCoursArtisan> {
  List<Demande?> demandesEnCours = [];
    late String _token;

  @override
  void initState() {
    super.initState();
    fetchDemandesArtisanEnCours();
  }
  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? '';
    print('Token: $_token');
  }

Future<void> fetchDemandesArtisanEnCours() async {
 try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final response = await http.get(
        Uri.parse(
            'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/artisan/AfficherActiviteEncours'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Demande?> demandes = [];

        for (var item in data) {
          final rdv = item['rdv'];
          final demande = item['demande'];
          final confirme = item['confirme'];
          if (rdv != null && demande != null) {
            final String name = demande['Prestation']['nomPrestation'] ?? '';
            final String dateFin = demande['date'] ?? '';
            final String heureFin = demande['heure'] ?? '';
            final String imagePrestation =
                demande['Prestation']['imagePrestation'] ?? '';
            final bool status = confirme;
            final int demandeId = demande['id'];
            final int rdvId = rdv['id'];
            //print('image $imagePrestation');
            demandes.add(Demande(
            
              name: name,
              orderTime: '$dateFin, $heureFin',
              demandeImage: imagePrestation,
              status: status,
              demandeId: demandeId,
              rdvId: rdvId,
            ));
          }
        }

        setState(() {
          demandesEnCours = demandes;
          print('demandes: $demandesEnCours');
        });
      } else {
        print('Failed to fetch demandes en cours: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching demandes en cours: $error');
    }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight + 70),
        itemCount: demandesEnCours.length,
        itemBuilder: (context, index) {
          final demande = demandesEnCours[index];
          final r = demande?.rdvId ?? 0;
          final d = demande?.demandeId ?? 0;
          String iconAsset = demande?.status ?? false
              ? 'assets/icons/confirmee.png'
              : 'assets/icons/acceptee.png';

          return GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DemandeAcceptee(demandeID: d, rdvID: r,)),
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
                                image: NetworkImage(demande?.demandeImage ?? ''),
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
                                  demande?.name ?? '',
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
                                  demande?.orderTime ?? '',
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
                      right: 16.0,
                      top: 20,
                      child: Image.asset(
                        iconAsset,
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
