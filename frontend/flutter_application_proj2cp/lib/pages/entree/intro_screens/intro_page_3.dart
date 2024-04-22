import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

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
              'assets/images/images_entree/entree4.jpg',
              fit: BoxFit
                  .cover, // Use BoxFit.cover to ensure the image fills the entire space
            ),
          ),
          // Text widget

          Positioned(
            top: 0,
            left: 50, // Adjust the bottom position as needed
            child: Image.asset(
              'assets/logo1.png',
              width: 300, // Adjust the width as needed
              height: 250, // Adjust the height as needed
            ),
          ),
          Positioned(
            top: 240,
            left: 50, // Adjust the bottom position as needed
            child: Image.asset(
              'assets/Ellipse.png',
              width: 300, // Adjust the width as needed
              height: 300, // Adjust the height as needed
            ),
          ),
          Positioned(
            top: 320, // Adjust the top position as needed
            child: Text(
              'NOS OBJECTIVES?',
              style: GoogleFonts.lato(
                fontSize: 35, // Adjust the font size as needed
                fontWeight: FontWeight.w900,
                color: const Color(0xff05564b), // Adjust the text color as needed
              ),
            ),
          ),
          Positioned(
            bottom: 320,
            left: 20, // Adjust the left position as needed
            width: screenSize.width -
                40, // Adjust the width to ensure proper wrapping
            child: Text(
              'Rendre les services de maintenance à domicile conviviaux, écologiques et réactifs.',
              textAlign: TextAlign.center, // Align the text in the center
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),
          // Another image widget
        ],
      ),
    );
  }
}
