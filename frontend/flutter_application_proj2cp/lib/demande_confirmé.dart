import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';


class demande_confirmePage extends StatefulWidget {
  const demande_confirmePage({super.key});

  @override
  State<demande_confirmePage> createState() => _demande_confirmePageState();
}

class _demande_confirmePageState extends State<demande_confirmePage> {
  var nomartisan = "Karim Mouloud";
  var note = "4.7";
  var telephone = "07 71253705";
  var date = "merc 13 jan";
  var heure = "13h";
  var adresse = "Cite 289 logements Jijel N113";
  var prix = "500da - 1000da";
  var prestation = "Peinture de mûrs";
  @override
  Widget build(BuildContext context){
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
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      body: Column(
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
                  crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start
                  children: [
                    Container(
                      width: 80, // Adjust the width as needed
                      height: 80, // Adjust the height as needed
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0), // Adjust the border radius as needed
                        color: Colors.grey[200], // Set container background color
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0), // Match the container's border radius
                        child: Image.asset(
                          'assets/prestation_peinture.jpg', // Replace 'your_image.jpg' with your image path
                          fit: BoxFit.cover, // Ensure the image covers the entire container
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Peinture de Murs et Plafonds",
                            softWrap: true,
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF05564B),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
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
              "Préstataire", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
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
                    crossAxisAlignment: CrossAxisAlignment.start, // Align children to start
                    children: [
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Text(
                            nomartisan,
                            style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(width: 20),
                          SvgPicture.asset("assets/star.svg"),
                          SizedBox(width: 5), // Adjust spacing between text and star
                          Text(
                            note,
                            style: GoogleFonts.poppins(fontSize: 15),
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
                            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
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
              "Informations", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Container(
              height: 400,
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
                          style: GoogleFonts.poppins(color: Color(0xFF777777), fontSize: 15),
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
                        SizedBox(width: 10),
                        Text(
                          "/h",
                          style: GoogleFonts.poppins(color: Color(0xFF777777), fontSize: 15),
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
                    SizedBox(height: 50),
                    Stack(
                      children: [
                        Positioned(
                          child: Container(
                            height: 150,
                            width: 270,
                            decoration: BoxDecoration(
                                color: const Color(0xFFDCC8C5).withOpacity(0.22),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(0xFFDCC8C5),
                                  width: 2,
                                )
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  "Nettoyage complet et professionnel des sols avec des produits efficaces et non nocifs ", style: GoogleFonts.poppins(),
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
                                  "Description", style: GoogleFonts.poppins(color: const Color(0xFF05564B), fontSize: 14, fontWeight: FontWeight.w600),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: (){},
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(const Size(100, 30)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  backgroundColor:
                  MaterialStateProperty.all<Color>(const Color(0xFFE52E22)),
                ),
                child: Text(
                  "Annuler",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}