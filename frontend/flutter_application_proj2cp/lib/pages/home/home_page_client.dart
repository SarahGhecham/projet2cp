import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/constants/constants.dart';
import 'package:flutter_application_proj2cp/pages/activite/activite_termine.dart';
import 'package:flutter_application_proj2cp/pages/home/components/home_header.dart';
import 'package:flutter_application_proj2cp/pages/home/components/service_populair_container.dart';
import 'package:flutter_application_proj2cp/pages/home/components/domain_container.dart';
import 'package:flutter_application_proj2cp/pages/home/search_delegate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:flutter_application_proj2cp/config.dart';
import 'dart:convert' as convert;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static String routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
// Assuming your backend API endpoint URL

  List<Prestation> allPrestations = [];
  List<Prestation> selectedPrestations = [];
  List<Prestation> recentPrestations = [];
  bool _rated = false;
  String commentaire = '';
  Map<String, dynamic> _userData = {};
  final defaultImageUrl =
      'http://192.168.54.173:3000/imageClient/1714391607342.jpg';

  Future<void> fetchAllPrestations() async {
    final url = Uri.parse(
        'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/pageaccueil/AfficherToutesPrestation');

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        print("fetched all Prestations");
        // Parse the JSON response
        List<dynamic> prestationsData = json.decode(response.body);
        print(prestationsData);
        setState(() {
          allPrestations = prestationsData.map((prestationData) {
            return Prestation(
              nom: prestationData['NomPrestation'] ?? '',
              materiel: prestationData['Matériel'] ?? '',
              dureeMax: prestationData['DuréeMax'] ?? '',
              dureeMin: prestationData['DuréeMin'] ?? '',
              tarifId: prestationData['TarifId'] ?? 0,
              domaineId: prestationData['domaineId'] ?? 0,
              ecologique: prestationData['Ecologique'] ?? false,
              image: prestationData['imagePrestation'] ?? '',
              description: prestationData['Description'] ?? '',
            );
          }).toList();
        });
      } else {
        print('Failed to fetch prestations');
      }
    } catch (error) {
      print('Error fetching prestations: $error');
    }
  }

  Future<void> creerEvaluation(
      double note, String commentaire, String token, int retrievedRdvId) async {
    // Define the endpoint URL where your backend is hosted
    const String url =
        'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/client/creerEvaluation';

    // Prepare the request body
    final Map<String, dynamic> requestBody = {
      'Note': note,
      'Commentaire': commentaire,
      'RDVId': retrievedRdvId,
    };

    try {
      // Make the HTTP POST request
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'Bearer $token', // Include the token in the Authorization header
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        print('Evaluation created successfully: ${jsonDecode(response.body)}');
      } else {
        print('Failed to create evaluation: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error creating evaluation: $error');
    }
  }

  Future<void> _fetchUserData() async {
    final url = Uri.parse(
        'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/client/Affichermonprofil'); // Replace with your endpoint
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

  void _onRatingAndCommentSubmit(
      double rating, String comment, int rdvId) async {
    final note = rating; // Convert rating to double
    final retrievedRdvId = rdvId; // Use the provided RDV ID
    // Use the provided artisan name

    try {
      await creerEvaluation(note, comment, _token, retrievedRdvId);
      // After successful evaluation submission, set _rated to true
      setState(() {
        _rated = true;
      });
    } catch (error) {
      // Handle error if evaluation submission fails
      print('Error submitting evaluation: $error');
    }
  }

  String Name = '';
  int retrievedRdvId = 0;
  Future<Map<String, dynamic>> fetchActiviteTermineeNonEvaluee(
      String token) async {
    final url = Uri.parse(
        'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/client/AfficherActiviteTermineeNonEvaluee');

    // Construct the request headers
    final headers = {
      'Authorization': 'Bearer $token'
    }; // Replace this with your endpoint

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        // If the request is successful, parse the response
        final List<dynamic> responseData =
            convert.jsonDecode(response.body) as List<dynamic>;

        if (responseData.isEmpty) {
          setState(() {
            _rated = true;
          });
          print('No data available');
          return {}; // or return null or throw an exception as per your requirement
        }

        final Map<String, dynamic> item =
            responseData.isNotEmpty ? responseData.first : {};

        final demande = item['demande'] as Map<String, dynamic>?;
        final rdvAffich = item['rdvAffich'] as Map<String, dynamic>?;
        final List<dynamic>? artisans = demande?['Artisans'] as List<dynamic>?;

        // Check if demande is null
        final rdvId = rdvAffich!['rdvId'] as int;
        retrievedRdvId = rdvId;
        print(' RDV ID: $rdvId');

        // Check if artisan is null
        if (artisans != null) {
          // Access artisan details
          Name = artisans[0]['NomArtisan'];
          print('name: $Name');

          // Use artisanName as needed
        } else {
          // Handle null artisan
          print('Artisan is null');
        }

        if (rdvId == null) {
          setState(() {
            _rated = true;
          });
        } else {
          retrievedRdvId = rdvId;
        }

        // Print name and rdvId
        print(' RDV ID: $rdvId');

        // Return the first item as a map
        return {'rdvId': rdvId};
      } else {
        // If the request fails, throw an exception
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (error) {
      // If any error occurs during the process, handle it here
      print('Error fetching data: $error');
      return {}; // or throw error as per your requirement
    }
  }

  List<Widget> domainWidgets = [];
  List<Widget> ecoServiceWidgets = [];
  List<Widget> topPrestationWidgets = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void handleSearch(List<Prestation> filteredPrestations) {
    print('Received filtered prestations: $filteredPrestations');
    setState(() {
      selectedPrestations = filteredPrestations;
    });
  }

  String _token = '';
  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? '';
    print('Token: $_token');
    await Future.wait([
      fetchDomaines(),
      fetchEcoServices(),
      fetchTopPrestations(),
      _fetchUserData(),
      fetchAllPrestations(),
      fetchActiviteTermineeNonEvaluee(_token),
    ]);
    showRatingDialog();
  }

  void showRatingDialog() {
    if (!_rated) {
      final rdvId = retrievedRdvId;
      final artisanName = Name;
      setState(() {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => RatingPopup(
            artisanName: artisanName,
            rdvId: rdvId,
            onSubmit: _onRatingAndCommentSubmit,
          ),
        );
      });
    }
  }

  Future<void> fetchDomaines() async {
    final url = Uri.parse(
        'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/pageaccueil/AfficherDomaines');
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
                    Description: serviceJson['Matériel'] as String,
                    dureeMax: serviceJson['DuréeMax'] as String,
                    dureeMin: serviceJson['DuréeMin'] as String,
                    tarifId: serviceJson['TarifId'] as int,
                    domaineId: serviceJson['DomaineId'] as int,
                    ecologique: serviceJson['Ecologique'] as bool,
                    image: imageUrl,
                    tarifJourMin:
                        serviceJson['Tarif']['TarifJourMin'] as String,
                    tarifJourMax:
                        serviceJson['Tarif']['TarifJourMax'] as String,
                    Unite: serviceJson['Tarif']['Unité'] as String);
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
                    tarifJourMin:
                        serviceJson['Tarif']['TarifJourMin'] as String,
                    tarifJourMax:
                        serviceJson['Tarif']['TarifJourMax'] as String,
                    Unite: serviceJson['Tarif']['Unité'] as String);
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
                userName:
                    _userData['Username'] ?? '', // Use empty string if null
                profilePictureUrl: _userData['photo'] != null
                    ? _userData['photo'] as String
                    : defaultImageUrl,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: SizedBox(
                  height: 40,
                  child: GestureDetector(
                      onTap: () => {
                            showSearch(
                              context: context,
                              delegate: DataSearch(
                                  prestations: allPrestations,
                                  recentPrestations: recentPrestations),
                            ),
                          },
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: vertClair,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 4,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset('assets/icons/recherche.png'),
                            ),
                            Text(
                              'Rechercher une prestation...',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              ),
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
  const RatingPopup({
    Key? key,
    required this.artisanName,
    required this.rdvId,
    required this.onSubmit,
  }) : super(key: key);

  final String artisanName;
  final int rdvId;
  final Function(double rating, String comment, int rdvId) onSubmit;

  @override
  State<RatingPopup> createState() => _RatingPopupState();
}

