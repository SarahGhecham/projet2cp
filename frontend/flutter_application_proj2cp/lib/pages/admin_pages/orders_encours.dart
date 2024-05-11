/*import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/constants/constants.dart';
import 'package:flutter_application_proj2cp/pages/activite/activite_encours.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

/*class ActiviteEnCoursAdmin extends StatefulWidget {
  const ActiviteEnCoursAdmin({super.key});

  @override
  State<ActiviteEnCoursAdmin> createState() => _ActiviteEnCoursAdminState();
}

class _ActiviteEnCoursAdminState extends State<ActiviteEnCoursAdmin> {
  List<Demande?> demandesEnCours = [];
  late String _token;
  @override
  void initState() {
    super.initState();
    fetchAllDemandesEnCours();
  }

  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? '';
    print('Token: $_token');
  }

  Future<void> fetchAllDemandesEnCours() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      print(token);
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/admins/ActiviteEncourspourtout'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print(response.body);
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
          print('image $imagePrestation');
          demandes.add(Demande(
            name: name,
            orderTime: '$dateFin, $heureFin',
            demandeImage: imagePrestation,
            status: status,
          ));
        }
      }

      setState(() {
        demandesEnCours = demandes;
        print('demandes: $demandesEnCours');
      });
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
          String iconAsset = demande?.status ?? false
              ? 'assets/icons/confirmee.png'
              : 'assets/icons/acceptee.png';

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
                                demande?.name ?? '', // Utilisation de ?. et ??
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
              ),
            ),
          );
        },
      ),
    );
  }
}*/*/
