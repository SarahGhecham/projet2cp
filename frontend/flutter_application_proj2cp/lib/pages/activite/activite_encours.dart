import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/constants/constants.dart';
import 'package:flutter_application_proj2cp/demande_confirm%C3%A9.dart';
import 'package:flutter_application_proj2cp/pages/mademande.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_proj2cp/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    required this.rdvId

  });
}

class ActiviteEncours {
  final dynamic rdv;
  final dynamic demande;
  final bool status;
  
  ActiviteEncours({
    required this.rdv,
    required this.demande,
    required this.status,
    
  });
}

class DemandesEnCours extends StatefulWidget {
  @override
  _DemandesEnCoursState createState() => _DemandesEnCoursState();
}

class _DemandesEnCoursState extends State<DemandesEnCours> {
  List<Demande?> demandesEnCours = [];
  late String _token;


  @override
  void initState() {
    super.initState();
    fetchDemandesEnCours();
  }

  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? '';
    print('Token: $_token');
  }

  Future<void> fetchDemandesEnCours() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final response = await http.get(
        Uri.parse(
            'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/client/AfficherActiviteEncours'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Demande?> demandes = [];
        ///int rdvId = 0; 
        //int demandeId = 0; 

        for (var item in data) {
          final rdv = item['rdv'];
          final demande = item['demande'];
          final confirme = item['confirme'];
          if (rdv != null && demande != null) {
            final int rdvId = rdv['id'];
            final int demandeId = rdv['DemandeId'];
            final String name = demande['Prestation']['nomPrestation'] ?? '';
            final String dateFin = demande['date'] ?? '';
            final String heureFin = demande['heure'] ?? '';
            final String imagePrestation =
                demande['Prestation']['imagePrestation'] ?? '';
            final bool status = confirme;
            print('image $imagePrestation');
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
          //rdv_id = rdvId;
          //demande_id = demandeId;
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
            onTap: () {
              if (demande?.status ?? false) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => demande_confirmePage(
                     demandeID: d,
                      rdvID: r,
                    ),
                  ),
                );
              } else {
               
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Mademande(
                            demandeId: d,
                          )),
                );
              }
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
                                  demande?.name ??
                                      '', // Utilisation de ?. et ??
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
                                  demande?.orderTime ??
                                      '', // Utilisation de ?. et ??
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
                      right: 16.0, // Ajustez le padding ici
                      top: 20,
                      child: Image.asset(
                        iconAsset,
                        width: 20,
                        height: 20,
                      ), // Ajoutez l'icône ici
                    ),
                  ],
                )              ),
            ),
          );
        },
      ),
    );
  }
}
