import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/pages/home/components/home_header.dart';
import 'package:flutter_application_proj2cp/pages/home/components/service_populair_container.dart';
import 'package:flutter_application_proj2cp/pages/home/components/domain_container.dart';
import 'package:flutter_application_proj2cp/pages/home/components/bar_recherche.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:flutter_application_proj2cp/config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static String routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _rated = true;
  String _comment = '';
   Map<String, dynamic> _userData = {};
   final defaultImageUrl = 'http://192.168.85.78:3000/imageClient/1714391607342.jpg';


   Future<void> _fetchUserData() async {
    final url = Uri.parse(
        'http://192.168.85.78:3000/client/Affichermonprofil'); // Replace with your endpoint
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

  void _onRatingAndCommentSubmit(int rating, String comment) {
    setState(() {
      _rated = false;
      _comment = _comment;
    });
  }

  String artisanName = 'Karim mouloud ';
  List<Widget> domainWidgets = [];
  List<Widget> ecoServiceWidgets = [];
  List<Widget> topPrestationWidgets = [];
  late String _token;

  @override
  void initState() {
    super.initState();
    if (!_rated) {
      Future.delayed(Duration.zero, () {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => RatingPopup(
            artisanName: artisanName,
            onSubmit: _onRatingAndCommentSubmit,
          ),
        );
      });
    }
    fetchData();
  }

  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? '';
    print('Token: $_token');
    await Future.wait([
      fetchDomaines(),
      fetchEcoServices(),
      fetchTopPrestations(),
      _fetchUserData()
    ]);
  }

  Future<void> fetchDomaines() async {
    final url =
        Uri.parse('http://192.168.85.78:3000/pageaccueil/AfficherDomaines');
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
        'http://192.168.85.78:3000/pageaccueil/AfficherPrestationsEco');
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
        print('Failed to fetch eco services: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
    } catch (error) {
      print('Error fetching eco services: $error');
    }
  }

  Future<void> fetchTopPrestations() async {
    final url = Uri.parse(
        'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/pageaccueil/AfficherPrestationsTop');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              HomeHeader(
                userName: _userData['Username'],
                profilePictureUrl: _userData['photo'] != null ? _userData['photo'] : defaultImageUrl,
                
              ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RatingPopup extends StatefulWidget {
  const RatingPopup(
      {Key? key, required this.artisanName, required this.onSubmit})
      : super(key: key);
  final String artisanName;

  final Function(int rating, String comment)
      onSubmit; // Function type for submission

  @override
  State<RatingPopup> createState() => _RatingPopupState();
}

class _RatingPopupState extends State<RatingPopup> {
  int _rating = 0;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Veuillez noter ',
              style: TextStyle(
                fontFamily: 'Lato', // Set font family to Lato
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 20, // Set weight to semi-bold
              ),
            ),
            TextSpan(
              text: widget.artisanName, // Artisan name
              style: TextStyle(
                color: Color(0xff05564B),
                fontFamily: 'Lato',
                fontWeight: FontWeight.w600,
                fontSize: 21, // Set color to 05564B
              ),
            ),
            TextSpan(
              text: ' qui a effectué la prestation',
              style: TextStyle(
                fontFamily:
                    'Lato', // Set font family to Lato (optional, for consistency)
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize:
                    20, // Set weight to semi-bold (optional, for consistency)
              ),
            ),
          ],
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 1; i <= 5; i++)
                IconButton(
                  icon: Icon(
                    (i <= _rating) ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 35,
                  ),
                  onPressed: () => setState(() => _rating = i),
                ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            width: 340,
            height: 56,
            decoration: BoxDecoration(
              color: Color(0xffF7F3F2), // Rectangle background color
              borderRadius:
                  BorderRadius.circular(10.0), // Beveled border radius
              border: Border.all(
                color: Color(0xff05564B), // Beveled border color
                width: 2.0, // Beveled border width
                style: BorderStyle.solid, // Beveled border style
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.all(16.0), // Padding within the rectangle
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Ajouter votre avis sur la prestation ',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xffD6E3DC),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Set corner radius
      ),
      actions: [
        Center(
          child: Container(
            decoration: BoxDecoration(
              color: _rating != 0
                  ? Color(0xffFF8787)
                  : Color(0xffFF8787)
                      .withOpacity(0.4), // Button color based on rating
              borderRadius:
                  BorderRadius.circular(15.0), // Beveled border radius
            ),
            child: TextButton(
              onPressed: _rating != 0
                  ? () {
                      // Submit with rating (comment optional)
                      widget.onSubmit(_rating, _commentController.text);
                      Navigator.pop(context);
                    }
                  : null, // Disable button if rating is empty
              child: Text(
                'Envoyer',
                style:
                    TextStyle(color: Colors.white), // Set text color to white
              ),
              style: TextButton.styleFrom(
                fixedSize: Size(150, 41), // Maintain button size
              ),
            ),
          ),
        ),
      ],
    );
  }
}

