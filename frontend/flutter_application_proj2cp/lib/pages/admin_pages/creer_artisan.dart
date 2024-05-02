import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/constants/constants.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/drawer_services.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/drawer_users.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Prestation {
  final int id;
  final String nomPrestation;

  Prestation({
    required this.id,
    required this.nomPrestation,
  });

  factory Prestation.fromJson(Map<String, dynamic> json) {
    return Prestation(
      id: json['id'],
      nomPrestation: json['NomPrestation'],
    );
  }
}

class CreerArtisan extends StatefulWidget {
  const CreerArtisan({super.key});

  @override
  State<CreerArtisan> createState() => _CreerArtisanState();
}

class _CreerArtisanState extends State<CreerArtisan> {
  final _nomArtisanController = TextEditingController();
  final _prenomArtisanController = TextEditingController();
  final _passwordArtisanController = TextEditingController();

  final _emailArtisanController = TextEditingController();
  final _numTelArtisanController = TextEditingController();
  final _localisationController = TextEditingController();
  List<Map<String, dynamic>> _domainesOptions = [];
  List<Prestation> _prestationsOptions = [];
  List<Prestation> _prestationsChoisis = [];

  String? _selectedDomaine;
  int? _selectedDomaineId;
  Prestation? _selectedPrestation;
  late String _token;
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? '';
    print('Token: $_token');
    await Future.wait([
      fetchDomaines(),
    ]);
  }

  Future<void> _createArtisan() async {
    final nom = _nomArtisanController.text;
    final prenom = _prenomArtisanController.text;
    final email = _emailArtisanController.text;
    final adresse = _localisationController.text;
    final telephone = _numTelArtisanController.text;
    final motDePaase = _passwordArtisanController.text;
    final domaineId = _selectedDomaineId;
    final prestationsIds =
        _prestationsChoisis.map((prestation) => prestation.id).toList();
    print(prestationsIds);
    if (prestationsIds.isEmpty) {
      print('Error: prestationsIds list is empty');
      return;
    }

    final url = Uri.parse('http://10.0.2.2:3000/admins/creerartisan');

    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          'NomArtisan': nom,
          'PrenomArtisan': prenom,
          'MotdepasseArtisan': motDePaase,
          'EmailArtisan': email,
          'AdresseArtisan': adresse,
          'NumeroTelArtisan': telephone,
          'DomaineId': domaineId,
          'prestationsIds': prestationsIds,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        var responseData = json.decode(response.body);
        // Handle successful creation (optional)
        print('Artisan created successfully');
      } else if (response.statusCode == 400) {
        var responseData = json.decode(response.body);
        var errorMessage = responseData['message'];
        // Handle specific error cases (e.g., invalid address)
        print('Failed to create artisan: $errorMessage');
      } else {
        print('Failed to create artisan. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error creating artisan: $error');
    }
  }

  Future<void> fetchDomaines() async {
    final url = Uri.parse('http://10.0.2.2:3000/pageaccueil/AfficherDomaines');
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        print("Fetching domaines successful");
        // Decode JSON response
        List<dynamic> data = jsonDecode(response.body);

        setState(() {
          // Extract NomDomaine and DomaineId values from the fetched data
          _domainesOptions = data.map<Map<String, dynamic>>((domaine) {
            return {
              'NomDomaine': domaine['NomDomaine'] as String,
              'DomaineId': domaine['id'], // Use dynamic type for DomaineId
            };
          }).toList();
        });
      } else {
        // Handle HTTP error
        print('Failed to load domaines: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network or decoding errors
      print('Error fetching domaines: $error');
    }
  }

  Future<void> fetchPrestationsByDomaine(int domaineId) async {
    final url = Uri.parse(
        'http://10.0.2.2:3000/admins/AfficherPrestationsByDomaine/$domaineId');
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        print("Fetching prestations for domaine $domaineId successful");
        List<dynamic> data = jsonDecode(response.body);

        setState(() {
          _prestationsOptions = data.map<Prestation>((prestation) {
            return Prestation.fromJson(prestation);
          }).toList();
        });
      } else {
        // Handle HTTP error
        print(
            'Failed to load prestations for domaine $domaineId: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network or decoding errors
      print('Error fetching prestations for domaine $domaineId: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DrawerUsers(),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 20),
              child: Text(
                'Ajouter un artisan',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 140,
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCC8C5).withOpacity(0.22),
                      border: Border.all(
                        color: const Color(0xFFDCC8C5),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: _nomArtisanController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        hintText: "Nom",
                        hintStyle: TextStyle(
                          fontFamily: "Poppins",
                          color: Color(0xFF777777),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 11.0,
                          horizontal: 10.0,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(width: 27),
                  Container(
                    width: 140,
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCC8C5).withOpacity(0.22),
                      border: Border.all(
                        color: const Color(0xFFDCC8C5),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: _prenomArtisanController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        hintText: "Prénom",
                        hintStyle: TextStyle(
                          fontFamily: "Poppins",
                          color: Color(0xFF777777),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 11.0,
                          horizontal: 10.0,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Container(
                width: 310,
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0xFFDCC8C5).withOpacity(0.22),
                  border: Border.all(
                    color: const Color(0xFFDCC8C5),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: _emailArtisanController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: "E-mail",
                    hintStyle: TextStyle(
                      fontFamily: "Poppins",
                      color: Color(0xFF777777),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 11.0,
                      horizontal: 10.0,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Container(
                width: 310,
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0xFFDCC8C5).withOpacity(0.22),
                  border: Border.all(
                    color: const Color(0xFFDCC8C5),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: _numTelArtisanController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: "Numéro de telephpne",
                    hintStyle: TextStyle(
                      fontFamily: "Poppins",
                      color: Color(0xFF777777),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 11.0,
                      horizontal: 10.0,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Container(
                width: 310,
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0xFFDCC8C5).withOpacity(0.22),
                  border: Border.all(
                    color: const Color(0xFFDCC8C5),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: _localisationController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: "Localisation",
                    hintStyle: TextStyle(
                      fontFamily: "Poppins",
                      color: Color(0xFF777777),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 11.0,
                      horizontal: 10.0,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Container(
                width: 310,
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0xFFDCC8C5).withOpacity(0.22),
                  border: Border.all(
                    color: const Color(0xFFDCC8C5),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: _passwordArtisanController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: "Mot de passe",
                    hintStyle: TextStyle(
                      fontFamily: "Poppins",
                      color: Color(0xFF777777),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 11.0,
                      horizontal: 10.0,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  height: 45,
                  width: 310,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCC8C5).withOpacity(0.22),
                    border: Border.all(
                      color: const Color(0xFFDCC8C5),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: Container(
                      padding: EdgeInsets.only(left: 10),
                      child: DropdownButton<Map<String, dynamic>>(
                        value: _selectedDomaineId != null
                            ? _domainesOptions.firstWhere((domaine) =>
                                domaine['DomaineId'] == _selectedDomaineId)
                            : null,
                        hint: Text(
                          "Domaine d'expertise", // Your hint text here
                          style: TextStyle(
                            color: Color(0xFF777777),
                          ),
                        ),
                        items: _domainesOptions.map((domaine) {
                          return DropdownMenuItem<Map<String, dynamic>>(
                            value: domaine,
                            child: Text(domaine['NomDomaine'] as String),
                          );
                        }).toList(),
                        onChanged: (selectedDomaine) {
                          setState(() {
                            _selectedDomaine =
                                selectedDomaine!['NomDomaine'] as String;
                            _selectedDomaineId =
                                selectedDomaine['DomaineId'] as int;
                            _prestationsOptions =
                                []; // Clear prestations options when selecting a new domaine
                          });
                          fetchPrestationsByDomaine(
                              _selectedDomaineId!); // Fetch prestations for selected domaine
                        },
                        icon: const Icon(Icons.arrow_drop_down),
                      ),
                    ),
                  ),
                )),
            Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  height: 45,
                  //width: 310,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCC8C5).withOpacity(0.22),
                    border: Border.all(
                      color: const Color(0xFFDCC8C5),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: Container(
                      padding: EdgeInsets.only(left: 10),
                      //width: double.infinity,
                      child: DropdownButton<String>(
                        value: _selectedPrestation?.nomPrestation,
                        hint: Text(
                          "Types des prestations", // Your hint text here
                          style: TextStyle(
                            color: Color(0xFF777777),
                          ),
                        ),
                        // value: _selectedDomaine,

                        items: _prestationsOptions.map((prestation) {
                          return DropdownMenuItem<String>(
                            value: prestation.nomPrestation,
                            child: Text(prestation.nomPrestation),
                          );
                        }).toList(),
                        onChanged: (selectedPrestation) {
                          setState(() {
                            _selectedPrestation =
                                _prestationsOptions.firstWhere(
                              (prestation) =>
                                  prestation.nomPrestation ==
                                  selectedPrestation,
                              orElse: () => Prestation(
                                  id: -1,
                                  nomPrestation:
                                      ''), // Provide a default Prestation or handle appropriately
                            );
                            if (_selectedPrestation != null &&
                                !_prestationsChoisis
                                    .contains(_selectedPrestation!)) {
                              _prestationsChoisis.add(_selectedPrestation!);
                            }
                          });
                        },
                        icon: const Icon(Icons.arrow_drop_down),
                      ),
                    ),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Container(
                height: 120,
                width: 300, // Adjust the height as needed
                child: ListView.builder(
                  itemCount: _prestationsChoisis.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 30, right: 30),
                      child: SizedBox(
                        width: 240,
                        height: 45,
                        child: Container(
                          child: Chip(
                            label: Text(
                              _prestationsChoisis[index].nomPrestation,
                              style: GoogleFonts.poppins(
                                color: kBlack,
                                fontSize: 16,
                              ),
                            ),
                            onDeleted: () {
                              setState(() {
                                _prestationsChoisis.removeAt(index);
                              });
                            },
                            backgroundColor:
                                const Color(0xFFDCC8C5).withOpacity(0.22),
                            deleteIconColor: crevette,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10, left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Handle 'Annuler' button press
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      decoration: BoxDecoration(
                        color: crevette,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Annuler',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: "poppins",
                            color: Colors.white),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _createArtisan();
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      decoration: BoxDecoration(
                        color: vertFonce,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Terminer',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: "poppins"),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
