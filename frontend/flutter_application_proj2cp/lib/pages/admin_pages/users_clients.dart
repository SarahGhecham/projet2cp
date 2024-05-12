import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/constants/constants.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/profil_client.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_proj2cp/config.dart';

class Client {
  String name;
  String email;
  String numTel;
  int points;
  int servicecount;
  String adress;

  String? photoDeProfil;
  Client({
    required this.name,
    required this.email,
    required this.numTel,
    required this.points,
    required this.servicecount,
    required this.adress,
    this.photoDeProfil,
  });
}

class ClientsList extends StatefulWidget {
  const ClientsList({super.key});

  @override
  State<ClientsList> createState() => _ClientsListState();
}

class _ClientsListState extends State<ClientsList> {
  List<Client?> _clients = [];
  late String _token;
  List<Client?> _filteredClients = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? '';
    print('Token: $_token');
    await Future.wait([
      fetchAllClients(),
    ]);
  }

  void _filterClients(String query) {
    setState(() {
      _filteredClients = _clients
          .where((client) =>
              client?.name.toLowerCase().contains(query.toLowerCase()) ?? false)
          .toList();
    });
  }

  void _navigateToProfile(Client client) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VoirProfilClient(
          client: client,
        ),
      ),
    );
  }

  Future<void> fetchAllClients() async {
    final url = Uri.parse(
        'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/admins/Afficher/Clients');
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $_token'},
      );
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        final List<Client?> clients = [];
        for (var item in data) {
          final name = item['Username'] as String?;
          final photoDeProfil = item['photo'] as String?;

          if (name != null) {
            clients.add(Client(
              name: name,
              photoDeProfil: photoDeProfil,
              email: item['EmailClient'] as String,
              numTel: item['NumeroTelClient'] as String,
              points: item['Points'] as int,
              servicecount: item['Service_account'] as int,
              adress: item['AdresseClient'] as String,
            ));
          }
        }
        setState(() {
          _clients = clients;
        });
      } else {
        print('Failed to fetch clients ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching clients $error');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          padding:
              const EdgeInsets.only(bottom: kBottomNavigationBarHeight + 70),
          itemCount: _clients.length,
          itemBuilder: (context, index) {
            final client = _clients[index];
            return GestureDetector(
              onTap: () {
                if (client != null) {
                  _navigateToProfile(client);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: creme, width: 1),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 65,
                        height: 65,
                        decoration: BoxDecoration(
                          color: creme,
                          borderRadius: BorderRadius.circular(40),
                          image: DecorationImage(
                            image: client?.photoDeProfil != null
                                ? NetworkImage(client!.photoDeProfil!)
                                    as ImageProvider
                                : AssetImage('assets/pasdepfp.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        client?.name ?? '',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
