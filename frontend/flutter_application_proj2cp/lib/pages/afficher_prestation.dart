// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class Prestation {
  final String nomPrestation;
  final String materiel;
  final String dureeMax;
  final String dureeMin;
  final int tarifId;
  final int domaineId;
  final bool ecologique;
  final String imagePrestation;
  final double? tarifJourMin;
  final double? tarifJourMax;
  const Prestation({
    required this.nomPrestation,
    required this.materiel,
    required this.dureeMax,
    required this.dureeMin,
    required this.tarifId,
    required this.domaineId,
    required this.ecologique,
    required this.imagePrestation,
    required this.tarifJourMin,
    required this.tarifJourMax,
  });
}

class PrestationPage extends StatefulWidget {
  @override
  _PrestationPageState createState() => _PrestationPageState();
}

class _PrestationPageState extends State<PrestationPage> {
  List<Prestation> _prestations = []; // Initialize with empty list

  Future<void> _getPrestations(int domaineId) async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.151.173:3000/client/AfficherPrestations/$domaineId'),
      );

      if (response.statusCode == 200) {
        final prestationsJson = jsonDecode(response.body) as List;

        final prestations = prestationsJson.map((prestationJson) {
          // Default value if parsing fails
          final tarifJourMin = double.tryParse(
              prestationJson['Tarif']['TarifJourMin'].toString());
          final tarifJourMax = double.tryParse(
              prestationJson['Tarif']['TarifJourMax'].toString());

          return Prestation(
            nomPrestation: prestationJson['NomPrestation'] as String,
            materiel: prestationJson['Matériel'] as String,
            dureeMax: prestationJson['DuréeMax'] as String,
            dureeMin: prestationJson['DuréeMin'] as String,
            tarifId: prestationJson['TarifId'] as int,
            domaineId: prestationJson['DomaineId'] as int,
            ecologique: prestationJson['Ecologique'] as bool,
            imagePrestation: prestationJson['imagePrestation'] as String,
            tarifJourMin: tarifJourMin,
            tarifJourMax: tarifJourMax,
          );
        }).toList();

        setState(() {
          _prestations = prestations; // Update the list in state
        });
      } else {
        throw Exception(
            'Failed to fetch prestations (Status code: ${response.statusCode})');
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    _getPrestations(1); // Assuming domaineId is available
  }

  /* [
    Prestation(
      name: 'Prestation 1',
      description: 'Description de la prestation 1',
      imageUrl:
          'https://media.istockphoto.com/id/134248179/fr/photo/construction-travaillant-putting-pl%C3%A2tre-sur-un-mur.jpg?s=612x612&w=0&k=20&c=dNwrcFueXuo1O_9k24gClYJ9erbB2D6MglFkWzX1AcM=',
      price: 50.0,
      duration: Duration(minutes: 30),
    ),
    Prestation(
      name: 'Prestation 2',
      description: 'Description de la prestation 2',
      imageUrl: 'https://via.placeholder.com/150',
      price: 70.0,
      duration: Duration(minutes: 45),
    ),
    Prestation(
      name: 'Prestation 3',
      description: 'Description de la prestation 3',
      imageUrl: 'https://via.placeholder.com/150',
      price: 90.0,
      duration: Duration(hours: 1),
    ),
  ];*/

  @override
  Widget build(BuildContext context) {
    // Données fictives pour les prestations

    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 70),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 65),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 49,
                    width: 169,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      color: Color(0xFFDCC8C5),
                    ),
                    child: Center(
                      child: Text(
                        'Peinture',
                        style: TextStyle(
                          color: Color(0xff05564B),
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Lato',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _prestations.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 95,
                  width: 335,
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color(0xFFD6E3DC),
                  ),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        width: 80,
                        height: 74,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            _prestations[index].imagePrestation,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _prestations[index].nomPrestation,
                              style: TextStyle(
                                color: Color(0xff05564B),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '${_prestations[index].tarifJourMin}DA - ${_prestations[index].tarifJourMax}DA',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '${_prestations[index].dureeMin} ~ ${_prestations[index].dureeMax} ',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
