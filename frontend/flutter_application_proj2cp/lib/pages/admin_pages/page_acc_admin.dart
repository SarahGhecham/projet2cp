import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/constants/constants.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/drawer.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeaderAdmin {
  String nomAdmin;
  String prenomAdmin;
  String profilePictureUrl;

  HeaderAdmin({
    required this.nomAdmin,
    required this.prenomAdmin,
    required this.profilePictureUrl,
  });

  // Update method to set data from backend
  void setData(String nomAdmin, String prenomAdmin, String profilePictureUrl) {
    this.nomAdmin = nomAdmin;
    this.prenomAdmin = prenomAdmin;
    this.profilePictureUrl = profilePictureUrl;
  }
}

class HomePageAdmin extends StatefulWidget {
  const HomePageAdmin({Key? key}) : super(key: key);

  @override
  State<HomePageAdmin> createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late HeaderAdmin _headerAdmin = HeaderAdmin(
    nomAdmin: 'admin',
    prenomAdmin: 'admin',
    profilePictureUrl: 'https://picsum.photos/250?image=9',
  );
  int _currentPageIndex = 0;
  int _nombreClients = 0;
  int _nombreArtisans = 0;
  int _nombreDemandes = 0;
  late String _token;
  final defaultImageUrl =
      'http://192.168.100.7:3000/imageClient/1714391607342.jpg';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? '';
    print('Token: $_token');
    await Future.wait([
      _loadStatistics(),
      _fetchUserData(),
    ]);
  }

  Future<void> _loadStatistics() async {
    final url = Uri.parse('http://10.0.2.2:3000/admins/Obtenir/Statistiques');
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $_token'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _nombreClients = data['nombreClients'];
          _nombreArtisans = data['nombreArtisans'];
          _nombreDemandes = data['nombreDemandes'];
        });
      } else {
        throw Exception('Failed to load statistics');
      }
    } catch (e) {
      print('Error loading statistics: $e');
    }
  }

  Future<void> _fetchUserData() async {
    final url = Uri.parse('http://10.0.2.2:3000/admins/1');
    try {
      final response = await http.get(
        url,
      );

      if (response.statusCode == 200) {
        final userDataJson = jsonDecode(response.body);

        final nom = userDataJson['NomAdmin'] as String;
        final prenom = userDataJson['PrenomAdmin'] as String;

        setState(() {
          _headerAdmin.setData(nom, prenom, defaultImageUrl);
        });
        print('User data fetched: $_headerAdmin');
      } else {
        print('Failed to fetch user data');
        print('Response Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  void onPageSelected(int index) {
    setState(() {
      _currentPageIndex = index;
    });
    // You can add logic here to navigate to different pages based on the index
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerDash(onPageSelected: onPageSelected),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: CircleAvatar(
                    backgroundImage:
                        NetworkImage(_headerAdmin.profilePictureUrl),
                    radius: 30,
                  ),
                ),
                Text(
                  'Salut ${_headerAdmin.prenomAdmin.substring(0, 1).toUpperCase()}. ${_headerAdmin.nomAdmin}',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    // Handle notifications button tap
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Image.asset(
                      'assets/icons/notifs.png',
                      height: 30,
                      width: 30,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10), // Spacer between the two rows
            Padding(
              padding: const EdgeInsets.only(left: 25.0), // Adjusted padding
              child: GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                child: SizedBox(
                  width: 30, // Adjusted width
                  height: 30,
                  child: Image.asset(
                    'assets/icons/options.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 30, 20, 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Statistiques',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            //SizedBox(height: 30), // Spacer between the two rows
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                itemCount: 3,
                separatorBuilder: (context, index) => SizedBox(height: 20),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildListItem('Clients inscrits', _nombreClients,
                        'assets/stats_users.png');
                  } else if (index == 1) {
                    return _buildListItem('Artisans inscrits', _nombreArtisans,
                        'assets/stats_users.png');
                  } else if (index == 2) {
                    return _buildListItem('Demandes lancées', _nombreDemandes,
                        'assets/stats_demandes.png');
                  }
                  return SizedBox.shrink(); // Placeholder
                },
              ),
            ),
            SizedBox(height: 90),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(String title, int value, String iconAsset) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cremeClair,
        borderRadius: BorderRadius.circular(37.0),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 45,
            right: 10,
            child: Image.asset(
              iconAsset,
              width: 100,
              height: 100,
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: Text(
              title,
              style: GoogleFonts.poppins(
                color: Color.fromARGB(255, 62, 61, 61),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 130, left: 30, bottom: 10),
            child: Text(
              value.toString(),
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}