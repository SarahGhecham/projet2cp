import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/condition.dart';
import 'package:flutter_application_proj2cp/help.dart';
import 'package:flutter_application_proj2cp/pages/connexion.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'lancer_demande1.dart';

class parametrePage extends StatefulWidget {
  const parametrePage({super.key});

  @override
  State<parametrePage> createState() => parametrePageState();
}

void logout(BuildContext context) async {
  // You can add any additional logout logic here, such as clearing user tokens or data
  // For this example, we'll just navigate back to the first page (HomePage) and clear the token
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');

  // Navigate back to the home page
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => LogInPage()),
        (Route<dynamic> route) => false,
  );
}
class parametrePageState extends State<parametrePage> {
  bool _switchValue = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            "Paramétre",
            style:
            GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset("assets/notification.svg"),
                    SizedBox(width: 15),
                    Text(
                      "Notification",
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Switch(
                  value: _switchValue,
                  onChanged: (value) {
                    setState(() {
                      _switchValue = value;
                    });
                  },
                  activeTrackColor: Color(0xFF05564B)
                      .withOpacity(0.8), // Color of the active switch track
                  activeColor:
                  Colors.white, // Color of the switch thumb when it's on
                  inactiveThumbColor:
                  Colors.white, // Color of the switch thumb when it's off
                  inactiveTrackColor: Color(0xFFD6E3DC),
                  // Removes the gray stroke
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => conditionPage()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset("assets/confidentialité.svg"),
                      SizedBox(width: 15),
                      Text(
                        "Conditions générales",
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SvgPicture.asset("assets/arrowp.svg"),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => helpPage()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset("assets/help.svg"),
                      SizedBox(width: 15),
                      Text(
                        "Centre d'aide",
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SvgPicture.asset("assets/arrowp.svg"),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  SvgPicture.asset("assets/deconnexion.svg"),
                  SizedBox(width: 15),
                  Text(
                    "Deconnexion",
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}