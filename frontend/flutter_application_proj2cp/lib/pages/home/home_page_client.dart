import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/pages/home/components/home_header.dart';
import 'package:flutter_application_proj2cp/pages/home/components/service_populair_container.dart';
import 'package:flutter_application_proj2cp/pages/home/components/domain_container.dart';
import 'package:flutter_application_proj2cp/pages/home/components/bar_recherche.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static String routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> domainWidgets = [];
  List<Widget> ecoServiceWidgets = [];
  List<Widget> topPrestationWidgets = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await Future.wait([
      fetchDomaines(),
      fetchEcoServices(),
      fetchTopPrestations(),
    ]);
  }

  Future<void> fetchDomaines() async {
    final url = Uri.parse('http://10.0.2.2:3000/pageaccueil/AfficherDomaines');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        //print(
        // 'Fetched Image URLs: ${data.map((domaineJson) => domaineJson['imageDomaine']).toList()}');

        setState(() {
          domainWidgets = data
              .map((domaineJson) {
                return Domaine(
                  id: domaineJson['id'] as int,
                  image: domaineJson['imageDomaine'] != null
                      ? domaineJson['imageDomaine'] as String
                      : '', // Check for null before casting
                  serviceName: domaineJson['NomDomaine'] != null
                      ? domaineJson['NomDomaine'] as String
                      : '', // Check for null before casting
                );
              })
              .map((domaine) => DomaineContainer(
                    domaine: domaine,
                  ))
              .toList();
        });
      } else {
        print('Failed to fetch domaines: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
    } catch (error) {
      print('Error fetching domaines: $error');
    }
  }

  Future<void> fetchEcoServices() async {
    final url =
        Uri.parse('http://10.0.2.2:3000/pageaccueil/AfficherPrestationsEco');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        //print('Fetched Eco Services: $data');

        setState(() {
          ecoServiceWidgets = data
              .map((serviceJson) {
                final imageUrl = serviceJson['imagePrestation'] != null
                    ? serviceJson['imagePrestation'] as String
                    : '';
                //print('Image URL: $imageUrl'); // Debugging statement
                return Service(image: imageUrl);
              })
              .map((service) => ServiceOffreContainer(
                    service: service,
                  ))
              .toList();
        });
      } else {
        print('Failed to fetch eco services: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
    } catch (error) {
      print('Error fetching eco services: $error');
    }
  }

  Future<void> fetchTopPrestations() async {
    final url =
        Uri.parse('http://10.0.2.2:3000/pageaccueil/AfficherPrestationsTop');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Fetched Top Prestations: $data');

        setState(() {
          topPrestationWidgets = data
              .map((serviceJson) {
                final imageUrl = serviceJson['imagePrestation'] != null
                    ? serviceJson['imagePrestation'] as String
                    : '';
                print('Image URL: $imageUrl'); // Debugging statement
                return Service(image: imageUrl);
              })
              .map((service) => ServiceOffreContainer(
                    service: service,
                  ))
              .toList();
        });
      } else {
        print('Failed to fetch top prestations: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
    } catch (error) {
      print('Error fetching top prestations: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              HomeHeader(),
              BarRecherche(),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Nos Domaines',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 250,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  children: domainWidgets,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Services Populaires',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  children: topPrestationWidgets,

                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Services écologiques',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 220,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  children: ecoServiceWidgets,
                ),
              ),
              SizedBox(
                height: 80,

              )
            ],
          ),
        ),
      ),
    );
  }
}
