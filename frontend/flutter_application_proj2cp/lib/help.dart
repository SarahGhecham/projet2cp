import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class helpPage extends StatefulWidget {
  const helpPage({super.key});

  @override
  State<helpPage> createState() => helpPageState();
}

class helpPageState extends State<helpPage> {
  List<String> question = [
    "Qui est Beaver",
    "Quelles sont les domaines assurés",
    "Sommes nous de confiance"
  ];
  List<bool> reponse = [false, false, false];
  List<String> answers = [
    "Une application qui a pour but de rapprocher les clients des artisans de coins en assurant la sécurité",
    "Eléctricité, Nettoyage, Jardinage, Plombrie, maçonnerie, Peinture",
    "oui nous sommes comforme au regulations algériennes"
  ];
  void _visible(int i, bool value) {
    setState(() {
      reponse[i] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            SizedBox(width: 70),
            Text(
              "Centre d'aide",
              style:
              GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "FAQ",
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ListView.separated(
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  color: Color(0xFFDCC8C5),
                  thickness: 2.0,
                );
              },
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(
                        question[index],
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                        ),
                      ),
                      onTap: () {
                        if (!reponse[index]) {
                          _visible(index, true);
                        } else {
                          _visible(index, false);
                        }
                      },
                    ),
                    if (reponse[
                    index]) // Conditionally show the additional text
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          answers[index],
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}