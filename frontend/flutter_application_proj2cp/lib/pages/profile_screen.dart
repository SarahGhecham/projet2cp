import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic> _userData = {};
  bool _isEditing = false;
  @override
  void initState() {
    super.initState();
    _isEditing = false;
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final url = Uri.parse(
        'http://localhost:3000/client/Affichermonprofil/1'); // Replace with your endpoint
    try {
      final response = await http.get(url);

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

  Future<void> updateClientImage(int id, File image) async {
    // Replace "http://localhost:3000" with your server URL
    String baseUrl =
        "http://localhost:3000"; // changer avec votre adressse ip/10.0.2.2(emulateur)
    String idString = id.toString();

    // Construct the endpoint URL
    String endpoint = "$baseUrl/client/updateClientImage/$id";

    try {
      // Create a multipart request
      var request = http.MultipartRequest('POST', Uri.parse(endpoint));

      // Attach the image file to the request
      request.files.add(await http.MultipartFile.fromPath('photo', image.path));

      // Send the request
      var streamedResponse = await request.send();

      // Check the response status
      if (streamedResponse.statusCode == 200) {
        // Image uploaded successfully, parse the response
        var response = await streamedResponse.stream.bytesToString();
        var data = jsonDecode(response);

        if (data['success'] == true) {
          // Client image updated successfully
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
        'http://localhost:3000/client/updateClient/1'); // changer avec votre adressse ip/10.0.2.2(emulateur)
    try {
      final response = await http.patch(
        url,
        body: json.encode(updatedData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('User data updated successfully');
        // Optionally, you might want to fetch and update the user data after it's been updated.
        // Uncomment the line below if you want to do that.
        // await _fetchUserData();
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
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Center(
                  child: Container(
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
                ),
                Stack(
                  children: [
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
                                    updateClientImage(1, imageFile);
                                  });
                                }
                              }
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: _userData['photo'] != null
                                  ? Image.network(
                                      _userData['photo'],
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
                        ),
                      ),
                    ),
                  ],
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
                          _saveChanges();
                          updateClient(_userData);
                          _toggleEditing(false);
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
                            'Points',
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
                        child: _isEditing
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: TextFormField(
                                  controller: _gmailController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Entrer email ',
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: TextFormField(
                                  controller: _addressController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Entrer Adresse',
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
                                _userData['AdresseClient'] != null &&
                                        _userData['AdresseClient'].isNotEmpty
                                    ? _userData['AdresseClient']
                                    : 'Adresse',
                                style: TextStyle(
                                  color: _userData['AdresseClient'] != null &&
                                          _userData['AdresseClient'].isNotEmpty
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
          ],
        ),
      ),
    );
  }
}
