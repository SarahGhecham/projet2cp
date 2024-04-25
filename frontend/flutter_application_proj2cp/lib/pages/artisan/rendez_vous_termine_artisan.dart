import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class RDV_confirmeartisanPage extends StatefulWidget {
  const RDV_confirmeartisanPage({super.key});

  @override
  State<RDV_confirmeartisanPage> createState() =>
      _RDV_confirmeartisanPageState();
}

class _RDV_confirmeartisanPageState extends State<RDV_confirmeartisanPage> {
  var nomartisan = "Karim Mouloud";
  var note = "4.7";
  var telephone = "07 71253705";
  var date = "merc 13 jan";
  var heure = "13h";
  var adresse = "Cite 289 logements Jijel N113";
  var prix = "1000da";
  var prestation = "Peinture de mûrs";
  bool ecologique = true;
  bool urgente = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            SizedBox(
              height: 18,
              width: 25,
              child: SvgPicture.asset("assets/fleche.svg"),
            ),
            const SizedBox(width: 130),
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
                          child: Image.asset(
                            'assets/lavage_sol.png',
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
                                          text: "Peinture de Murs et Plafonds",
                                          style: GoogleFonts.poppins(
                                            color: const Color(0xFF05564B),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        if (ecologique) ...[
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
                            Text(
                              "Confirmé le 23 Jan à 12:00",
                              softWrap: true,
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
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
                height: 80,
                width: 300,
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
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage("assets/artisan.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 15), // Add spacing between image and column
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align children to start
                      children: [
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Text(
                              nomartisan,
                              style: GoogleFonts.poppins(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            SvgPicture.asset("assets/telephone.svg"),
                            SizedBox(width: 10),
                            Text(
                              telephone,
                              style: GoogleFonts.poppins(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
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
                height: 480,
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
                        children: [
                          SizedBox(width: 10),
                          SvgPicture.asset("assets/calendar.svg"),
                          SizedBox(width: 15),
                          Text(
                            date,
                            style: GoogleFonts.poppins(fontSize: 15),
                          ),
                          SizedBox(width: 10),
                          Text(
                            heure,
                            style: GoogleFonts.poppins(
                                color: Color(0xFF777777), fontSize: 15),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          SizedBox(width: 6),
                          SvgPicture.asset("assets/pin_light.svg"),
                          SizedBox(width: 10),
                          Text(
                            adresse,
                            style: GoogleFonts.poppins(fontSize: 15),
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
                            prix,
                            style: GoogleFonts.poppins(fontSize: 15),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          SizedBox(width: 15),
                          SvgPicture.asset("assets/outils.svg"),
                          SizedBox(width: 15),
                          Text(
                            prestation,
                            softWrap: true,
                            style: GoogleFonts.poppins(fontSize: 15),
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
                            urgente ? "Urgente" : "Pas urgente",
                            style: GoogleFonts.poppins(fontSize: 15),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          SizedBox(width: 10),
                          SvgPicture.asset("assets/note.svg"),
                          SizedBox(width: 15),
                          Text(
                            note,
                            style: GoogleFonts.poppins(fontSize: 15),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Stack(
                        children: [
                          Positioned(
                            child: Container(
                              height: 150,
                              width: 270,
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
                                    "Nettoyage complet et professionnel des sols avec des produits efficaces et non nocifs ",
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