class _RatingPopupState extends State<RatingPopup> {
  double _rating = 0;
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
              for (double i = 1; i <= 5; i++)
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
                      widget.onSubmit(
                          _rating, _commentController.text, widget.rdvId);
                      print(widget.rdvId);
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
/* import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/drawer_services.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/drawer_users.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CreerArtisan extends StatefulWidget {
  const CreerArtisan({Key? key}) : super(key: key);

  @override
  State<CreerArtisan> createState() => _CreerArtisanState();
}

class _CreerArtisanState extends State<CreerArtisan> {
  final _nomArtisanController = TextEditingController();
  final _prenomArtisanController = TextEditingController();
  List<Map<String, dynamic>> _domainesOptions = [];
  List<String> _prestationsOptions = [];

  String? _selectedDomaine;
  int? _selectedDomaineId;
  late String _token;

  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? '';
    print('Token: $_token');
    await fetchDomaines();
  }

  Future<void> fetchDomaines() async {
    final url = Uri.parse('http://10.0.2.2:3000/pageaccueil/AfficherDomaines');
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        print("Fetching domaines successful");
        // Decode JSON response
        List<dynamic> data = jsonDecode(response.body);

        setState(() {
          // Extract NomDomaine and DomaineId values from the fetched data
          _domainesOptions = data.map<Map<String, dynamic>>((domaine) {
            return {
              'NomDomaine': domaine['NomDomaine'] as String,
              'DomaineId': domaine['id'] as int,
            };
          }).toList();
        });
      } else {
        // Handle HTTP error
        print('Failed to load domaines: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network or decoding errors
      print('Error fetching domaines: $error');
    }
  }

  Future<void> fetchPrestationsByDomaine(int domaineId) async {
    final url = Uri.parse('http://10.0.2.2:3000/prestations/domaines/$domaineId');
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        print("Fetching prestations for domaine $domaineId successful");
        // Decode JSON response
        List<dynamic> data = jsonDecode(response.body);

        setState(() {
          // Extract NomPrestation values from the fetched data and cast to String
          _prestationsOptions = data.map<String>((prestation) => prestation['NomPrestation'] as String).toList();
        });
      } else {
        // Handle HTTP error
        print('Failed to load prestations for domaine $domaineId: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network or decoding errors
      print('Error fetching prestations for domaine $domaineId: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DrawerUsers(),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 20),
              child: Text(
                'Ajouter un artisan',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Dropdown for selecting Domaine
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: DropdownButton<Map<String, dynamic>>(
                value: _selectedDomaineId != null
                    ? _domainesOptions.firstWhere((domaine) => domaine['DomaineId'] == _selectedDomaineId)
                    : null,
                hint: Text("Sélectionnez un domaine"),
                items: _domainesOptions.map((domaine) {
                  return DropdownMenuItem<Map<String, dynamic>>(
                    value: domaine,
                    child: Text(domaine['NomDomaine'] as String),
                  );
                }).toList(),
                onChanged: (selectedDomaine) {
                  setState(() {
                    _selectedDomaine = selectedDomaine!['NomDomaine'] as String;
                    _selectedDomaineId = selectedDomaine['DomaineId'] as int;
                    _prestationsOptions = []; // Clear prestations options when selecting a new domaine
                  });
                  fetchPrestationsByDomaine(_selectedDomaineId!); // Fetch prestations for selected domaine
                },
              ),
            ),
            // Dropdown for selecting Prestation
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: DropdownButton<String>(
                value: null,
                hint: Text("Sélectionnez une prestation"),
                items: _prestationsOptions.map((prestation) {
                  return DropdownMenuItem<String>(
                    value: prestation,
                    child: Text(prestation),
                  );
                }).toList(),
                onChanged: (selectedPrestation) {
                  setState(() {
                    // Handle selected prestation
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
