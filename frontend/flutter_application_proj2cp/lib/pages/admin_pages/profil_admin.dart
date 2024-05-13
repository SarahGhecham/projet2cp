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
        'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/admins'); // Replace with your endpoint
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $_token'},
      );

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

  TextEditingController _nomController = TextEditingController();
  TextEditingController _prenomController = TextEditingController();
  TextEditingController _gmailController = TextEditingController();

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
        /*actions: [
          IconButton(
            icon: SizedBox(
              width: 32,
              height: 32,
              child: Image.asset('assets/images/settings.png'),
            ),
            onPressed: () {},
          ),
        ],*/
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Column(
            children: [
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
                                              _userData['PrenomAdmin']
                                                  .isNotEmpty
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
                                : 'E-mail',
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
