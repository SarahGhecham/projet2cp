import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/pages/activite/activite_termine.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_proj2cp/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/widgets.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:flutter_application_proj2cp/demande_confirmé.dart';

class Mademande extends StatefulWidget {
  final int demandeId;
  @override
  const Mademande({Key? key, required this.demandeId});
  @override
  _MademandePageState createState() => _MademandePageState();
}

class _MademandePageState extends State<Mademande> {
  void _navigateToNextPage(int rdvid, int demandeId) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => demande_confirmePage(
            rdvID: rdvId,
            demandeID: demandeId,
          )),
    );
  }

  late String _token;
  List<dynamic> artisans = [];
  bool ecologique = true;
  String description = '';
  String localisation = '';
  String imagePrestation = '';
  String nomPrestation = '';
  String Date = '';
  String Heure = '';
  String dateDebut = '';
  DateTime dateDebut1 = DateTime(0, 0, 0, 0, 0);
  String dureeMax = '';
  String dureeMin = '';
  int rdvId = 0;
  int artisanId = 0;

  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? '';
    print('Token: $_token');
  }

  Future<void> annulerDemande() async {
    // Remplacez 'votre_url_backend/confirmerRDV' par l'URL de votre endpoint backend
    String url =
        'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/client/annulerDemande';
    print(" 1 ${url}");

    // Remplacez 'votre_token_jwt' par votre token JWT
    // Créez les en-têtes de la requête avec le token JWT
    Map<String, String> headers = {
      'Content-Type': 'application/json', // Spécifiez le type de contenu JSON
    };
    Map<String, dynamic> data = {'demandeId': widget.demandeId};

    String jsonData = jsonEncode(data);
    // Envoyez la requête POST avec les en-têtes
    try {
      var response =
      await http.post(Uri.parse(url), headers: headers, body: jsonData);

      // Vérifiez le code de statut de la réponse
      if (response.statusCode == 200) {
        // Réussite de la requête
        print('Requête POST réussie');
      } else {
        // Échec de la requête
        print(
            'Échec de la requête POST avec le code de statut: ${response.statusCode}');
      }
    } catch (error) {
      // Gestion des erreurs
      print('Erreur lors de l\'envoi de la requête POST: $error');
    }
  }

  Future<void> sendPostRequest(int rdvId, int artisanId, String token) async {
    // Remplacez 'votre_url_backend/confirmerRDV' par l'URL de votre endpoint backend
    String url =
        'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/client/confirmerRDV';
    print(" 2 ${url}");

    // Créez les en-têtes de la requête avec le token JWT
    Map<String, String> headers = {
      'Content-Type': 'application/json', // Spécifiez le type de contenu JSON
      'Authorization': 'Bearer $token', // Ajoutez le jeton d'authentification
    };

    // Créez les données à envoyer dans le corps de la requête
    Map<String, dynamic> data = {'rdvId': rdvId, 'artisanId': artisanId};

    String jsonData = jsonEncode(data);

    // Envoyez la requête POST avec les en-têtes et le corps de la requête
    try {
      var response =
      await http.post(Uri.parse(url), headers: headers, body: jsonData);

      // Vérifiez le code de statut de la réponse
      if (response.statusCode == 200) {
        // Réussite de la requête
        print('Requête POST réussie');
      } else {
        // Échec de la requête
        print(
            'Échec de la requête POST avec le code de statut: ${response.statusCode}');
      }
    } catch (error) {
      // Gestion des erreurs
      print('Erreur lors de l\'envoi de la requête POST: $error');
    }
  }

  bool urgente = true;
  var nomArtisan = "Karim Mouloud";
  var note = "4.7";
  var telephone = "0771253705";
  var date = "merc 13 jan";
  var heure = "13h";
  var adresse = "Cite 289 logements Jijel N113";
  var prix = "1000da";
  var prestation = "Peinture de mûrs";
  var duree = "1h-2h";
  @override
  void initState() {
    super.initState();
    fetchData();
    fetchArtisansData();
  }

  late int idrdv;
  late int iddemande;

  Future<void> fetchArtisansData() async {
    int demandeId = widget.demandeId;
    iddemande = demandeId;
    print(demandeId);
    print('Avant la requête HTTP');
    final String apiUrl =
        'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/client/demandes/${demandeId}/artisans';
    print(" 3  ${apiUrl}");
    print('Avant la requête HTTP');
    try {
      final response = await http.get(Uri.parse(apiUrl));
      print('Response data: $response');

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        print('Response data: $responseData');

        setState(() {
          artisans = responseData['artisans'];
          final tarifJourMin = responseData['tarif']['TarifJourMin'].toString();

          final tarifJourMax = responseData['tarif']['TarifJourMax'].toString();
          final Unite = responseData['tarif']['Unité'];
          prix = '${tarifJourMin}-${tarifJourMax}    da/${Unite}';
          print('Response data: $artisans');
          description = responseData['demande']?['description'] ?? 'null';
          urgente = responseData['demande']?['Urgente'];
          localisation = responseData['demande']?['localisation'] ?? 'null';
          imagePrestation =
              responseData['prestation']?['imagePrestation'] ?? 'null';
          nomPrestation = responseData['prestation']?['nomPrestation'];
          rdvId = responseData['rdv']?['id'];
          idrdv = rdvId;
          print('idrdv: $idrdv');
          dateDebut = responseData['rdv']?['dateDebut'];
          dateDebut1 = DateTime.parse(dateDebut);
          Date =
          '${dateDebut1.year}-${dateDebut1.month.toString().padLeft(2, '0')}-${dateDebut1.day.toString().padLeft(2, '0')}';

          Heure =
          '${dateDebut1.hour.toString().padLeft(2, '0')}:${dateDebut1.minute.toString().padLeft(2, '0')}';
          dureeMax = responseData['prestation']?['DureeMax'] as String;
          dureeMin = responseData['prestation']?['DureeMin'] as String;
          duree = '${dureeMin}-${dureeMax}';
        });
      } else {
        throw Exception('Failed to load artisans');
      }
    } catch (error) {
      print('Error fetching artisans: $error');
    }
  }

  void _removeClient(int index) {
    setState(() {
      artisans.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 40),
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
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 220, // Adjust total height as needed
                      width: 315,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD6E3DC),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(width: 10),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: nomPrestation,
                                          style: GoogleFonts.lato(
                                            color: const Color(0xFF05564B),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        if (ecologique) ...[
                                          WidgetSpan(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 6),
                                              child: SvgPicture.asset(
                                                'assets/leaf.svg',
                                                color: const Color(0xff05564B)
                                                    .withOpacity(0.6),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Container(
                                  width: 92,
                                  height: 58,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.grey[200],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: imagePrestation != null
                                        ? Image.network(
                                      imagePrestation, // Utilisez l'URL de la photo de profil
                                      width: 168,
                                      height: 174,
                                      fit: BoxFit.cover,
                                    )
                                        : Image.asset(
                                      'assets/images/l.png',
                                      width: 168,
                                      height: 174,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 00), // Adjust spacing as needed
                            Container(
                              height: 140,
                              width: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(width: 10),
                                        SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: SvgPicture.asset(
                                            "assets/calendar.svg",
                                            color: Color(0xff05564B)
                                                .withOpacity(1),
                                          ),
                                        ),
                                        SizedBox(width: 15),
                                        Text(
                                          Date,
                                          style: GoogleFonts.lato(
                                            fontSize: 13, // Adjusted font size
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          Heure,
                                          style: GoogleFonts.lato(
                                            color: Color(0xFF777777),
                                            fontSize: 13, // Adjusted font size
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        SizedBox(width: 9),
                                        SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: SvgPicture.asset(
                                              "assets/clock.svg"),
                                        ),
                                        SizedBox(width: 15),
                                        Text(
                                          duree,
                                          style: GoogleFonts.lato(
                                            fontSize: 13, // Adjusted font size
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        SizedBox(width: 9),
                                        SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: SvgPicture.asset(
                                              "assets/pin_light.svg"),
                                        ),
                                        SizedBox(width: 14),
                                        Text(
                                          localisation,
                                          style: GoogleFonts.lato(
                                            fontSize: 13, // Adjusted font size
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        SizedBox(width: 9),
                                        SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: SvgPicture.asset(
                                              "assets/money.svg"),
                                        ),
                                        SizedBox(width: 13),
                                        Text(
                                          prix,
                                          style: GoogleFonts.lato(
                                            fontSize: 13, // Adjusted font size
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        SizedBox(width: 10),
                                        SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: SvgPicture.asset(
                                            "assets/urgent.svg",
                                            color: Color(0xff05564B)
                                                .withOpacity(1),
                                          ),
                                        ),
                                        SizedBox(width: 15),
                                        Text(
                                          urgente ? "Urgente" : "Pas urgente",
                                          style: GoogleFonts.lato(
                                            fontSize: 13, // Adjusted font size
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
                            annulerDemande();
                            // Fonction de rappel pour gérer l'action de clic
                            // Mettre ici le code pour annuler la demande
                          },
                          child: Container(
                            height: 16,
                            width: 107,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 224, 70, 56)
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
                      return GestureDetector(
                          onTap: () {
                            // Récupérer l'ID de l'artisan lorsque l'utilisateur clique
                            var selectedArtisanId = artisans[index]['id'];
                            print(
                                'ID de l\'artisan sélectionné : $selectedArtisanId');

                            // Ensuite, vous pouvez utiliser selectedArtisanId dans votre requête
                            // (envoyer une requête HTTP ou effectuer toute autre opération nécessaire)
                          },
                          child: Container(
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
                                      margin:
                                      EdgeInsets.only(left: 10, top: 14),
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
                                                        artisans[index][
                                                        'prenom'] !=
                                                            null)
                                                        ? '${artisans[index]['nom']}   ${artisans[index]['prenom']}'
                                                        : '',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                      FontWeight.w600,
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
                                                        fontWeight:
                                                        FontWeight.w600,
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
                                        var selectedArtisanId =
                                        artisans[index]['id'];
                                        // Ajoutez votre logique onTap ico
                                        sendPostRequest(
                                            rdvId, selectedArtisanId, _token);
                                        _removeClient(index);
                                        _navigateToNextPage(idrdv, widget.demandeId);
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
                          ));
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