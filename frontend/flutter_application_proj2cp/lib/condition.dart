import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

//import 'package:video_player/video_player.dart';
//import 'package:chewie/chewie.dart';

class conditionPage extends StatefulWidget {
  const conditionPage({super.key});

  @override
  State<conditionPage> createState() => conditionPageState();
}

class conditionPageState extends State<conditionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            SizedBox(width: 30),
            Text(
              "Conditions générales",
              style:
              GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Bienvenue à Beaver",
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Text(
                "Les présentes Conditions Générales d'Utilisation régissent votre utilisation de l'application mobile Beaver. En utilisant cette Application, vous acceptez d'être lié par ces Conditions. Si vous n'acceptez pas certaines des conditions énoncées ici, nous vous recommandons de ne pas utiliser notre Application.",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Contenu de l'Application",
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Text(
                "Notre Application permet aux utilisateurs de prendre des rendez-vous de maintenance à domicile avec des artisans qualifiés. Vous acceptez de ne pas utiliser l'Application à des fins autres que celles prévues.",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Modifications",
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Text(
                "Nous nous réservons le droit de modifier ces Conditions à tout moment. Vous devez consulter régulièrement cette page pour vous tenir informé des éventuelles modifications. En continuant à utiliser l'Application après la publication de modifications, vous acceptez ces modifications.",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Résiliation",
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Text(
                "Nous nous réservons le droit de résilier ou de suspendre votre accès à notre Application immédiatement, sans préavis ni responsabilité, pour quelque raison que ce soit, y compris, sans limitation, si vous violez les Conditions.",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Lois Applicables",
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Text(
                "Les présentes Conditions sont régies et interprétées conformément aux lois algériennes. Si une disposition des présentes Conditions est jugée invalide ou inapplicable par un tribunal, les autres dispositions des présentes Conditions resteront en vigueur.",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}