import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_proj2cp/config.dart';
import 'package:intl/intl.dart';

class rdvterminee extends StatefulWidget {
  final int demandeID;
  final int rdvID;
  @override
  const rdvterminee({
    Key? key,
    required this.demandeID,
    required this.rdvID,
  }) : super(key: key);

  @override
  State<rdvterminee> createState() => _rdvtermineeState();
}

class _rdvtermineeState extends State<rdvterminee> {
  late String _token;
  Map<String, dynamic> data = {};
  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? '';
    print('Token: $_token');
    await Future.wait([_fetchUserData()]);
  }



  Future<void> _fetchUserData() async {
    final url = Uri.parse(
        'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/artisan/DetailsRDVTermine/${widget.rdvID}');
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        setState(() {
          final responseData = json.decode(response.body);

          // Artisan data
          final artisanData =
          responseData != null ? responseData['client'] ?? {} : {};
          final client = {
            'Username': artisanData != null ? artisanData['Username'] ?? '' : '',
            'Photo': artisanData != null ? artisanData['photo'] ?? '' : '',
            'Numero': artisanData != null ? artisanData['NumeroTelClient'] ?? '' : '',
          };

// RDV affich data
          final rdvAffichData =
          responseData != null ? responseData['rdvAffich'] ?? {} : {};
          String dateDebutString =
          rdvAffichData != null ? rdvAffichData['DateDebut'] ?? '' : '';
          String heureDebutString =
          rdvAffichData != null ? rdvAffichData['HeureDebut'] ?? '' : '';

          String formattedDateDebut = '';
          String formattedHeureDebut = '';

          if (dateDebutString.isNotEmpty) {
            // Parse date string to DateTime object
            DateTime dateDebut = DateTime.parse(dateDebutString);

            // Format the date into 'dd/MM/yyyy' format
            formattedDateDebut =
                DateFormat('dd/MM/yyyy HH:mm').format(dateDebut);
          }

          if (heureDebutString.isNotEmpty) {
            // Convert time string to TimeOfDay object
            TimeOfDay heureDebut = TimeOfDay.fromDateTime(
                DateFormat('HH:mm:ss').parse(heureDebutString));

            // Format the TimeOfDay object into 'HH:mm' format
            formattedHeureDebut =
                heureDebut.format(context); // context is your BuildContext
          }

          final rdvAffich = {
            'date': formattedDateDebut,
            'heure': formattedHeureDebut,
          };

// Prestation data
          final prestationData =
          responseData != null ? responseData['prestation'] ?? {} : {};
          final prestation = {
            'Nom': prestationData != null ? prestationData['Nom'] ?? '' : '',
            'Materiel':
            prestationData != null ? prestationData['Materiel'] ?? '' : '',
            'DureeMax':
            prestationData != null ? prestationData['DureeMax'] ?? '' : '',
            'DureeMin':
            prestationData != null ? prestationData['DureeMin'] ?? '' : '',
            'Ecologique': prestationData != null
                ? prestationData['Ecologique'] ?? ''
                : '',
            'Image':
            prestationData != null ? prestationData['Image'] ?? '' : '',
            'TarifJourMin': prestationData != null
                ? prestationData['TarifJourMin'] ?? ''
                : '',
            'TarifJourMax': prestationData != null
                ? prestationData['TarifJourMax'] ?? ''
                : '',
          };

// Demande affich data
          final demandeAffichData =
          responseData != null ? responseData['demandeAffich'] ?? {} : {};
          final demandeAffich = {
            'Description': demandeAffichData != null
                ? demandeAffichData['Description'] ?? ''
                : '',
            'Localisation': demandeAffichData != null
                ? demandeAffichData['Localisation'] ?? ''
                : '',
            'Urgent': demandeAffichData != null
                ? demandeAffichData['Urgente'] ?? ''
                : '',
          };

// Combine all data
          data = {
            'client': client,
            'rdvAffich': rdvAffich,
            'prestation': prestation,
            'demandeAffich': demandeAffich,
          };
        });
        print('_userData: $data'); // Debugging print
      } else {
        print('Failed to fetch user data');
        print('Response Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  /* Future<void> _fetchUserData() async {
    final url = Uri.parse(
        'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/client/DetailsDemandeConfirmee/${widget.rdvID}'); // Replace with your endpoint
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        setState(() {
          final responseData = json.decode(response.body);
          data = {
            'artisan': {
              'Nom': responseData['artisan']['NomArtisan'],
              'Prenom': responseData['artisan']['PrenomArtisan'],
              'Note': responseData['artisan']['Note'],
              'Numero': responseData['artisan']['NumeroTelArtisan'],
              'Photo': responseData['artisan']['photo'],
            },
            'rdvAffich': {
              'date': responseData['rdvAffich']['DateDebut'],
              'heure': responseData['redAffich']['HeureDebut'],
            },
            'prestation': {
              'Nom': responseData['prestation']['NomPrestation'],
              'Materiel': responseData['prestation']['Maéeriel'],
              'DureeMax': responseData['prestation']['DuréeMax'],
              'DurreMin': responseData['prestation']['DuréeMin'],
              'Ecologique': responseData['prestation']['Ecologique'],
              'Image': responseData['prestation']['Image'],
              'TarifJourMin': responseData['prestation']['TarifJourMin'],
              'TarifJourMax': responseData['prestation']['TarifJourMax'],
            },
            'demandeAffich': {
              'Description': responseData['demandeAffich']['Description'],
              'Localisation': responseData['demandeAffich']['Localisation'],
              'Urgent': responseData['demandeAffich']['Urgente'],
            },
          };
        });
        print('_userData: $data'); // Debugging print
      } else {
        print('Failed to fetch user data');
        print('Response Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }*/

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const SizedBox(width: 100),
            Text(
              "Details",
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Container(
                height: 95,
                width: 335,
                decoration: BoxDecoration(
                  color: const Color(0xFFDCC8C5),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start, // Align children to the start
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.grey[200],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            data['prestation']['Image'].toString(),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: data['prestation']['Nom'].toString(),
                                          style: GoogleFonts.poppins(
                                            color: const Color(0xFF05564B),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        if (data['prestation']
                                        ['Ecologique']) ...[
                                          WidgetSpan(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 6),
                                              child: SvgPicture.asset(
                                                'assets/leaf.svg',
                                                color: const Color(0xff05564B)
                                                    .withOpacity(0.6),
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
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Text(
                "Client",
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 300, // Limiting maximum width
                ),
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFDCC8C5).withOpacity(0.22),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFFDCC8C5),
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 15),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                            data['client']['Photo'].toString(),
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 15), // Add spacing between image and column
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start, // Align children to start
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            data['client']['Username'].toString(),
                            style: GoogleFonts.poppins(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          Row(
                            children: [
                              SvgPicture.asset("assets/telephone.svg"),
                              SizedBox(
                                  width:
                                  5), // Adjust spacing between phone icon and number
                              Expanded(
                                child: Text(
                                  data['client']['Numero'],
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Text(
                "Informations",
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 300, // Limiting maximum width
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFFDCC8C5),
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 10),
                          SvgPicture.asset("assets/calendar.svg"),
                          SizedBox(width: 15),
                          Text(
                            data['rdvAffich']['date'].toString(),
                            style: GoogleFonts.poppins(fontSize: 15),
                          ),
                          SizedBox(width: 5),
                          Text(
                            data['rdvAffich']['heure'].toString(),
                            style: GoogleFonts.poppins(fontSize: 15),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          SizedBox(width: 6),
                          SvgPicture.asset("assets/pin_light.svg"),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              data['demandeAffich']['Localisation'].toString(),
                              style: GoogleFonts.poppins(fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          SizedBox(width: 10),
                          SvgPicture.asset("assets/money.svg"),
                          SizedBox(width: 15),
                          Text(
                            "${data['prestation']['TarifJourMin']} - ${data['prestation']['TarifJourMax']}",
                            style: GoogleFonts.poppins(fontSize: 15),
                          ),
                          Text(
                            "/h",
                            style: GoogleFonts.poppins(
                                color: Color(0xFF777777), fontSize: 15),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 15),
                          SvgPicture.asset("assets/outils.svg"),
                          SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              data['prestation']['Materiel'].toString(),
                              softWrap: true,
                              style: GoogleFonts.poppins(fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          SizedBox(width: 10),
                          SvgPicture.asset("assets/urgent.svg",
                              color: Color(0xff05564B).withOpacity(1)),
                          SizedBox(width: 15),
                          Text(
                            data['demandeAffich']['Urgent']
                                ? "Urgente"
                                : "Pas urgente",
                            style: GoogleFonts.poppins(fontSize: 15),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Stack(
                        children: [
                          Positioned(
                            child: Container(
                              constraints: BoxConstraints(
                                  maxWidth: 270), // Limiting maximum width
                              height: 150,
                              decoration: BoxDecoration(
                                  color:
                                  const Color(0xFFDCC8C5).withOpacity(0.22),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: const Color(0xFFDCC8C5),
                                    width: 2,
                                  )),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    data['demandeAffich']['Description']
                                        .toString(),
                                    style: GoogleFonts.poppins(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 10,
                            child: Transform.translate(
                              offset: const Offset(0, -15),
                              child: Container(
                                height: 35,
                                width: 110,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDCC8C5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    "Description",
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFF05564B),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}