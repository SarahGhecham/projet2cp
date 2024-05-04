import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Demandelancee extends StatefulWidget {
  const Demandelancee({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const SizedBox(width: 90),
            Text(
              "Details",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 110),
            SizedBox(
              height: 18,
              width: 25,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop(); // Close the page
                },
                child: Icon(Icons.close), // Icon that closes the page
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
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage("assets/pdp_user.jpg"),
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
                                  nomArtisan,
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
                                  telephone,
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
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      width: 63,
                      height: 19,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFFF7F3F2),
                        border: Border.all(
                          color: const Color(0xFFDCC8C5),
                          width: 1,
                        ),
                      ),
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
                                    text: "Peinture de Murs et Plafonds",
                                    style: GoogleFonts.lato(
                                      color: const Color(0xFF05564B),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (ecologique) ...[
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
                              child: Image.asset(
                                'assets/prestation_peinture.jpg',
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
                            date,
                            style: GoogleFonts.poppins(fontSize: 15),
                          ),
                          SizedBox(width: 10),
                          Text(
                            heure,
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
                            duree,
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
                            adresse,
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
                            prix,
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
                            urgente ? "Urgente" : "Pas urgente",
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
                                    "Nettoyage complet et professionnel des sols avec des produits efficaces et non nocifs ",
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
