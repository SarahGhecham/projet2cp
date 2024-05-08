import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_proj2cp/constants/constants.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/creer_artisan.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_proj2cp/config.dart';

class Artisan {
  final String nom;
  final String prenom;
  final String? image;
  Artisan({required this.nom, required this.prenom, this.image});
}

class ArtisansList extends StatefulWidget {
  const ArtisansList({super.key});

  @override
  State<ArtisansList> createState() => _ArtisansListState();
}

class _ArtisansListState extends State<ArtisansList> {
  List<Artisan?> _artisans = [];
  late String _token;
  final defaultPfp = AssetImage('assets/pasdepfp.png');

  @override
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
      fetchAllArtisans(),
    ]);
  }

  Future<void> fetchAllArtisans() async {
    final url = Uri.parse('http://${AppConfig.serverAddress}:${AppConfig.serverPort}/admins/Afficher/Artisans');
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $_token'},
      );
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        final List<Artisan?> artisans = [];
        for (var item in data) {
          final nom = item['NomArtisan'] as String?;
          final prenom = item['PrenomArtisan'] as String?;
          final photoDeProfil = item['photo'] as String?;

          if (nom != null && prenom != null) {
            artisans.add(Artisan(
              nom: nom,
              prenom: prenom,
              image: photoDeProfil,
            ));
          }
        }
        setState(() {
          _artisans = artisans;
          print('$artisans');
        });
      } else {
        print('Failed to fetch artisans ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching artisans $error');
    }
  }

  Widget _buildProfileImage(Artisan? artisan) {
    if (artisan?.image != null && artisan!.image!.isNotEmpty) {
      return Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          color: creme,
          borderRadius: BorderRadius.circular(30),
          image: DecorationImage(
            image: NetworkImage(artisan.image!),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      // Display default profile picture if image URL is null or empty
      return Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          color: creme,
          borderRadius: BorderRadius.circular(30),
          image: DecorationImage(
            image: defaultPfp,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.only(
          bottom: kBottomNavigationBarHeight + 70,
        ),
        itemCount: _artisans.length,
        itemBuilder: (context, index) {
          final artisan = _artisans[index];
          return Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: creme, width: 1),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildProfileImage(artisan),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    '${artisan?.nom ?? ''} ${artisan?.prenom ?? ''}',
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
          );
        },
      ),
    );
  }
}
