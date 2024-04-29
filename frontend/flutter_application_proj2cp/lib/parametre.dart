import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'lancer_demande1.dart';

class details_prestationPage extends StatefulWidget {
  const details_prestationPage({super.key});

  @override
  State<details_prestationPage> createState() => _details_prestationPageState();
}

class _details_prestationPageState extends State<details_prestationPage> {
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
    );
  }
}
