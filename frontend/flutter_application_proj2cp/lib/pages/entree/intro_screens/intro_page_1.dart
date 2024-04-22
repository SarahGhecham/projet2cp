import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Container(
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background image
          SizedBox(
            width: screenSize.width,
            height: screenSize.height,
            child: Image.asset(
              'assets/images/images_entree/entree2.jpg',
              fit: BoxFit
                  .cover, // Use BoxFit.cover to ensure the image fills the entire space
            ),
          ),
          // Text widget
          Positioned(
            left: 25,
            top: 100, // Adjust the top position as needed
            child: Text(
              'BIENVENUE',
              style: GoogleFonts.lato(
                fontSize: 50, // Adjust the font size as needed
                fontWeight: FontWeight.w900,
                color: const Color(0xffd6e3dc), // Adjust the text color as needed
              ),
            ),
          ),

          Positioned(
            left: 220,
            top: 145, // Adjust the top position as needed
            child: Text(
              'SUR',
              style: GoogleFonts.lato(
                fontSize: 50, // Adjust the font size as needed
                fontWeight: FontWeight.w900,
                color: const Color(0xffd6e3dc), // Adjust the text color as needed
              ),
            ),
          ),

          Positioned(
            top: 220,
            left: 120, // Adjust the bottom position as needed
            child: Image.asset(
              'assets/Ellipse.png',
              width: 300, // Adjust the width as needed
              height: 300, // Adjust the height as needed
            ),
          ),
          // Another image widget
          Positioned(
            top: 210,
            left: 110, // Adjust the bottom position as needed
            child: Image.asset(
              'assets/logo1.png',
              width: 300, // Adjust the width as needed
              height: 300, // Adjust the height as needed
            ),
          ),
        ],
      ),
    );
  }
}
