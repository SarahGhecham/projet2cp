import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/constants/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_proj2cp/pages/afficher_prestation.dart';
class Domaine {
  final int id;
  final String image;
  final String serviceName;


  Domaine({required this.id,required this.image, required this.serviceName});
}

class DomaineContainer extends StatefulWidget {
  final Domaine domaine;

  const DomaineContainer({Key? key, required this.domaine}) : super(key: key);

  @override
  State<DomaineContainer> createState() => _DomaineContainerState();
}

class _DomaineContainerState extends State<DomaineContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Naviguer vers une nouvelle page en passant domaine.id
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PrestationPage(id: widget.domaine.id,NomDomaine: widget.domaine.serviceName,),
        ),
      );
      },
      child: Padding(
        padding: const EdgeInsets.all(9.0),
        child: Container(
          width: 210,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                // Image container with fixed aspect ratio
                AspectRatio(
                  aspectRatio: 9 / 9, // Adjust aspect ratio as needed
                  child: ClipRRect(
                    borderRadius: BorderRadius.zero, // Remove border here
                    child: Image.network(
                      widget.domaine.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Text('Error loading image'),
                        );
                      },
                    ),
                  ),
                ),
                // Container for service name (unchanged)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: creme,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Center(
                      child: Text(
                        widget.domaine.serviceName,
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
        ),
      ),
    );
  }
}
