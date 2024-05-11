import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/config.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileAdmin extends StatefulWidget {
  @override
  _ProfileAdminState createState() => _ProfileAdminState();
}

class _ProfileAdminState extends State<ProfileAdmin> {
  ScrollController? _scrollController;

  late String _token;
  Map<String, dynamic> _userData = {};
  bool _isEditing = false;
  @override // Déclaration de _token en dehors des méthodes

  @override
  void initState() {
    super.initState();
    _isEditing = false;
    _scrollController = ScrollController();
    bool _showSuggestions = false;
    fetchData();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? '';
    print('Token: $_token');
    await Future.wait([_fetchUserData()]);
  }

  Future<void> _fetchUserData() async {
    final url = Uri.parse(
        'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/admins/1'); // Replace with your endpoint
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final userDataJson = json.decode(response.body);

        setState(() {
          _userData = {
            'NomAdmin': userDataJson['NomAdmin'] as String,
            'PrenomAdmin': userDataJson['PrenomAdmin'] as String,
            'EmailAdmin': userDataJson['EmailAdmin'] as String?,
          };
        });
        print('_userData: $_userData'); // Debugging print
      } else {
        print('Failed to fetch user data');
        print('Response Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  List<dynamic> _predictions = [];
  bool _showSuggestions = true;
  bool _suggestionSelected = false;
  String _addressErrorText = '';
  @override
  void _searchPlaces(String input) async {
    const apiKey = 'AIzaSyD_d366EANPIHugZe9YF5QVxHHa_Bzef_4';
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=(cities)&key=$apiKey&language=fr';

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    setState(() {
      _predictions = data['predictions'];
    });
  }

  Future<void> updateClient(Map<String, dynamic> updatedData) async {
    final url = Uri.parse(
        'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/client/updateClient'); // Replace with your endpoint
    try {
      final response = await http.patch(
        url,
        body: json.encode(updatedData),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token'
        },
      );

      if (response.statusCode == 200) {
        print('User data updated successfully');
        _fetchUserData();
      } else {
        print('Failed to update user data');
        print('Response Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
    } catch (error) {
      print('Error updating user data: $error');
    }
  }

  TextEditingController _nomController = TextEditingController();
  TextEditingController _prenomController = TextEditingController();
  TextEditingController _gmailController = TextEditingController();

  void _toggleEditing(bool value) {
    setState(() {
      _isEditing = value;
    });
  }

  void _saveChanges() {
    _userData['NomAdmin'] = _nomController.text.isNotEmpty
        ? _nomController.text
        : _userData['NomAdmin'];
    _userData['PrenomAdmin'] = _prenomController.text.isNotEmpty
        ? _prenomController.text
        : _userData['PrenomAdmin'];

    _userData['EmailAdlin'] = _gmailController.text.isNotEmpty
        ? _gmailController.text
        : _userData['EmailAdmin'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600, // Semibold
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: SizedBox(
              width: 32,
              height: 32,
              child: Image.asset('assets/images/settings.png'),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 390,
                  height: 272,
                  decoration: BoxDecoration(
                    color: Color(0xFFDCC8C5).withOpacity(0.26),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                  ),
                ),
                FractionalTranslation(
                  translation: const Offset(
                    0,
                    0.78,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 168,
                      height: 174,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.asset(
                              'assets/images/l.png',
                              width: 168,
                              height: 174,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 72.0),
                  child: SizedBox(
                    width: 98,
                    height: 33,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_isEditing && _suggestionSelected) {
                          _saveChanges();
                          updateClient(_userData);
                          _toggleEditing(false);
                        } else if (_isEditing && !_suggestionSelected) {
                          setState(() {
                            _addressErrorText =
                                'Veuillez choisir un emplacement de la liste ';
                          });
                        } else {
                          _toggleEditing(true);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        backgroundColor: const Color(0xFFFF8787),
                      ),
                      child: Text(
                        _isEditing ? 'Valider' : 'Editer',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 14,
                          fontFamily: 'Lato',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 116,
                      height: 41,
                      decoration: BoxDecoration(
                        color: Color(0xFFDCC8C5).withOpacity(0.22),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Color(0xFFDCC8C5),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: _isEditing
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: TextFormField(
                                  controller: _nomController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Entrer name',
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                  style: TextStyle(
                                    color: _userData['NomAdmin'] != null &&
                                            _userData['NomAdmin'].isNotEmpty
                                        ? Colors.black
                                        : Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : Text(
                                _userData['NomAdmin'] != null &&
                                        _userData['NomAdmin'].isNotEmpty
                                    ? _userData['NomAdmin']
                                    : ' Nom',
                                style: TextStyle(
                                  color: _userData['NomAdmin'] != null &&
                                          _userData['NomAdmin'].isNotEmpty
                                      ? Colors.black
                                      : Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(width: 40),
                    Container(
                      width: 116,
                      height: 41,
                      decoration: BoxDecoration(
                        color: Color(0xFFDCC8C5).withOpacity(0.22),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Color(0xFFDCC8C5),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: _isEditing
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: TextFormField(
                                  controller: _prenomController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Entrer prenom',
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: "poppins"),
                                ),
                              )
                            : Text(
                                _userData['PrenomAdmin'] != null &&
                                        _userData['PrenomAdmin'].isNotEmpty
                                    ? _userData['PrenomAdmin']
                                    : 'Prenom',
                                style: TextStyle(
                                    color: _userData['PrenomAdmin'] != null &&
                                            _userData['PrenomAdmin'].isNotEmpty
                                        ? Colors.black
                                        : Colors.grey,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: "poppins"),
                              ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 277,
                      height: 41,
                      decoration: BoxDecoration(
                        color: Color(0xFFDCC8C5).withOpacity(0.22),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Color(0xFFDCC8C5),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _userData['EmailAdmin'] != null &&
                                  _userData['EmailAdmin'].isNotEmpty
                              ? _userData['EmailAdmin']
                              : 'Gmail',
                          style: TextStyle(
                              color: _userData['EmailAdmin'] != null &&
                                      _userData['EmailAdmin'].isNotEmpty
                                  ? Colors.black
                                  : Colors.grey,
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              fontFamily: "poppins"),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
