import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_proj2cp/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_proj2cp/pages/artisan/detail_demande_acceptee.dart';
import 'package:flutter_application_proj2cp/pages/artisan/detail_demande_lancee.dart';

class Acc_artisan extends StatefulWidget {
  @override
  _Acc_artisanState createState() => _Acc_artisanState();
}

class Demande {
  final int id;
  final int rdvId;
  final bool urgente;
  final Map<String, dynamic> client;
  final Map<String, dynamic> prestation;

  Demande(
      {required this.id,
      required this.rdvId,
      required this.client,
      required this.prestation,
      required this.urgente});

  factory Demande.fromJson(Map<String, dynamic> json) {
    return Demande(
      id: json['id'],
      rdvId: json['rdvId'],
      // If null, set it to an empty string
      client: json['client'] ?? {}, // If null, set it to an empty map
      prestation: json['prestation'] ?? {}, // If null, set it to an empty map
      urgente: json['urgente'] ?? false,
    );
  }
}

Future<List<Demande>> consulterDemandes(String token) async {
  String url =
      'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/artisan/ConsulterDemandes';

  try {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> responseData = jsonDecode(response.body);

      List<Demande> demands =
          responseData.map((data) => Demande.fromJson(data)).toList();

      return demands;
    } else {
      print('Request failed with status: ${response.statusCode}');
      throw Exception('Failed to load demands');
    }
  } catch (error) {
    print('Error retrieving demands: $error');
    throw Exception('Failed to load demands');
  }
}

Future<String> fetchArtisanphoto(String token) async {
  final url =
      'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/artisan/Affichermonprofil'; // Replace with your backend URL
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  try {
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      // If the request is successful, parse the JSON response
      final jsonData = json.decode(response.body);
      return jsonData['photo'];
    } else {
      // If the request is unsuccessful, throw an exception with the error message
      throw Exception('Failed to load artisan photo');
    }
  } catch (error) {
    // Handle any errors that occur during the process
    throw Exception('Failed to load artisan photo : $error');
  }
}

Future<String> fetchArtisanName(String token) async {
  final url =
      'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/artisan/Affichermonprofil'; // Replace with your backend URL
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  try {
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      // If the request is successful, parse the JSON response
      final jsonData = json.decode(response.body);
      return jsonData[
          'NomArtisan']; // Assuming 'NomArtisan' is the key for the artisan's name
    } else {
      // If the request is unsuccessful, throw an exception with the error message
      throw Exception('Failed to load artisan name');
    }
  } catch (error) {
    // Handle any errors that occur during the process
    throw Exception('Failed to load artisan name: $error');
  }
}

Future<int> fetchArtisanId(String token) async {
  final url =
      'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/artisan/Affichermonprofil'; // Replace with your backend URL
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  try {
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      // If the request is successful, parse the JSON response
      final jsonData = json.decode(response.body);
      return jsonData['id']; // Assuming 'Id' is the key for the artisan's ID
    } else {
      // If the request is unsuccessful, throw an exception with the error message
      throw Exception('Failed to load artisan ID');
    }
  } catch (error) {
    // Handle any errors that occur during the process
    throw Exception('Failed to load artisan ID: $error');
  }
}

Future<void> accepterRDV(int demandeId, int artisanId, String token) async {
  final url =
      'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/artisan/accepterRDV'; // Replace with your API endpoint

  try {
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'demandeId': demandeId,
        'artisanId': artisanId,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', // Include your token here
      },
    );

    if (response.statusCode == 200) {
      print('Success: ${jsonDecode(response.body)['message']}');
      // Handle success response from backend if needed
    } else {
      print('Error: ${jsonDecode(response.body)['message']}');
      // Handle error response from backend if needed
    }
  } catch (error) {
    print('Error: $error');
    // Handle network or other errors if needed
  }
}

Future<void> refuserRDV(int demandeId, int artisanId, String token) async {
  final url =
      'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/artisan/refuserRDV'; // Replace with your API endpoint

  try {
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'demandeId': demandeId,
        'artisanId': artisanId,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', // Include your token here
      },
    );

    if (response.statusCode == 200) {
      print('Success: ${jsonDecode(response.body)['message']}');
      // Handle success response from backend if needed
    } else {
      print('Error: ${jsonDecode(response.body)['message']}');
      // Handle error response from backend if needed
    }
  } catch (error) {
    print('Error: $error');
    // Handle network or other errors if needed
  }
}

