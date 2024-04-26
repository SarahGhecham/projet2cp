import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/constants/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class BarRecherche extends StatelessWidget {
  const BarRecherche({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0), // Adjusted padding
      child: SizedBox(
        height: 40, // Set the height of the search bar
        child: TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: vertClair,
            hintText: 'Rechercher...',
            hintStyle: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[600],
            ), // Custom hint text style
            prefixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/icons/recherche.png'),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0), // Custom border radius
              borderSide: BorderSide.none, // Remove the border side
            ),
            contentPadding: EdgeInsets.zero, // Remove default content padding
          ),
        ),
      ),
    );
  }
}