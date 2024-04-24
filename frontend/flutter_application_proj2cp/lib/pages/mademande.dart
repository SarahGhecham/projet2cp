import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Mademande extends StatefulWidget {
  @override
  _MademandePageState createState() => _MademandePageState();
}

class _MademandePageState extends State<Mademande> {
  List<dynamic> artisans = [];

  String description = '';
  String localisation = '';
  String imagePrestation = '';
  String Date = '';
  String Heure = '';
  String dateDebut = '';
  DateTime dateDebut1 = DateTime(0, 0, 0, 0, 0);
  @override
  void initState() {
    super.initState();
    fetchArtisansData();
  }

  Future<void> fetchArtisansData() async {
    int demandeId = 36;
    final String apiUrl =
        'http://192.168.100.7:3000/client/demandes/$demandeId/artisans';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        print("ok");

        setState(() {
          artisans = responseData['artisans'];
          description = responseData['demande']?['description'] ?? 'null';
          localisation = responseData['demande']?['localisation'] ?? 'null';
          imagePrestation =
              responseData['prestation']?['imagePrestation'] ?? 'null';
          dateDebut = responseData['rdv']?['dateDebut'];
          dateDebut1 = DateTime.parse(dateDebut);
          Date =
              '${dateDebut1.year}-${dateDebut1.month.toString().padLeft(2, '0')}-${dateDebut1.day.toString().padLeft(2, '0')}';

          Heure =
              '${dateDebut1.hour.toString().padLeft(2, '0')}:${dateDebut1.minute.toString().padLeft(2, '0')}';
        });
      } else {
        throw Exception('Failed to load artisans');
      }
    } catch (error) {
      print('Error fetching artisans: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                SizedBox(width: 81),
                Center(
                  child: Text(
                    'Ma demande',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Lato',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 35.0, top: 15.0),
                        width: 218,
                        height: 59,
                        child: Opacity(
                          opacity: 0.8,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFD6E3DC),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      color: Color(0xff05564B),
                                      size: 16,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "$Date $Heure",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Lato',
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 2),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.place,
                                      color: Color(0xff05564B),
                                      size: 16,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "${localisation ?? 'null'} ",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Lato',
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Container(
                        margin: EdgeInsets.only(top: 15.0),
                        width: 92,
                        height: 58,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: imagePrestation != null
                              ? Image.network(
                                  imagePrestation,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  color: Colors.grey,
                                  child: Icon(
                                    Icons.image,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Description',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          fontFamily: 'Lato',
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.0, left: 35),
                    width: 322,
                    height: 79,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(220, 200, 197, 1).withOpacity(0.22),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Color.fromRGBO(220, 200, 197, 1),
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${description ?? 'null'} ",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Artisans qui ont accepté',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              fontFamily: 'Lato',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 50),
                      GestureDetector(
                          onTap: () {
                            // Fonction de rappel pour gérer l'action de clic
                            // Mettre ici le code pour annuler la demande
                          },
                          child: Container(
                            height: 16,
                            width: 107,
                            decoration: BoxDecoration(
                              color: Color(0xffE52E22)
                                  .withOpacity(0.83), // Couleur de fond rouge
                              borderRadius: BorderRadius.circular(
                                  8), // Bordure arrondie pour le conteneur
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 2),
                                Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "Annuler demande",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Lato',
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ))
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: artisans.length,
                    itemBuilder: (context, index) {
                      bool isFirstItem = index == 0;
                      return Container(
                        height: 77,
                        width: 323,
                        margin: isFirstItem
                            ? EdgeInsets.fromLTRB(30, 00, 30, 10)
                            : EdgeInsets.fromLTRB(30, 10, 30, 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Color(0xFFD6E3DC),
                        ),
                        child: Stack(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10, top: 14),
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(45),
                                    child: artisans.isNotEmpty &&
                                            artisans[index]['photo'] != null
                                        ? Image.network(
                                            artisans[index]['photo'],
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            color: Colors.grey,
                                            child: Icon(
                                              Icons.person,
                                              size: 40,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 13),
                                          child: Row(
                                            children: [
                                              Text(
                                                (artisans[index]['nom'] !=
                                                            null &&
                                                        artisans[index]
                                                                ['prenom'] !=
                                                            null)
                                                    ? '${artisans[index]['nom']}   ${artisans[index]['prenom']}'
                                                    : '',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'Lato',
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                              Icon(Icons.star,
                                                  color: Color(0xffFABB05)),
                                              SizedBox(width: 0.5),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 8),
                                                child: Text(
                                                  '${artisans.isNotEmpty ? artisans[index]['note'] : ''}  ', // Change this to your points field
                                                  style: TextStyle(
                                                    fontSize: 8,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'Lato',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Positioned(
                              bottom: 15,
                              right: 35,
                              child: Container(
                                height: 17,
                                width: 60,
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        10), // Ajoute un espace supplémentaire autour du bouton
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: Colors.green,
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    // Ajoutez votre logique onTap ici
                                  },
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty
                                        .all<EdgeInsets>(EdgeInsets
                                            .zero), // Supprime le remplissage du bouton
                                  ),
                                  child: Text(
                                    'Confirmer',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          8, // Ajustez la taille de la police selon vos besoins
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Lato',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

