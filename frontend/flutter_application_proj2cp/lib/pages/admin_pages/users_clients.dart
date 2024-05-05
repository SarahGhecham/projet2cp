import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/constants/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_proj2cp/config.dart';

class Client {
  final String name;
  final String photoDeProfil;
  Client({
    required this.name,
    required this.photoDeProfil,
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

  Future<void> fetchAllClients() async {
    final url = Uri.parse('http://10.0.2.2:3000/admins/Afficher/Clients');
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $_token'},
      );
      if (response.statusCode == 200) {
        //print("coucou");
        List<dynamic> data = json.decode(response.body);
        final List<Client?> clients = [];
        for (var item in data) {
          final name = item['Username'] as String?;
          final photoDeProfil = item['photo'] as String?;

          if (name != null && photoDeProfil != null) {
            clients.add(Client(
              name: name,
              photoDeProfil: photoDeProfil,
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
            return Container(
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
                          image: NetworkImage(client?.photoDeProfil ?? ''),
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
                          fontSize: 12,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