// Appel de la fonction consulterDemandes et utilisation des données

class _Acc_artisanState extends State<Acc_artisan> {
  List<Demande> clients = [];
  String greeting = '';
  String name = '';
  String photos = '';
  late int id;
  late String token;
  final Key listViewKey = UniqueKey();
  void _updateClientsList(
      List<Demande> newClients, String nom, String photo, int idd, String tok) {
    setState(() {
      clients = newClients;
      name = nom;
      photos = photo;
      id = idd;
      token = tok;
    });
  }

  void fetchData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ??
          ''; // Récupérer le token depuis SharedPreferences
      print('Token: $token');

      // Récupérer les demandes en utilisant la fonction consulterDemandes
      List<Demande> demands = await consulterDemandes(token);

      String nom = await fetchArtisanName(token);
      String photo = await fetchArtisanphoto(token);
      int id = await fetchArtisanId(token);
      _updateClientsList(demands, nom, photo, id, token);
      // Assigner les demandes à la variable clients
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  void _removeClient(int index) {
    setState(() {
      clients.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();

    // Update the clients list with fetched demands
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 23),
              Row(
                children: [
                  SizedBox(width: 5),
                  Padding(
                    padding: EdgeInsets.all(30),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(photos),
                      radius: 30,
                    ),
                  ),
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 41,
                    width: 317,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFDCC8C5),
                    ),
                    child: Text(
                      'Demandes lancées',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Lato',
                      ),
                    ),
                  ),
                  ListView.builder(
                    key: listViewKey,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: clients.length,
                    itemBuilder: (context, index) {
                      bool isFirstItem = index == 0;

                      return GestureDetector(
                        onTap: () {
                          // Navigate to the desired page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Demandelancee(
                                    demandeID: clients[index].id)),
                          );
                        },
                        child: Container(
                          height: 93,
                          width: 329,
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
                                    margin: EdgeInsets.only(left: 12, top: 19),
                                    width: 55,
                                    height: 55,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(45),
                                      child: clients.isNotEmpty &&
                                              clients[index].client['photo'] !=
                                                  null
                                          ? Image.network(
                                              clients[index].client['photo'],
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
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 15),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: clients[index]
                                                              .prestation[
                                                          'nomPrestation'],
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: const Color(
                                                            0xFF05564B),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    if (clients[index]
                                                            .prestation[
                                                        'Ecologique']) ...[
                                                      WidgetSpan(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 2),
                                                          child:
                                                              SvgPicture.asset(
                                                            'assets/leaf.svg',
                                                            color: const Color(
                                                                    0xff05564B)
                                                                .withOpacity(
                                                                    0.6),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          (clients[index].client['username'] !=
                                                  null)
                                              ? '${clients[index].client['username']} '
                                              : '',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w200,
                                            fontFamily: 'Lato',
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 5, // Add margin from the top
                                    right: 5, // Add margin from the right
                                    child: Visibility(
                                      visible: clients[index].urgente,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            top: 7, right: 7), // Set margin
                                        child: SvgPicture.asset(
                                          'assets/urgent.svg',
                                          color:
                                              Color(0xffFF8787).withOpacity(1),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                bottom: 11,
                                right: 105,
                                child: Container(
                                  height: 20,
                                  width: 60,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color: Colors.green,
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      int rdv = clients[index].rdvId;
                                      int dm = clients[index].id;
                                      print(index);
                                      print(clients[index].rdvId);
                                      print(clients[index].id);
                                      accepterRDV(clients[index].id, id, token);
                                      _removeClient(index);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DemandeAcceptee(
                                                    demandeID: dm, rdvID: rdv)),
                                      );
                                    },
                                    style: ButtonStyle(
                                      padding:
                                          MaterialStateProperty.all<EdgeInsets>(
                                        EdgeInsets.zero,
                                      ),
                                    ),
                                    child: Text(
                                      'Accepter',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 8,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Lato',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Positioned(
                                bottom: 11,
                                right: 35,
                                child: Container(
                                  height: 20,
                                  width: 60,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color: Color(0xffE52E22),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      refuserRDV(clients[index].id, id, token);
                                      _removeClient(index);
                                    },
                                    style: ButtonStyle(
                                      padding:
                                          MaterialStateProperty.all<EdgeInsets>(
                                        EdgeInsets.zero,
                                      ),
                                    ),
                                    child: Text(
                                      'Refuser',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 8,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Lato',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
