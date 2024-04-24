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

  ActiviteTerminee({required this.demande});
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
        print('Fetched data: $data');

        final List<Demande?> demandes = data.map((item) {
          // Assuming the response structure includes direct keys like 'Prestation' and 'RDV'
          //final item = data[index];
          final demande = item['demande'];
          print('demande: $demande');
          final rdv = item['rdv'];
          print('RDV: $rdv');
          // Assuming there's an 'Artisan' key within the RDV object
          final artisan = item['demande']['Artisans'];
          print('artisan: $artisan');
          final prestation = item['demande']['Prestation'];
          print('prestation: $prestation');
          return Demande(
            name: demande['Prestation']['nomPrestation'] as String,
            orderTime: rdv['DateFin'] + ', ' + rdv['HeureFin'] as String,
            demandeImage: demande['Prestation']['imagePrestation'] as String,
            artisan: Artisan(
              nomArtisan: artisan['NomArtisan'] as String,
              prenomArtisan: artisan['PrenomArtisan'] as String,
              points: (artisan['Note'] as num)
                  .toInt(), // Assuming Points is present
            ),
          );
        }).toList();

        setState(() {
          demandesTerminees = demandes;
        });
      } else {
        print('Failed to fetch demandes terminees: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching demandes terminees: $error');
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
                                '${demande.artisan.points}',
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
  /*Widget build(BuildContext context) {
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
  */
}
