import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/config.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Demandelancee extends StatefulWidget {
  final int demandeID;

  @override
  const Demandelancee({
    Key? key,
    required this.demandeID,
  }) : super(key: key);

  @override
  State<Demandelancee> createState() => _DemandelanceeState();
}

class _DemandelanceeState extends State<Demandelancee> {
  var nomArtisan = "Karim Mouloud";
  var note = "4.7";
  var telephone = "0771253705";
  var date = "merc 13 jan";
  var heure = "13h";
  var adresse = "Cite 289 logements Jijel N113";
  var prix = "1000da";
  var prestation = "Peinture de mûrs";
  var duree = "1h-2h";
  bool urgente = true;
  bool ecologique = true;

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
        'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/artisan/DetailsDemande/${widget.demandeID}');
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        setState(() {
          final responseData = json.decode(response.body);

          // Artisan data
          final clientData =
          responseData != null ? responseData['client'] ?? {} : {};
          final client = {
            'Username': clientData != null ? clientData['Username'] ?? '' : '',
            'Photo': clientData != null ? clientData['photo'] ?? '' : '',
            'Numero': clientData != null ? clientData['NumeroTelClient'] ?? '' : '',
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
            formattedDateDebut = DateFormat('dd/MM/yyyy').format(dateDebut);
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
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),


          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Text(
                "Client",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Stack(
                children: [
                  Container(
                    height: 80,
                    width: 300,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD6E3DC).withOpacity(0.6),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFF05564B),
                        width: 0.5,
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
                              image: NetworkImage(data['client']['Photo'].toString()), // Move this line
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 15),
                            Row(
                              children: [
                                Text(
                                  data['client']['Username'].toString(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                SvgPicture.asset("assets/telephone.svg"),
                                SizedBox(width: 10),
                                Text(
                                  data['client']['Numero'].toString(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Text(
                "Demande",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Container(
                height: 450,
                width: 300,
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
                    children: [
                      SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 10),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: data['prestation']['Nom'].toString(),
                                    style: GoogleFonts.lato(
                                      color: const Color(0xFF05564B),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (data['prestation']['Ecologique']) ...[
                                    WidgetSpan(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 6),
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
                          const SizedBox(width: 20),
                          Container(
                            width: 92,
                            height: 58,
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
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 10),
                          SvgPicture.asset("assets/calendar.svg",
                              color: Color(0xff05564B).withOpacity(1)),
                          SizedBox(width: 15),
                          Text(
                            data['rdvAffich']['date'].toString(),
                            style: GoogleFonts.poppins(fontSize: 15),
                          ),
                          SizedBox(width: 10),
                          Text(
                            data['rdvAffich']['heure'].toString(),
                            style: GoogleFonts.poppins(
                              color: Color(0xFF777777),
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          SizedBox(width: 8),
                          SvgPicture.asset("assets/clock.svg"),
                          SizedBox(width: 15),
                          Text(
                            "${data['prestation']['DureeMin']} - ${data['prestation']['DureeMax']}",
                            style: GoogleFonts.poppins(fontSize: 15),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          SizedBox(width: 6),
                          SvgPicture.asset("assets/pin_light.svg"),
                          SizedBox(width: 10),
                          Text(
                            data['demandeAffich']['Localisation'].toString(),
                            style: GoogleFonts.poppins(fontSize: 15),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          SizedBox(width: 10),
                          SvgPicture.asset("assets/money.svg"),
                          SizedBox(width: 15),
                          Text(
                            "${data['prestation']['TarifJourMin']}da - ${data['prestation']['TarifJourMax']}da /heure",
                            style: GoogleFonts.poppins(fontSize: 15),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          SizedBox(width: 10),
                          SvgPicture.asset("assets/urgent.svg",
                              color: Color(0xff05564B).withOpacity(1)),
                          SizedBox(width: 15),
                          Text(
                            data['demandeAffich']['Urgent'] ? "Urgente" : "Pas urgente",
                            style: GoogleFonts.poppins(fontSize: 15),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Stack(
                        children: [
                          Positioned(
                            child: Container(
                              height: 110,
                              width: 270,
                              decoration: BoxDecoration(
                                color:
                                const Color(0xFFDCC8C5).withOpacity(0.22),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(0xFFDCC8C5),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    data['demandeAffich']['Description'].toString(),
                                    style: GoogleFonts.poppins(fontSize: 12),
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
                                      fontWeight: FontWeight.w600,
                                    ),
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