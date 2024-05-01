import 'dart:convert';
import 'package:flutter_application_proj2cp/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/ajouter_domaine.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/drawer.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/search_bar.dart';
import 'package:flutter_application_proj2cp/pages/home/components/domain_container.dart';
import 'package:flutter_application_proj2cp/pages/home/components/service_populair_container.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class DrawerServices extends StatefulWidget {
  const DrawerServices({super.key});

  @override
  State<DrawerServices> createState() => _DrawerServicesState();
}

class _DrawerServicesState extends State<DrawerServices> {
  List<Widget> domainWidgets = [];
  List<Widget> ecoServiceWidgets = [];
  List<Widget> topPrestationWidgets = [];
  late String _token;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentPageIndex = 1;
  void onPageSelected(int index) {
    setState(() {
      _currentPageIndex = index;
    });
    // You can add logic here to navigate to different pages based on the index
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    //final prefs = await SharedPreferences.getInstance();
    //_token = prefs.getString('token') ?? '';
    //print('Token: $_token');
    await Future.wait([
      fetchDomaines(),
      fetchEcoServices(),
      fetchTopPrestations(),
    ]);
  }

  Future<void> fetchDomaines() async {
    final url =
        Uri.parse('http://192.168.100.7:3000/pageaccueil/AfficherDomaines');
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $_token'},
      );

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
    final url = Uri.parse(
        'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/pageaccueil/AfficherPrestationsEco');
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Fetched Eco Services: $data');

        setState(() {
          ecoServiceWidgets = data
              .map((serviceJson) {
                final imageUrl = serviceJson['imagePrestation'] != null
                    ? serviceJson['imagePrestation'] as String
                    : '';
                //print('Image URL: $imageUrl'); // Debugging statement
                return Service(
                  id: serviceJson['id'] as int,
                  nomPrestation: serviceJson['NomPrestation'] as String,
                  materiel: serviceJson['Matériel'] as String,
                  Description: serviceJson['Description'] as String,
                  dureeMax: serviceJson['DuréeMax'] as String,
                  dureeMin: serviceJson['DuréeMin'] as String,
                  tarifId: serviceJson['TarifId'] as int,
                  domaineId: serviceJson['DomaineId'] as int,
                  ecologique: serviceJson['Ecologique'] as bool,
                  image: imageUrl,
                  tarifJourMin: serviceJson['Tarif']['TarifJourMin'] as String,
                  tarifJourMax: serviceJson['Tarif']['TarifJourMax'] as String,
                  Unite: serviceJson['Tarif']['Unité'] as String
                );
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
    final url = Uri.parse(
        'http://192.168.100.7:3000/pageaccueil/AfficherPrestationsTop');
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $_token'},
      );

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
                return Service(
                  id: serviceJson['id'] as int,
                  nomPrestation: serviceJson['NomPrestation'] as String,
                  materiel: serviceJson['Matériel'] as String,
                  Description: serviceJson['Matériel'] as String,
                  dureeMax: serviceJson['DuréeMax'] as String,
                  dureeMin: serviceJson['DuréeMin'] as String,
                  tarifId: serviceJson['TarifId'] as int,
                  domaineId: serviceJson['DomaineId'] as int,
                  ecologique: serviceJson['Ecologique'] as bool,
                  image: imageUrl,
                  tarifJourMin: serviceJson['Tarif']['TarifJourMin'] as String,
                  tarifJourMax: serviceJson['Tarif']['TarifJourMax'] as String,
                  Unite: serviceJson['Tarif']['Unité'] as String
                );
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

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerDash(
        onPageSelected: onPageSelected,
        initialSelectedIndex:
            _currentPageIndex, // Pass the _currentPageIndex here
      ),
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 25.0), // Adjusted padding
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
                  // Search bar with expanded flex
                  Expanded(
                    flex: 2, // Give search bar more space (optional)
                    child: BarRecherche(),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(27, 30, 30, 30),
                    child: Text(
                      'Nos Domaines',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: IconButton(
                      icon: Image.asset(
                        'assets/icons/ajouter.png',
                        height: 30,
                        width: 30,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddDomainePage(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 250,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  children: domainWidgets,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(27, 30, 30, 30),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: IconButton(
                      icon: Image.asset(
                        'assets/icons/ajouter.png',
                        height: 30,
                        width: 30,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddDomainePage(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  children: topPrestationWidgets,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(27, 30, 30, 30),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: IconButton(
                      icon: Image.asset(
                        'assets/icons/ajouter.png',
                        height: 30,
                        width: 30,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddDomainePage(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
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
