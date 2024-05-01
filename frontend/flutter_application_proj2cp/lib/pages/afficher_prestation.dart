// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:flutter_application_proj2cp/details_prestation.dart';
import 'package:flutter_application_proj2cp/config.dart';

class Prestation {
  final int id;
  final String nomPrestation;
  final String materiel;
  final String dureeMax;
  final String dureeMin;
  final int tarifId;
  final int domaineId;
  final bool ecologique;
  final String Description;
  final String imagePrestation;
  final String? tarifJourMin;
  final String? tarifJourMax;
  final String Unite;
  const Prestation({
    required this.id,
    required this.Unite,
    required this.Description,
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
  final int id;
  final String NomDomaine;

  PrestationPage({required this.id,required this.NomDomaine});
  @override
  _PrestationPageState createState() => _PrestationPageState();
}

class _PrestationPageState extends State<PrestationPage> {
  List<Prestation> _prestations = []; // Initialize with empty list
  void afficherId(int id) {
    print('ID: $id');
    // Vous pouvez faire d'autres choses avec l'ID ici
  }

  Future<void> _getPrestations(int domaineId) async {
    try {
      final response = await http.get(
        Uri.parse(

            'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/client/AfficherPrestations/$domaineId'),

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
            id: prestationJson['id'] as int,
            nomPrestation: prestationJson['NomPrestation'] as String,
            materiel: prestationJson['Matériel'] as String,
            Description: prestationJson['Description'] as String,
            dureeMax: prestationJson['DuréeMax'] as String,
            dureeMin: prestationJson['DuréeMin'] as String,
            tarifId: prestationJson['TarifId'] as int,
            domaineId: prestationJson['DomaineId'] as int,
            ecologique: prestationJson['Ecologique'] as bool,
            imagePrestation: prestationJson['imagePrestation'] as String,
            tarifJourMin: prestationJson['Tarif']['TarifJourMin'] as String,
            tarifJourMax: prestationJson['Tarif']['TarifJourMax'] as String,
            Unite: prestationJson['Tarif']['Unité'] as String
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
    print(widget.id);
    _getPrestations(widget.id); // Assuming domaineId is available
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
                        widget.NomDomaine,
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
    return GestureDetector(
      onTap: () {
        print("ID de la prestation: ${_prestations[index].id}");
        Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => details_prestationPage(id: _prestations[index].id,prst: _prestations[index].nomPrestation,avgtime:'${_prestations[index].dureeMin} - ${_prestations[index].dureeMax} ',avgprice:  '${_prestations[index].tarifJourMin.toString()} - ${_prestations[index].tarifJourMin.toString()} da',imagePrestation: _prestations[index].imagePrestation,Description:_prestations[index].Description,Unite :_prestations[index].Unite),
        ),
      );
      },
      child: Container(
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
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '${_prestations[index].tarifJourMin}DA - ${_prestations[index].tarifJourMax}DA',
                    style: TextStyle(
                      fontSize: 12,
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
