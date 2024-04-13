import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/constants/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class DomaineContainer extends StatelessWidget {
  final String image;
  final String serviceName;

  const DomaineContainer(
      {super.key, required this.image, required this.serviceName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {}, //afficher prestations
      child: Padding(
        padding: const EdgeInsets.all(9.0),
        child: SizedBox(
            width: 210,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment
                    .start, // Align children to the start of the column
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Image.asset(
                          image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            color: creme,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Center(
                              child: Text(
                                serviceName,
                                style: GoogleFonts.poppins(
                                  color: kBlack,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}