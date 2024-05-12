import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_proj2cp/config.dart';
import 'package:flutter_application_proj2cp/pages/artisan/commentaire_artisan.dart';
import 'package:flutter_application_proj2cp/parametre.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:table_calendar/table_calendar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class ProfileartisanPage extends StatefulWidget {
  const ProfileartisanPage({super.key});

  @override
  _ProfileartisanPageState createState() => _ProfileartisanPageState();
}

class _ProfileartisanPageState extends State<ProfileartisanPage> {
  @override
  var note = "";
  var domaine = "";
  final _debutController = TextEditingController();
  final _finController = TextEditingController();
  final _NomController = TextEditingController();
  final _PrenomController = TextEditingController();
  final _EmailController = TextEditingController();
  final _PhoneController = TextEditingController();
  final _RayonController = TextEditingController();
  final _AdresseController = TextEditingController();
  final jourController = TextEditingController();
  List<dynamic> _predictions = [];
  bool _showSuggestions = true;

  @override
  void _searchPlaces(String input) async {
    const apiKey = 'AIzaSyBUoTHDCzxA7lix93aS8D5EuPa-VCuoAq0';
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=(cities)&key=$apiKey&language=fr';

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    setState(() {
      _predictions = data['predictions'];
    });
  }
  int day = 0;
  late String _token;
  Map<String, dynamic> _userData = {};

  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? '';
    print('Token: $_token');
    await Future.wait([_fetchUserData()]);
  }

  Future<void> _fetchUserData() async {
    final url = Uri.parse(
        'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/artisan/Affichermonprofil'); // Replace with your endpoint
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $_token'},
      );
      print("ufhquwefhuweghwuegwug");
      if (response.statusCode == 200) {
        final userDataJson = json.decode(response.body);
        print("llllllllllllllllllllllllllllllll");

        if (userDataJson != null) {
          print("ppppppppppppppppppppp");

          setState(() {
            print("kikkkkkkkkkkkkkkkkkkkkkkkkkkk");

            _userData = {
              'Nom': userDataJson['NomArtisan'] as String ?? '',
              'Prenom': userDataJson['PrenomArtisan'] as String ?? '',
              'Email': userDataJson['EmailArtisan'] as String ?? '',
              'Numero': userDataJson['NumeroTelArtisan'] as String ?? '',
              'Rayon': userDataJson['RayonKm']  ?? '', // Assuming 'RayonKm' is a string
              'Adresse': userDataJson['AdresseArtisan']  ?? '',
              'photo': userDataJson['photo'] ?? '',
              'Disponibilite': userDataJson['Disponibilite'] as bool, // Assuming 'Disponibilite' is not a string
              'Note': userDataJson['Note'] ?? '',
              'Domaine': userDataJson['Domaine'] as String ?? '', // Assuming 'Domaine' is a string
              'Prestations': userDataJson['Prestations'] as List<dynamic> ?? [],
            };
            print("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");

            _NomController.text = _userData['Nom'] ?? '';
            _PrenomController.text = _userData['Prenom'] ?? '';
            _EmailController.text = _userData['Email'] ?? '';
            _PhoneController.text = _userData['Numero'] ?? '';
            _AdresseController.text = _userData['Adresse'] ;
            _RayonController.text = _userData['Rayon'] ;
            _pickedImagePath = _userData['photo'] ?? '';
            _dispo(_userData['Disponibilite']);
            note = _userData['Note'] ?? '';
            domaine = _userData['Domaine'] ?? '';
            fetchHoraires();
          });
          print('_userData: $_userData'); // Debugging print
        } else {
          print('userDataJson is null');
        }
      } else {
        print('Failed to fetch user data');
        print('Response Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  void _saveChanges() {

    _userData['Numero'] = _PhoneController.text.isNotEmpty
        ? _PhoneController.text
        : _userData['Numero'];

    _userData['Rayon'] = _RayonController.text.isNotEmpty
        ? _RayonController.text
        : _userData['Rayon'];

    _userData['Adresse'] = _AdresseController.text.isNotEmpty
        ? _AdresseController.text
        : _userData['Adresse'];

    _userData['Disponibilite'] = dispo;

    _userData['photo'] = _pickedImagePath;
  }



  Future<void> updateArtisanImage(File image) async {
    // Replace "http://localhost:3000" with your server URL
    String baseUrl =
        "http://${AppConfig.serverAddress}:${AppConfig.serverPort}";

    // Construct the endpoint URL
    String endpoint = "$baseUrl/artisan/updateArtisanImage";

    try {
      // Create a multipart request
      var request = http.MultipartRequest('POST', Uri.parse(endpoint));
      print(image.path);

      // Attach the image file to the request
      request.files.add(await http.MultipartFile.fromPath('image', image.path));

      // Add Authorization header with token
      request.headers['Authorization'] = 'Bearer $_token';

      // Send the request and await the response
      var streamedResponse = await request.send();

      // Close the response stream after using it
      streamedResponse.stream.listen((value) {}).cancel();

      // Get the response from the streamedResponse
      var response = await http.Response.fromStream(streamedResponse);

      // Check the response status
      if (response.statusCode == 200) {
        // Image uploaded successfully, parse the response
        var data = jsonDecode(response.body);

        if (data['success'] == true) {
          // Client image updated successfully
          print('Client image updated successfully');
        } else {
          // Image upload failed
          print('Failed to update client image: ${data['message']}');
        }
      } else {
        // Request failed
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle errors
      print('Error: $e');
    }
  }

  Future<void> updateArtisan(Map<String, dynamic> updatedData) async {
    final url = Uri.parse(
        'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/artisan/updateartisan'); // Replace with your endpoint
    try {
      final response = await http.patch(
        url,
        body: json.encode({
          'AdresseArtisan': updatedData['Adresse'],
          'NumeroTelArtisan': updatedData['Numero'],
          'Disponibilite': updatedData['Disponibilite'],
          'RayonKm': updatedData['Rayon'],
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token'
        },
      );

      if (response.statusCode == 200) {
        print('User data updated successfully');
        _fetchUserData();
      } else {
        print('Failed to update user data');
        print('Response Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
    } catch (error) {
      print('Error updating user data: $error');
    }
  }
  final ImagePicker _imagePicker = ImagePicker();

  var _pickedImagePath = null;
  @override
  void initState() {
    super.initState();
    fetchData();
    day = 0; // Set initial day to 0
  }
  bool dispo = true;

  void _dispo(bool value) {
    setState(() {
      dispo= value;
    });
  }
  void changeDayValue(int newValue) {
    setState(() {
      day = newValue;
      switch (day) {
        case 0:
          jourController.text = 'dimanche';
        case 1:
          jourController.text = 'Lundi';
        case 2:
          jourController.text = 'Mardi';
        case 3:
          jourController.text = 'Mercredi';
        case 4:
          jourController.text = 'Jeudi';
        case 5:
          jourController.text = 'Vendredi';
        case 6:
          jourController.text = 'Samedi';
        default:
          jourController.text = 'dimanche';
      }
    }
    );
  }

  bool _isEditing = false;

  void _toggleEditing(bool value) {
    setState(() {
      _isEditing = value;
    });
  }

  bool _showOngoing = true;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  List<DateTime> highlightedDates = [
    DateTime(2024, 4, 27),
    DateTime(2024, 4, 28),
    DateTime(2024, 4, 29),
  ];
  Future<List<Map<String, dynamic>>> getArtisanHorairesByJour(String jour) async {
    try {
      // Endpoint URL for your backend API
      final String apiUrl = 'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/artisanjour/HorairesJour/$jour';

      // Request body
      final Map<String, dynamic> body = {'jour': jour};

      // Make POST request to the backend API
      final response = await http.get(Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token'
        },
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Parse the response JSON
        List<dynamic> responseData = json.decode(response.body);

        // Convert response data to List<Map<String, dynamic>>
        List<Map<String, dynamic>> horaires = responseData.map((item) {
          return {
            'heureDebut': item['heureDebut'],
            'heureFin': item['heureFin'],
          };
        }).toList();

        return horaires;
      } else {
        // If the request was not successful, throw an error
        throw Exception('Failed to load horaires by jour');
      }
    } catch (error) {
      // Catch any error that occurs during the process
      throw Exception('Failed to load horaires by jour: $error');
    }
  }

  void fetchHoraires() async {
    String jour = 'mercredi'; // Replace with the desired jour
    try {
      List<Map<String, dynamic>> horaires = await getArtisanHorairesByJour(jour);
      // Do something with the horaires
      print('Horaires: $horaires');
    } catch (error) {
      // Handle errors
      print('Error fetching horaires: $error');
    }
  }


  int selectedDayIndex = 0;
  Map<int, Map<TimeOfDay, TimeOfDay>> allHoraires = {
    0: {
      // horaire0
      TimeOfDay(hour: 10, minute: 30): TimeOfDay(hour: 11, minute: 30),
      TimeOfDay(hour: 13, minute: 30): TimeOfDay(hour: 16, minute: 00),
    },
    1: {
      // horaire1
      TimeOfDay(hour: 8, minute: 00): TimeOfDay(hour: 9, minute: 30),
      TimeOfDay(hour: 14, minute: 00): TimeOfDay(hour: 17, minute: 00),
    },
    2: {
      // horaire2
      TimeOfDay(hour: 8, minute: 00): TimeOfDay(hour: 9, minute: 30),
      TimeOfDay(hour: 14, minute: 00): TimeOfDay(hour: 17, minute: 00),
    },
    3: {
      // horaire3
      TimeOfDay(hour: 8, minute: 00): TimeOfDay(hour: 9, minute: 30),
      TimeOfDay(hour: 14, minute: 00): TimeOfDay(hour: 17, minute: 00),
    },
    4: {
      // horaire4
      TimeOfDay(hour: 8, minute: 00): TimeOfDay(hour: 9, minute: 30),
      TimeOfDay(hour: 14, minute: 00): TimeOfDay(hour: 17, minute: 00),
    },
    5: {
      // horaire5
      TimeOfDay(hour: 8, minute: 00): TimeOfDay(hour: 9, minute: 30),
      TimeOfDay(hour: 14, minute: 00): TimeOfDay(hour: 17, minute: 00),
    },
    6: {
      // horaire6
      TimeOfDay(hour: 9, minute: 00): TimeOfDay(hour: 3, minute: 20),
      TimeOfDay(hour: 1, minute: 00): TimeOfDay(hour: 18, minute: 00),
    },
  };
  /*Future<void> addJourToArtisan() async {

    final url = Uri.parse('http://${AppConfig.serverAddress}:${AppConfig.serverPort}/artisan/${widget.artisanId}')
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // Add any required headers here, such as authorization token
        },
        body: jsonEncode(<String, dynamic>{
          'jour': jourController.text,
          'HeureDebut': _debutController.text,
          'HeureFin': _finController.text,
        }),
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        print(responseData['message']);
        // Handle successful response, if needed
      } else {
        // Handle error responses
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network errors
      print('Error fetching data: $error');
    }
  }
*/

  String _formatTime(TimeOfDay time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  void removeTimeRange(int day, TimeOfDay startTime, TimeOfDay endTime) {
    setState(() {
      allHoraires[day]?.removeWhere((key, value) =>
      (key.hour == startTime.hour && key.minute == startTime.minute) &&
          (value.hour == endTime.hour && value.minute == endTime.minute));
    });
  }

  void addTimeRange(int day, TimeOfDay startTime, TimeOfDay endTime) {
    setState(() {
      if (allHoraires[day] == null) {
        // Day doesn't exist in the map yet, create a new Map for it
        allHoraires[day] = {};
      }

      allHoraires[day]![startTime] = endTime;
    });
  }

  TimeOfDay stringToTimeOfDay(String timeString) {
    // Split the string at the colon (":")
    List<String> parts = timeString.split(":");

    // Ensure we have two parts (hour and minute)
    if (parts.length != 2) {
      throw FormatException("Invalid time format. Expected 'HH:MM'.");
    }

    // Parse hour and minute as integers
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    // Validate hour (0-23) and minute (0-59)
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      throw FormatException(
          "Invalid time values. Hour must be between 0 and 23, and minute must be between 0 and 59.");
    }

    // Return the TimeOfDay object
    return TimeOfDay(hour: hour, minute: minute);
  }


  Widget build(BuildContext context) {
    Map<TimeOfDay, TimeOfDay> currentHoraire = allHoraires[day] ?? {};
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: SizedBox(
              width: 32,
              height: 32,
              child: Image.asset('assets/images/settings.png'),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => parametrePage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    if (_isEditing) {
                      final picker = ImagePicker();
                      final pickedFile = await picker.getImage(
                        source: ImageSource.gallery,
                      );

                      if (pickedFile != null) {
                        setState(() {
                          File imageFile = File(pickedFile.path);
                          _pickedImagePath= imageFile.path;
                          _saveChanges();
                          updateArtisanImage(imageFile);
                        });
                      }
                    }
                  },
                  child: Container(
                    width: 150,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.grey[200],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: _userData['photo'] != null
                          ? Image.network(
                        _userData[
                        'photo'].toString(), // Utilisez l'URL de la photo de profil
                        fit: BoxFit.cover,
                      )
                          : Image.asset(
                        'assets/artisan.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Note",
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF05564B)),
                  ),
                  Row(
                    children: [
                      SvgPicture.asset("assets/star.svg"),
                      Text(
                        note.toString(),
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF05564B)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Disponibilité",
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF05564B)),
                  ),
                  GestureDetector(
                    onTap: (){
                      if(dispo){
                        _dispo(false);
                        _saveChanges();
                        updateArtisan(_userData);
                      }else{
                        _dispo(true);
                        _saveChanges();
                        updateArtisan(_userData);
                      }
                    },
                    child: Container(
                      height: 30,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFFF7F3F2),
                        border: Border.all(color: Color(0xFF05564B)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 15,
                            width: 15,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: dispo ? Color(0xFF15AC3F) : Colors.red,
                            ),
                          ),
                          Text(
                            dispo ? "Disponible" : "hors",
                            style: GoogleFonts.poppins(
                                fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Domaine",
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF05564B)),
                  ),
                  Container(
                    height: 30,
                    width: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFF7F3F2),
                      border: Border.all(color: Color(0xFF05564B)),
                    ),
                    child: Center(
                      child: Text(
                        domaine,
                        style: GoogleFonts.poppins(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Color(0xFFD6E3DC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        content: Container(
                          width:
                          200.0, // Adjust the width as needed
                          height:
                          150.0, // Adjust the height as needed
                          child: Center(
                            child: ListView.builder(
                              itemCount: _userData['Prestations'].length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(_userData['Prestations'][index], style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700),),
                                  // You can add more customization here if needed
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    });

              },
              style: ButtonStyle(
                minimumSize:
                MaterialStateProperty.all<Size>(const Size(315, 30)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                backgroundColor:
                MaterialStateProperty.all<Color>(const Color(0xFFFF8787)),
              ),
              child: Text(
                "Préstations proposées",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Informations personnelles",
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF05564B)),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Nom",
                  style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 400,
                  height: 41,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCC8C5).withOpacity(0.22),
                    border: Border.all(
                      color: const Color(0xFFDCC8C5),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _isEditing
                      ? TextFormField(
                    controller: _NomController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Nom",
                      hintStyle: GoogleFonts.poppins(
                        color: const Color(0xFF777777),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 16.0,
                      ),
                      border: InputBorder.none,
                    ),
                  )
                      : Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16.0),
                    child: Text(
                      _userData['Nom'].toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Prénom",
                  style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 400,
                  height: 41,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCC8C5).withOpacity(0.22),
                    border: Border.all(
                      color: const Color(0xFFDCC8C5),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _isEditing
                      ? TextFormField(
                    controller: _PrenomController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Prénom",
                      hintStyle: GoogleFonts.poppins(
                        color: const Color(0xFF777777),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 16.0,
                      ),
                      border: InputBorder.none,
                    ),
                  )
                      : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
                    child: Text(
                      _userData['Prenom'].toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),

                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Numéro de téléphone",
                  style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 400,
                  height: 41,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCC8C5).withOpacity(0.22),
                    border: Border.all(
                      color: const Color(0xFFDCC8C5),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _isEditing
                      ? TextFormField(
                    controller: _PhoneController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Numéro Téléphone",
                      hintStyle: GoogleFonts.poppins(
                        color: const Color(0xFF777777),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 16.0,
                      ),
                      border: InputBorder.none,
                    ),
                  )
                      : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
                    child: Text(
                      _userData['Numero'].toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Email",
                  style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 400,
                  height: 41,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCC8C5).withOpacity(0.22),
                    border: Border.all(
                      color: const Color(0xFFDCC8C5),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _isEditing
                      ? TextFormField(
                    controller: _EmailController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Email",
                      hintStyle: GoogleFonts.poppins(
                        color: const Color(0xFF777777),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 16.0,
                      ),
                      border: InputBorder.none,
                    ),
                  )
                      : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
                    child: Text(
                      _userData['Email'].toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Adresse",
                  style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 400,
                  height: 41,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCC8C5).withOpacity(0.22),
                    border: Border.all(
                      color: const Color(0xFFDCC8C5),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _isEditing
                      ? TextFormField(
                      controller: _AdresseController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: "Adresse",
                        hintStyle: GoogleFonts.poppins(
                          color: const Color(0xFF777777),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 16.0,
                        ),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          _searchPlaces(value);
                          setState(() {
                            _showSuggestions =
                            true; // Show suggestions when typing
                          });
                        } else {
                          setState(() {
                            _showSuggestions = false; //
                          });
                        }
                      }
                  )
                      : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
                    child: Text(
                      _userData['Adresse'].toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: _showSuggestions,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      color: Color(0xFFDCC8C5),
                      thickness: 2.0,
                    );
                  },
                  shrinkWrap: true,
                  itemCount: _predictions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        _predictions[index]["description"],
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                        ),
                      ),
                      onTap: () {
                        _AdresseController.text = _predictions[index]["description"];
                        setState(() {
                          _showSuggestions = false;
                        });
                      },
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Rayon géographique",
                  style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 400,
                  height: 41,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCC8C5).withOpacity(0.22),
                    border: Border.all(
                      color: const Color(0xFFDCC8C5),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _isEditing
                      ? TextFormField(
                    controller: _RayonController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Rayon géographique",
                      hintStyle: GoogleFonts.poppins(
                        color: const Color(0xFF777777),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 16.0,
                      ),
                      border: InputBorder.none,
                    ),
                  )
                      : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
                    child: Text(
                      _userData['Rayon'].toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        if (_isEditing) {
                          _saveChanges();
                          updateArtisan(_userData);
                          _toggleEditing(false);
                        } else {
                          _toggleEditing(true);
                        }
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(
                            const Size(100, 35)),
                        shape:
                        MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFFFF8787)),
                      ),
                      child: Text(
                        _isEditing ? "Valider" : "Editer",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CommentPage()),
                        );
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(
                            const Size(150, 35)),
                        shape:
                        MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFF05564B)),
                      ),
                      child: Text(
                        "Commentaires",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PreferredSize(
                  preferredSize: Size.fromHeight(70.0),
                  child: SizedBox(
                    width: 270,
                    height: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFDCC8C5).withOpacity(0.22),
                        border:
                        Border.all(color: Color(0xFFDCC8C5), width: 1.5),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _showOngoing = false;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: _showOngoing
                                    ? Color(0xFF05564B)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 35, vertical: 5),
                              child: Text(
                                'RDV',
                                style: TextStyle(
                                  color: _showOngoing
                                      ? Colors.white
                                      : Color(0xFFDCC8C5).withOpacity(0.22),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _showOngoing = true;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: !_showOngoing
                                    ? Color(0xFF05564B)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 35, vertical: 5),
                              child: Text(
                                'Horaires',
                                style: TextStyle(
                                  color: !_showOngoing
                                      ? Colors.white
                                      : Color(0xFFDCC8C5).withOpacity(0.22),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Visibility(
              visible: _showOngoing,
              child: Container(
                height: 400,
                width: 335,
                decoration: BoxDecoration(
                  color: const Color(0xFFD6E3DC),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TableCalendar(
                  locale: 'en_US',
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (DateTime date) {
                    // Return true if the date is in the list of highlightedDates, false otherwise
                    return highlightedDates.contains(date);
                  },
                  calendarStyle: CalendarStyle(
                    defaultTextStyle:
                    GoogleFonts.poppins(fontSize: 16, color: Colors.black),
                    selectedDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFF8787),
                    ),
                    todayDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFF8787).withOpacity(0.22),
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  availableGestures: AvailableGestures.all,
                  focusedDay: _focusedDay,
                  firstDay: DateTime(2010, 10, 16),
                  lastDay: DateTime(2030, 3, 14),
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  },
                ),
              ),
            ),
            Visibility(
              visible: !_showOngoing,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          changeDayValue(0);
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: day == 0
                                ? Color(0xFF05564B)
                                : Color(0xFFD6E3DC),
                          ),
                          child: Center(
                            child: Text(
                              "Dim",
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          changeDayValue(1);
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: day == 1
                                ? Color(0xFF05564B)
                                : Color(0xFFD6E3DC),
                          ),
                          child: Center(
                              child: Text(
                                "Lun",
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          changeDayValue(2);
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: day == 2
                                ? Color(0xFF05564B)
                                : Color(0xFFD6E3DC),
                          ),
                          child: Center(
                              child: Text(
                                "Mar",
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          changeDayValue(3);
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: day == 3
                                ? Color(0xFF05564B)
                                : Color(0xFFD6E3DC),
                          ),
                          child: Center(
                              child: Text(
                                "Mer",
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          changeDayValue(4);
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: day == 4
                                ? Color(0xFF05564B)
                                : Color(0xFFD6E3DC),
                          ),
                          child: Center(
                              child: Text(
                                "Jeu",
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          changeDayValue(5);
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: day == 5
                                ? Color(0xFF05564B)
                                : Color(0xFFD6E3DC),
                          ),
                          child: Center(
                              child: Text(
                                "Ven",
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          changeDayValue(6);
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: day == 6
                                ? Color(0xFF05564B)
                                : Color(0xFFD6E3DC),
                          ),
                          child: Center(
                              child: Text(
                                "Sam",
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Column(
                    children: currentHoraire.entries.map((entry) {
                      TimeOfDay startTime = entry.key;
                      TimeOfDay endTime = entry.value;

                      String formattedStartTime = _formatTime(startTime);
                      String formattedEndTime = _formatTime(endTime);

                      return Container(
                          padding:
                          EdgeInsets.all(16.0), // Adjust padding as needed
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$formattedStartTime',
                                style: GoogleFonts.poppins(fontSize: 16),
                              ),
                              SizedBox(width: 30),
                              SvgPicture.asset("assets/line.svg"),
                              SizedBox(width: 30),
                              Text(
                                '$formattedEndTime',
                                style: GoogleFonts.poppins(fontSize: 16),
                              ),
                              SizedBox(width: 40),
                              GestureDetector(
                                  onTap: () {
                                    removeTimeRange(day, startTime, endTime);
                                  },
                                  child: SvgPicture.asset("assets/remove.svg")),
                            ],
                          ));
                    }).toList(),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Color(0xFFD6E3DC),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    content: Container(
                                      width:
                                      280.0, // Adjust the width as needed
                                      height:
                                      290.0, // Adjust the height as needed
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: <Widget>[
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 30.0),
                                            child: Center(
                                                child: Text(
                                                  "Rentrez Votre nouvelle horaire",
                                                  style: GoogleFonts.poppins(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 20),
                                                )),
                                          ),
                                          SizedBox(height: 20),
                                          Container(
                                            width: 100,
                                            height: 41,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              border: Border.all(
                                                color: const Color(0xFF05564B),
                                                width: 2,
                                              ),
                                              borderRadius:
                                              BorderRadius.circular(10),
                                            ),
                                            child: TextFormField(
                                              controller: _debutController,
                                              keyboardType:
                                              TextInputType.datetime,
                                              decoration: InputDecoration(
                                                hintText: "10:30",
                                                hintStyle: GoogleFonts.poppins(
                                                  color:
                                                  const Color(0xFF000000),
                                                ),
                                                contentPadding:
                                                const EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 16.0,
                                                ),
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Container(
                                            width: 100,
                                            height: 41,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              border: Border.all(
                                                color: const Color(0xFF05564B),
                                                width: 2,
                                              ),
                                              borderRadius:
                                              BorderRadius.circular(10),
                                            ),
                                            child: TextFormField(
                                              controller: _finController,
                                              keyboardType:
                                              TextInputType.datetime,
                                              decoration: InputDecoration(
                                                hintText: "16:00",
                                                hintStyle: GoogleFonts.poppins(
                                                  color:
                                                  const Color(0xFF000000),
                                                ),
                                                contentPadding:
                                                const EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 16.0,
                                                ),
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          ElevatedButton(
                                            onPressed: () {
                                              String start =
                                                  _debutController.text;
                                              String fin = _finController.text;
                                              TimeOfDay starting =
                                              stringToTimeOfDay(start);
                                              TimeOfDay ending =
                                              stringToTimeOfDay(fin);
                                              addTimeRange(
                                                  day, starting, ending);
                                              print("done");
                                            },
                                            style: ButtonStyle(
                                              minimumSize: MaterialStateProperty
                                                  .all<Size>(
                                                  const Size(115, 35)),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                ),
                                              ),
                                              backgroundColor:
                                              MaterialStateProperty.all<
                                                  Color>(
                                                  const Color(0xFF05564B)),
                                            ),
                                            child: Text(
                                              "Valider",
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: SvgPicture.asset("assets/add.svg")),
                    ],
                  ),
                  SizedBox(height: 90),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}