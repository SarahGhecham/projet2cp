import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/config.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/users_clients.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VoirProfilClient extends StatefulWidget {
  final Client client;

  const VoirProfilClient({Key? key, required this.client}) : super(key: key);

  @override
  State<VoirProfilClient> createState() => _VoirProfilClientState();
}

class _VoirProfilClientState extends State<VoirProfilClient> {
  late String _token;
  Map<String, dynamic> _userData = {};
  // late String _clientUsername = '';
  // late String _clientNumTel = '';
  //late String _clientEmail = '';
  // late String _clientAdress = '';
  //late String _pickedImagePath = '';
  late Client _client;
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
    if (widget.client != null) {
      _client = widget.client;
      fetchData(); // Start fetching user data
    }
  }

  Future<void> _fetchUserData() async {
    final url = Uri.parse(
        'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/client/Affichermonprofil');
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
            'photo': userDataJson['photo'] as String?,
          };

          _client = Client(
            name: _userData['Username'],
            email: _userData['EmailClient'],
            adress: _userData['AdresseClient'],
            numTel: _userData['NumeroTelClient'],
            points: _userData['Points'],
            servicecount: _userData['Service_account'],
            photoDeProfil: _userData['photo'],
          );
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

  Future<void> suspendAccount() async {
    print(_client.email);

    final url = Uri.parse(
        'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/admins/Desactiver/Client');
    try {
      final response = await http.patch(
        // Use http.patch for a PATCH request
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'EmailClient': _client.email}),
      );

      if (response.statusCode == 200) {
        print('Client deactivated successfully');
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
      _isSuspended = prefs.getBool('isSuspended${_client.email}') ?? false;
    });
  }

  void _saveSuspensionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isSuspended${_client.email}', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _client.name,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600, // Semibold
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
                            child: _client.photoDeProfil != null
                                ? Image.network(
                                    _client
                                        .photoDeProfil!, // Use '!' to assert non-nullability
                                    width: 168,
                                    height: 174,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    'assets/images/l.png', // Placeholder image for null 'photoDeProfil'
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
                                  MaterialStateProperty.all<Color>(Colors.red),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(color: Colors.red),
                                ),
                              ),
                              elevation: MaterialStateProperty.all<double>(0),
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.symmetric(
                                    vertical: 1.0, horizontal: 2.0),
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
                            _client.servicecount.toString(),
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
                            _client.points.toString(),
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
                        child: Text(
                          _client.name != null && _client.name.isNotEmpty
                              ? _client.name
                              : ' Username',
                          style: TextStyle(
                            color:
                                _client.name != null && _client.name.isNotEmpty
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
                        child: Text(
                          _client.numTel != null && _client.numTel.isNotEmpty
                              ? _client.numTel
                              : 'NumeroTel',
                          style: TextStyle(
                            color: _client.numTel != null &&
                                    _client.numTel.isNotEmpty
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
                          _client.email != null && _client.email.isNotEmpty
                              ? _client.email
                              : 'Gmail',
                          style: TextStyle(
                            color: _client.email != null &&
                                    _client.email.isNotEmpty
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
                              child: Text(
                                _client.adress != null &&
                                        _client.adress.isNotEmpty
                                    ? _client.adress
                                    : 'Adresse',
                                style: TextStyle(
                                  color: _client.adress != null &&
                                          _client.adress.isNotEmpty
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
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
