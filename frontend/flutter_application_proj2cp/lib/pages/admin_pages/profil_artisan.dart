/*import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/config.dart';
import 'dart:io';

import 'package:flutter_application_proj2cp/pages/admin_pages/users_artisans.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VoirProfilArtisan extends StatefulWidget {
  final Artisan artisan;
  const VoirProfilArtisan({Key? key, required this.artisan}) : super(key: key);
  @override
  State<VoirProfilArtisan> createState() => _VoirProfilArtisanState();
}

class _VoirProfilArtisanState extends State<VoirProfilArtisan> {
  late String _token;
  Map<String, dynamic> _userData = {};
  late Artisan _artisan;
  bool _isSuspended = false;
  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? '';
    print('Token: $_token');
    await Future.wait([_fetchUserData()]);
    _loadSuspensionStatus();
  }

  void initState() {
    super.initState();
    _artisan = widget.artisan;
    fetchData();
  }

  Future<void> _fetchUserData() async {
    final url = Uri.parse(
        'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/artisan/Affichermonprofil');

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      });
      if (response.statusCode == 200) {
        final userDataJson = json.decode(response.body);

        setState(() {
          _userData = {
            'PrenomArtisan': userDataJson['PrenomArtisan'] as String,
            'NomArtisan': userDataJson['NomArtisan'] as String,
            'EmailArtisan': userDataJson['EmailArtisan'] as String,
            'NumeroTelArtisan': userDataJson['NumeroTelArtisan'] as String,
            'AdresseArtisan': userDataJson['AdresseArtisan'] as String,
            'DomaineId': userDataJson['DomaineId'],
            'RayonKm': userDataJson['RayonKm'],
            'photo': userDataJson['photo'],
            'Note': userDataJson['Note'],
            'Disponibilite': userDataJson['Disponibilite'],
            'ArtisanPrestations': userDataJson['ArtisanPrestations'],
          };
          _artisan = Artisan(
            nom: _userData['NomArtisan'],
            prenom: _userData['PrenomArtisan'],
            email: _userData['EmailArtisan'],
            numTel: _userData['NumeroTelArtisan'],
            adresse: _userData['AdresseArtisan'],
            rayon: _userData['RayonKm'],
            domaine: _userData['DomaineId'],
            disponibilite: _userData['Disponibilite'],
            note: _userData['Note'],
            image: _userData['photo'],
          );
        });
        print(_userData);
      } else {
        print('Failed to fetch user data');
        print('Response Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  Future<void> suspendAccount() async {
    print(_artisan.email);

    final url = Uri.parse(
        'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/admins/Desactiver/Artisan');
    try {
      final response = await http.patch(
        // Use http.patch for a PATCH request
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'EmailArtisan': _artisan.email}),
      );

      if (response.statusCode == 200) {
        print('Artisan deactivated successfully');
        setState(() {
          _isSuspended = true;
        });
        _saveSuspensionStatus();

        //Navigator.pop(context);
      } else {
        print('Failed to deactivate client');
        print('Response Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        // Handle error scenario appropriately
      }
    } catch (error) {
      print('Error deactivating client: $error');
      // Handle error scenario appropriately
    }
  }

  void _loadSuspensionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isSuspended = prefs.getBool('isSuspended${_artisan.email}') ?? false;
    });
  }

  void _saveSuspensionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isSuspended${_artisan.email}', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile de l'artisan",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.grey[200],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: _userData['photo'] != null
                        ? Image.network(
                            _userData['photo']
                                .toString(), // Utilisez l'URL de la photo de profil
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/artisan.jpg',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Note",
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF05564B)),
                  ),
                  Row(
                    children: [
                      SvgPicture.asset("assets/star.svg"),
                      Text(
                        _artisan.note.toString(),
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF05564B)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Disponibilité",
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF05564B)),
                  ),
                  Container(
                    height: 30,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFF7F3F2),
                      border: Border.all(color: Color(0xFF05564B)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _artisan.disponibilite
                                ? Color(0xFF15AC3F)
                                : Colors.red,
                          ),
                        ),
                        Text(
                          _artisan.disponibilite ? "Disponible" : "hors",
                          style: GoogleFonts.poppins(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Domaine",
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF05564B)),
                  ),
                  Container(
                    height: 30,
                    width: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFF7F3F2),
                      border: Border.all(color: Color(0xFF05564B)),
                    ),
                    child: Center(
                      child: Text(
                        _artisan.domaine.toString(),
                        style: GoogleFonts.poppins(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Color(0xFFD6E3DC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        content: Container(
                          width: 200.0, // Adjust the width as needed
                          height: 150.0, // Adjust the height as needed
                          child: Center(
                            child: ListView.builder(
                              itemCount: _userData['ArtisanPrestations'].length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                    _userData['ArtisanPrestations'][index],
                                    style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  // You can add more customization here if needed
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    });
              },
              style: ButtonStyle(
                minimumSize:
                    MaterialStateProperty.all<Size>(const Size(315, 30)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xFFFF8787)),
              ),
              child: Text(
                "Préstations proposées",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Informations personnelles",
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF05564B)),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Nom",
                  style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 400,
                  height: 41,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCC8C5).withOpacity(0.22),
                    border: Border.all(
                      color: const Color(0xFFDCC8C5),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16.0),
                    child: Text(
                      _artisan.nom.toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Prénom",
                  style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 400,
                  height: 41,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCC8C5).withOpacity(0.22),
                    border: Border.all(
                      color: const Color(0xFFDCC8C5),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16),
                    child: Text(
                      _artisan.prenom.toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Numéro de téléphone",
                  style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 400,
                  height: 41,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCC8C5).withOpacity(0.22),
                    border: Border.all(
                      color: const Color(0xFFDCC8C5),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16),
                    child: Text(
                      _artisan.numTel.toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Email",
                  style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 400,
                  height: 41,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCC8C5).withOpacity(0.22),
                    border: Border.all(
                      color: const Color(0xFFDCC8C5),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16),
                    child: Text(
                      _artisan.email.toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Adresse",
                  style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 400,
                  height: 41,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCC8C5).withOpacity(0.22),
                    border: Border.all(
                      color: const Color(0xFFDCC8C5),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16),
                    child: Text(
                      _artisan.adresse.toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Rayon géographique",
                  style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 400,
                  height: 41,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCC8C5).withOpacity(0.22),
                    border: Border.all(
                      color: const Color(0xFFDCC8C5),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16),
                    child: Text(
                      _artisan.rayon.toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _isSuspended
                      ? Padding(
                          padding: const EdgeInsets.only(
                            top: 72.0,
                          ),
                          child: SizedBox(
                            width: 120,
                            height: 33,
                            child: Text(
                              '     Suspendu',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontFamily: "poppins",
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 72.0),
                          child: SizedBox(
                            width: 120,
                            height: 33,
                            child: ElevatedButton(
                              onPressed: suspendAccount,
                              child: Text(
                                'Suspendre',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: "poppins",
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(color: Colors.red),
                                  ),
                                ),
                                elevation: MaterialStateProperty.all<double>(0),
                                padding: MaterialStateProperty.all<
                                    EdgeInsetsGeometry>(
                                  EdgeInsets.symmetric(
                                      vertical: 1.0, horizontal: 2.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_proj2cp/config.dart';
import 'package:flutter_application_proj2cp/pages/commentaire_client.dart';
import 'package:flutter_application_proj2cp/parametre.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:table_calendar/table_calendar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VoirProfilArtisan extends StatefulWidget {
  final int artisanID;
  @override
  const VoirProfilArtisan({
    Key? key,
    required this.artisanID,
  }) : super(key: key);

  @override
  _VoirProfilArtisanState createState() => _VoirProfilArtisanState();
}

class _VoirProfilArtisanState extends State<VoirProfilArtisan> {
  @override
  var note = "";
  var domaine = "";
  late int artisanID;
  final jourController = TextEditingController();

  late String _token;
  bool _isSuspended = false;
  Map<String, dynamic> _userData = {};
  bool dispo = true;
  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('isSuspended${_userData['EmailArtisan']}');
    _token = prefs.getString('token') ?? '';
    print('Token: $_token');
    await Future.wait([_fetchUserData()]);
  }

  void initState() {
    super.initState();
    _loadSuspensionStatus();

    fetchData();
  }

  Future<void> _fetchUserData() async {
    final url = Uri.parse(
        'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/client/AfficherArtisan/${widget.artisanID}'); // Replace with your endpoint
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $_token'},
      );
      print("ufhquwefhuweghwuegwug");
      if (response.statusCode == 200) {
        final userDataJson = json.decode(response.body);
        print("llllllllllllllllllllllllllllllll");

        if (userDataJson != null) {
          print("ppppppppppppppppppppp");

          setState(() {
            print("kikkkkkkkkkkkkkkkkkkkkkkkkkkk");

            _userData = {
              'Nom': userDataJson['NomArtisan'] as String ?? '',
              'Prenom': userDataJson['PrenomArtisan'] as String ?? '',
              'Email': userDataJson['EmailArtisan'] as String ?? '',
              'Numero': userDataJson['NumeroTelArtisan'] as String ?? '',
              'Rayon': userDataJson['RayonKm'] ?? '',
              'Adresse': userDataJson['AdresseArtisan'] ?? '',
              'photo': userDataJson['photo'] ?? '',
              'Disponibilite': userDataJson['Disponibilite']
                  as bool, // Assuming 'Disponibilite' is not a string
              'Note': userDataJson['Note'] ?? '',
              'Domaine': userDataJson['Domaine'] as String ??
                  '', // Assuming 'Domaine' is a string
              'Prestations': userDataJson['Prestations'] as List<dynamic> ?? [],
            };
            print("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
            _dispo(_userData['Disponibilite']);
          });
          print('_userData: $_userData'); // Debugging print
        } else {
          print('userDataJson is null');
        }
      } else {
        print('Failed to fetch user data');
        print('Response Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  Future<void> suspendAccount() async {
    print(_userData['EmailArtisan']);

    final url = Uri.parse(
        'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/admins/Desactiver/Artisan');
    try {
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'EmailArtisan': _userData['EmailArtisan']}),
      );

      if (response.statusCode == 200) {
        print('Artisan deactivated successfully');
        setState(() {
          _isSuspended = true;
        });
        _saveSuspensionStatus();

        //Navigator.pop(context);
      } else {
        print('Failed to deactivate client');
        print('Response Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        // Handle error scenario appropriately
      }
    } catch (error) {
      print('Error deactivating client: $error');
      // Handle error scenario appropriately
    }
  }

  void _loadSuspensionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isSuspended =
          prefs.getBool('isSuspended${_userData['EmailArtisan']}') ?? false;
    });
  }

  void _saveSuspensionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isSuspended${_userData['EmailArtisan']}', true);
  }

  void _dispo(bool value) {
    setState(() {
      dispo = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.grey[200],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: _userData['photo'] != null
                        ? Image.network(
                            _userData['photo']
                                .toString(), // Utilisez l'URL de la photo de profil
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/artisan.jpg',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Note",
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF05564B)),
                  ),
                  Row(
                    children: [
                      SvgPicture.asset("assets/star.svg"),
                      Text(
                        _userData['Note'].toString(),
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF05564B)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Disponibilité",
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF05564B)),
                  ),
                  Container(
                    height: 30,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFF7F3F2),
                      border: Border.all(color: Color(0xFF05564B)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: dispo ? Color(0xFF15AC3F) : Colors.red,
                          ),
                        ),
                        Text(
                          dispo ? "Disponible" : "hors",
                          style: GoogleFonts.poppins(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Domaine",
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF05564B)),
                  ),
                  Container(
                    height: 30,
                    width: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFF7F3F2),
                      border: Border.all(color: Color(0xFF05564B)),
                    ),
                    child: Center(
                      child: Text(
                        _userData['Domaine'].toString(),
                        style: GoogleFonts.poppins(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Color(0xFFD6E3DC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        content: Container(
                          width: 200.0, // Adjust the width as needed
                          height: 150.0, // Adjust the height as needed
                          child: Center(
                            child: ListView.builder(
                              itemCount: _userData['Prestations'].length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                    _userData['Prestations'][index],
                                    style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  // You can add more customization here if needed
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    });
              },
              style: ButtonStyle(
                minimumSize:
                    MaterialStateProperty.all<Size>(const Size(315, 30)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xFFFF8787)),
              ),
              child: Text(
                "Préstations proposées",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Informations personnelles",
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF05564B)),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Nom",
                  style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 400,
                  height: 41,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCC8C5).withOpacity(0.22),
                    border: Border.all(
                      color: const Color(0xFFDCC8C5),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16.0),
                    child: Text(
                      _userData['Nom'].toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Prénom",
                  style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 400,
                  height: 41,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCC8C5).withOpacity(0.22),
                    border: Border.all(
                      color: const Color(0xFFDCC8C5),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16),
                    child: Text(
                      _userData['Prenom'].toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Numéro de téléphone",
                  style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 400,
                  height: 41,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCC8C5).withOpacity(0.22),
                    border: Border.all(
                      color: const Color(0xFFDCC8C5),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16),
                    child: Text(
                      _userData['Numero'].toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Email",
                  style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 400,
                  height: 41,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCC8C5).withOpacity(0.22),
                    border: Border.all(
                      color: const Color(0xFFDCC8C5),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16),
                    child: Text(
                      _userData['Email'].toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Adresse",
                  style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 400,
                  height: 41,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCC8C5).withOpacity(0.22),
                    border: Border.all(
                      color: const Color(0xFFDCC8C5),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16),
                    child: Text(
                      _userData['Adresse'].toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Rayon géographique",
                  style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 400,
                  height: 41,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCC8C5).withOpacity(0.22),
                    border: Border.all(
                      color: const Color(0xFFDCC8C5),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16),
                    child: Text(
                      _userData['Rayon'].toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CommentPage2(
                                    ArtisanId: widget.artisanID,
                                  )),
                        );
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(
                            const Size(150, 35)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFF05564B)),
                      ),
                      child: Text(
                        "Commentaires",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _isSuspended
                      ? Padding(
                          padding: const EdgeInsets.only(
                            top: 72.0,
                          ),
                          child: SizedBox(
                            width: 120,
                            height: 33,
                            child: Text(
                              '     Suspendu',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontFamily: "poppins",
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 72.0),
                          child: SizedBox(
                            width: 120,
                            height: 33,
                            child: ElevatedButton(
                              onPressed: suspendAccount,
                              child: Text(
                                'Suspendre',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: "poppins",
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(color: Colors.red),
                                  ),
                                ),
                                elevation: MaterialStateProperty.all<double>(0),
                                padding: MaterialStateProperty.all<
                                    EdgeInsetsGeometry>(
                                  EdgeInsets.symmetric(
                                      vertical: 1.0, horizontal: 2.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
            SizedBox(
              height: 60,
            )
          ],
        ),
      ),
    );
  }
}
