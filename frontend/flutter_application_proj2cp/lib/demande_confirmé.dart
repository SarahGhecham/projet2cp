import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';


class demande_confirmePage extends StatefulWidget {
  const demande_confirmePage({super.key});

  @override
  State<demande_confirmePage> createState() => _demande_confirmePageState();
}

class _demande_confirmePageState extends State<demande_confirmePage> {
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
                  children: [
                    Image.asset("assets/peinture.png"),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Peinture de Murs et Plafonds",softWrap: true, style: GoogleFonts.poppins(color: const Color(0xFF05564B), fontSize: 16, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 10),
                          Text("Confirmé le 23 Jan à 12:00",softWrap: true, style: GoogleFonts.poppins(fontSize: 12)),
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
            ),
          ),
        ],
      ),

    );
  }
}