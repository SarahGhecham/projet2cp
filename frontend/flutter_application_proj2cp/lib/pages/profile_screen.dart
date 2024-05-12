import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/parametre.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_proj2cp/config.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
        'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/client/Affichermonprofil'); // Replace with your endpoint
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        final userDataJson = json.decode(response.body);

        setState(() {
          _userData = {
            'Username': userDataJson['Username'] as String,
            'EmailClient': userDataJson['EmailClient'] as String,
            'AdresseClient': userDataJson['AdresseClient'] as String,
            'NumeroTelClient': userDataJson['NumeroTelClient'] as String,
            'Points': userDataJson['Points'],
            'Service_account': userDataJson['Service_account'],
            'photo': userDataJson['photo']
          };
          _UsernameController.text = _userData['Username'];
          _numeroController.text = _userData['NumeroTelClient'];
          _gmailController.text = _userData['EmailClient'];
          _addressController.text = _userData['AdresseClient'];
          _pickedImagePath = _userData['photo'];
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

  bool _isAddressMatchingSuggestion(String address) {
    String cleanedAddress = _cleanAddress(address.trim());

    for (var suggestion in _predictions) {
      String cleanedSuggestion =
          _cleanAddress(suggestion["description"].trim());
      if (cleanedSuggestion == cleanedAddress) {
        return true;
      }
    }
    return false;
  }

  String _cleanAddress(String address) {
    // Remove spaces and special characters from the address
    return address.replaceAll(RegExp(r'[^\w\s]+'), '');
  }

  List<dynamic> _predictions = [];
  bool _showSuggestions = true;
  bool _suggestionSelected = false;
  String _addressErrorText = '';
  @override
  void _searchPlaces(String input) async {
    const apiKey = 'AIzaSyBUoTHDCzxA7lix93aS8D5EuPa-VCuoAq0';
    String url;

    if (input.isEmpty) {
      // Fetch predictions without a specific query
      url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?types=establishment&key=$apiKey&language=fr';
    } else {
      url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=establishment&key=$apiKey&language=fr';
    }

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    setState(() {
      _predictions = data['predictions'];
    });
  }

  /*void _searchPlaces(String input) async {
    const apiKey = 'AIzaSyD_d366EANPIHugZe9YF5QVxHHa_Bzef_4';
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=(cities)&key=$apiKey&language=fr';

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    setState(() {
      _predictions = data['predictions'];
    });
  }*/

  Future<void> updateClientImage(File image, String token) async {
    // Replace "http://localhost:3000" with your server URL
    String baseUrl =
        "http://${AppConfig.serverAddress}:${AppConfig.serverPort}";

    // Construct the endpoint URL
    String endpoint = "$baseUrl/client/updateClientImage";

    try {
      // Create a multipart request
      var request = http.MultipartRequest('POST', Uri.parse(endpoint));
      print(image.path);

      // Attach the image file to the request
      request.files.add(await http.MultipartFile.fromPath('image', image.path));

      // Add Authorization header with token
      request.headers['Authorization'] = 'Bearer $token';

      // Send the request
      var streamedResponse = await request.send();

      // Check the response status
      if (streamedResponse.statusCode == 200) {
        // Image uploaded successfully, parse the response
        var response = await streamedResponse.stream.bytesToString();
        var data = jsonDecode(response);

        if (data['success'] == true) {
          // Client image updated successfully
          await _fetchUserData();
          print('Client image updated successfully');
        } else {
          // Image upload failed
          print('Failed to update client image: ${data['message']}');
        }
      } else {
        // Request failed
        print('Request failed with status: ${streamedResponse.statusCode}');
      }
    } catch (e) {
      // Handle errors
      print('Error: $e');
    }
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

  final ImagePicker _imagePicker = ImagePicker();

  var _pickedImagePath = null; // var jsp si c ccorrect hna
  TextEditingController _UsernameController = TextEditingController();
  TextEditingController _numeroController = TextEditingController();
  TextEditingController _gmailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  void _toggleEditing(bool value) {
    setState(() {
      _isEditing = value;
    });
  }

  void _saveChanges() {
    _userData['Username'] = _UsernameController.text.isNotEmpty
        ? _UsernameController.text
        : _userData['Username'];
    _userData['NumeroTelClient'] = _numeroController.text.isNotEmpty
        ? _numeroController.text
        : _userData['NumeroTelClient'];

    _userData['EmailClient'] = _gmailController.text.isNotEmpty
        ? _gmailController.text
        : _userData['EmailClient'];

    _userData['AdresseClient'] = _addressController.text.isNotEmpty
        ? _addressController.text
        : _userData['AdresseClient'];
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => parametrePage()),
              );
            },
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
                            child: _userData['photo'] != null
                                ? Image.network(
                                    _userData[
                                        'photo'], // Utilisez l'URL de la photo de profil
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
                          Visibility(
                            visible: _isEditing,
                            child: Positioned(
                              top: 6,
                              right: 6,
                              child: GestureDetector(
                                onTap: () {
                                  // Action to perform when the edit icon is tapped
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.black,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: GestureDetector(
                              onTap: () async {
                                if (_isEditing) {
                                  final picker = ImagePicker();
                                  final pickedFile = await picker.getImage(
                                    source: ImageSource.gallery,
                                  );

                                  if (pickedFile != null) {
                                    setState(() {
                                      File imageFile = File(pickedFile.path);
                                      updateClientImage(imageFile, _token);
                                    });
                                  }
                                }
                              },
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
                        if (_isEditing) {
                          // Check if the address field matches any of the suggestions
                          bool addressMatchesSuggestion =
                              _isAddressMatchingSuggestion(
                                  _addressController.text);
                          print(_addressController.text);

                          if (addressMatchesSuggestion ||
                              _suggestionSelected ||
                              _addressController.text.isEmpty ||
                              _addressErrorText.isEmpty) {
                            _saveChanges();
                            updateClient(_userData);
                            _toggleEditing(false);
                          } else {
                            setState(() {
                              _addressErrorText =
                                  'Veuillez choisir un emplacement de la liste ';
                            });
                          }
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
                SizedBox(height: 30),
                Container(
                  width: 170,
                  height: 61,
                  margin: EdgeInsets.only(left: 00, bottom: 00),
                  decoration: BoxDecoration(
                    color: Color(0xFFD6E3DC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Color(0xFFDCC8C5),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Services',
                            style: TextStyle(
                              color: Color(0xFFFF8787),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _userData['Service_account'].toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 1,
                        height: double.infinity,
                        color: Color(0xFFDCC8C5),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '  Points',
                            style: TextStyle(
                              color: Color(0xFFFF8787),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _userData['Points'].toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
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
                                  controller: _UsernameController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Entrer Username',
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                  style: TextStyle(
                                    color: _userData['Username'] != null &&
                                            _userData['Username'].isNotEmpty
                                        ? Colors.black
                                        : Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : Text(
                                _userData['Username'] != null &&
                                        _userData['Username'].isNotEmpty
                                    ? _userData['Username']
                                    : ' Username',
                                style: TextStyle(
                                  color: _userData['Username'] != null &&
                                          _userData['Username'].isNotEmpty
                                      ? Colors.black
                                      : Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
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
                                  controller: _numeroController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Entrer num Tel',
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : Text(
                                _userData['NumeroTelClient'] != null &&
                                        _userData['NumeroTelClient'].isNotEmpty
                                    ? _userData['NumeroTelClient']
                                    : 'NumeroTel',
                                style: TextStyle(
                                  color: _userData['NumeroTelClient'] != null &&
                                          _userData['NumeroTelClient']
                                              .isNotEmpty
                                      ? Colors.black
                                      : Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
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
                          _userData['EmailClient'] != null &&
                                  _userData['EmailClient'].isNotEmpty
                              ? _userData['EmailClient']
                              : 'Gmail',
                          style: TextStyle(
                            color: _userData['EmailClient'] != null &&
                                    _userData['EmailClient'].isNotEmpty
                                ? Colors.black
                                : Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 277,
                            height: 51,
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: TextFormField(
                                        controller: _addressController,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Entrer Adresse',
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                        ),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        onChanged: (value) {
                                          if (value.isNotEmpty) {
                                            _searchPlaces(value);
                                            setState(() {
                                              _showSuggestions = true;
                                              _suggestionSelected = false;
                                              _addressErrorText = '';
                                            });
                                            _scrollController?.animateTo(
                                              _scrollController?.position
                                                      .maxScrollExtent ??
                                                  00,
                                              duration:
                                                  Duration(milliseconds: 500),
                                              curve: Curves.easeInOut,
                                            );
                                          } else {
                                            setState(() {
                                              _showSuggestions = false;
                                              _suggestionSelected = false;
                                            });
                                          }
                                        },
                                      ),
                                    )
                                  : Text(
                                      _userData['AdresseClient'] != null &&
                                              _userData['AdresseClient']
                                                  .isNotEmpty
                                          ? _userData['AdresseClient']
                                          : 'Adresse',
                                      style: TextStyle(
                                        color: _userData['AdresseClient'] !=
                                                    null &&
                                                _userData['AdresseClient']
                                                    .isNotEmpty
                                            ? Colors.black
                                            : Colors.grey,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ), // Add some space between TextFormField and Text
                          if (_isEditing && _addressErrorText.isNotEmpty)
                            Text(
                              _addressErrorText,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            )
                          else
                            Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Visibility(
                                  visible: _isEditing && _showSuggestions,
                                  child: Container(
                                    width:
                                        277, // Match the width of the address field
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ListView.separated(
                                      padding: EdgeInsets.zero,
                                      controller: _scrollController,
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return Divider(
                                          color: Color(0xFFDCC8C5),
                                          thickness: 1.0,
                                        );
                                      },
                                      shrinkWrap: true,
                                      itemCount: _predictions.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical:
                                                  10), // Adjust vertical padding
                                          title: Text(
                                            _predictions[index]["description"],
                                            textAlign: TextAlign.center,
                                          ),
                                          onTap: () {
                                            _addressController.text =
                                                _predictions[index]
                                                    ["description"];
                                            setState(() {
                                              _showSuggestions = false;
                                              _suggestionSelected = true;
                                              _addressErrorText = '';
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  child: Visibility(
                                    visible: _showSuggestions,
                                    child: Icon(
                                      Icons.arrow_downward,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
