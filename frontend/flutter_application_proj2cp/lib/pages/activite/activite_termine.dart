import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_proj2cp/constants/constants.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final double points; // Use double for rating

  Artisan({
    required this.nomArtisan,
    required this.prenomArtisan,
    required this.points,
  });
}

class DemandesTermines extends StatefulWidget {
  @override
  _DemandesTerminesState createState() => _DemandesTerminesState();
}

class _DemandesTerminesState extends State<DemandesTermines> {
  final List<Demande> DemandesTermines = [
    Demande(
      name: 'Testing',
      orderTime: '04/04/2024, 09:00',
      demandeImage: 'assets/images/prestations/penture_murs_plafonds.jpg',
      artisan: Artisan(
        nomArtisan: 'John Doe',
        prenomArtisan: 'Smith',
        points: 4.5,
      ),
    ),
    Demande(
      name: 'Testing',
      orderTime: '04/04/2024, 09:00',
      demandeImage: 'assets/images/prestations/penture_murs_plafonds.jpg',
      artisan: Artisan(
        nomArtisan: 'John Doe',
        prenomArtisan: 'Smith',
        points: 4.5,
      ),
    ),
    Demande(
      name: 'Testing',
      orderTime: '04/04/2024, 09:00',
      demandeImage: 'assets/images/prestations/penture_murs_plafonds.jpg',
      artisan: Artisan(
        nomArtisan: 'John Doe',
        prenomArtisan: 'Smith',
        points: 4.5,
      ),
    ),
    Demande(
      name: 'Testing',
      orderTime: '04/04/2024, 09:00',
      demandeImage: 'assets/images/prestations/penture_murs_plafonds.jpg',
      artisan: Artisan(
        nomArtisan: 'John Doe',
        prenomArtisan: 'Smith',
        points: 4.5,
      ),
    ),
    Demande(
      name: 'Testing',
      orderTime: '04/04/2024, 09:00',
      demandeImage: 'assets/images/prestations/penture_murs_plafonds.jpg',
      artisan: Artisan(
        nomArtisan: 'John Doe',
        prenomArtisan: 'Smith',
        points: 4.5,
      ),
    ),
    Demande(
      name: 'Testing',
      orderTime: '04/04/2024, 09:00',
      demandeImage: 'assets/images/prestations/penture_murs_plafonds.jpg',
      artisan: Artisan(
        nomArtisan: 'John Doe',
        prenomArtisan: 'Smith',
        points: 4.5,
      ),
    ),
    Demande(
      name: 'Testing',
      orderTime: '04/04/2024, 09:00',
      demandeImage: 'assets/images/prestations/penture_murs_plafonds.jpg',
      artisan: Artisan(
        nomArtisan: 'John Doe',
        prenomArtisan: 'Smith',
        points: 4.5,
      ),
    ),
    Demande(
      name: 'Testing',
      orderTime: '04/04/2024, 09:00',
      demandeImage: 'assets/images/prestations/penture_murs_plafonds.jpg',
      artisan: Artisan(
        nomArtisan: 'John Doe',
        prenomArtisan: 'Smith',
        points: 4.5,
      ),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight + 70),
        itemCount: DemandesTermines.length,
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
                                  DemandesTermines[index].demandeImage),
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
                                DemandesTermines[index].name,
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                '${DemandesTermines[index].orderTime}',
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
                    bottom: 0,
                    right: 15.0,
                    child: SizedBox(
                      height: 30,
                      width: 130,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to artisan profile screen (implementation needed)
                          print(
                              'Navigate to artisan profile for ${DemandesTermines[index].artisan.nomArtisan}');
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                                '${DemandesTermines[index].artisan.nomArtisan}',
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: vertFonce,
                                ))),
                            SizedBox(width: 4.0),
                            Icon(
                              Icons.star,
                              color: Color.fromARGB(255, 240, 200, 0),
                              size: 16.0,
                            ),
                            SizedBox(width: 3.0),
                            Text(
                                '${DemandesTermines[index].artisan.points.toStringAsFixed(1)}', // Format rating to one decimal place
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: vertFonce,
                                ))),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: vertClair,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 5.0),
                        ),
                      ),
                    ),
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