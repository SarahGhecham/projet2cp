import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_proj2cp/constants/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class Demande {
  final String name;
  final String orderTime;
  final String demandeImage;

  Demande(
      {required this.name,
      required this.orderTime,
      required this.demandeImage});
}

class DemandesEnCours extends StatefulWidget {
  @override
  _DemandesEnCoursState createState() => _DemandesEnCoursState();
}

class _DemandesEnCoursState extends State<DemandesEnCours> {
  final List<Demande> demandesEnCours = [
    Demande(
        name: 'Peinture de Murs et Plafonds',
        orderTime: '04/04/2024, 09:00',
        demandeImage: 'assets/images/prestations/penture_murs_plafonds.jpg'),
    Demande(
        name: 'Peinture de Murs et Plafonds',
        orderTime: '04/04/2024, 09:00',
        demandeImage: 'assets/images/prestations/penture_murs_plafonds.jpg'),
    Demande(
        name: 'Peinture de Murs et Plafonds',
        orderTime: '04/04/2024, 09:00',
        demandeImage: 'assets/images/prestations/penture_murs_plafonds.jpg'),
    Demande(
        name: 'Peinture de Murs et Plafonds',
        orderTime: '04/04/2024, 09:00',
        demandeImage: 'assets/images/prestations/penture_murs_plafonds.jpg'),
    Demande(
        name: 'Peinture de Murs et Plafonds',
        orderTime: '04/04/2024, 09:00',
        demandeImage: 'assets/images/prestations/penture_murs_plafonds.jpg'),
    Demande(
        name: 'Peinture de Murs et Plafonds',
        orderTime: '04/04/2024, 09:00',
        demandeImage: 'assets/images/prestations/penture_murs_plafonds.jpg'),
    Demande(
        name: 'Peinture de Murs et Plafonds',
        orderTime: '04/04/2024, 09:00',
        demandeImage: 'assets/images/prestations/penture_murs_plafonds.jpg'),
    Demande(
        name: 'Peinture de Murs et Plafonds',
        orderTime: '04/04/2024, 09:00',
        demandeImage: 'assets/images/prestations/penture_murs_plafonds.jpg'),
    Demande(
        name: 'Peinture de Murs et Plafonds',
        orderTime: '04/04/2024, 09:00',
        demandeImage: 'assets/images/prestations/penture_murs_plafonds.jpg'),
    Demande(
        name: 'Peinture de Murs et Plafonds',
        orderTime: '04/04/2024, 09:00',
        demandeImage: 'assets/images/prestations/penture_murs_plafonds.jpg'),
    Demande(
        name: 'Peinture de Murs et Plafonds',
        orderTime: '04/04/2024, 09:00',
        demandeImage: 'assets/images/prestations/penture_murs_plafonds.jpg'),
  ];
  bool _showOngoing = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight + 70),
        itemCount: _showOngoing ? demandesEnCours.length : 0,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
                border: Border(
              top: BorderSide(color: creme, width: 1),
            )),
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
                              image: AssetImage(
                                  demandesEnCours[index].demandeImage),
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
                                demandesEnCours[index].name,
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                '${demandesEnCours[index].orderTime}',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13),
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
                    top: 16,
                    child: Icon(Icons.arrow_forward), // Add the icon here
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
