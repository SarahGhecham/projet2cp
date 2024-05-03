import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/pages/afficher_prestation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'dart:convert';
import 'package:flutter_application_proj2cp/lancer_demande1.dart';



class details_prestationPage extends StatefulWidget {
  final int id;
  final String prst;
  final String avgtime;
  final String avgprice;
  final String imagePrestation;
  final String Description;
  final String Unite;
  details_prestationPage({required this.id,required this.prst,required this.avgtime,required this.avgprice,required this.imagePrestation,required this.Description,required this.Unite});

  @override
  State<details_prestationPage> createState() => _details_prestationPageState();
}

class _details_prestationPageState extends State<details_prestationPage> {
  String? nomPrestation;
  void initState() {
    super.initState();
    print(widget.id);
    print(widget.imagePrestation); // Assuming domaineId is available
  }
  void _navigateToNextPage(BuildContext context,String prst) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Lancerdemande1Page(nomprest: prst,),
      ),
    );}


  var outils = "peinture, bâche";
  //var prst = "Lavage";
  //var avgtime = "1h - 2h";
  //var avgprice = "500da - 1500da";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      title: Text(
        "Details",
        style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      centerTitle: true, // Centrer le titre de l'appbar
        ),
      
     
  body: Center(
    child: Stack(
      children: [
        Positioned(
          top: 10,
          left: 40,
          child: Container(
            width: 315,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.grey[200],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: Image.network(
                widget.imagePrestation,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          left: 47,
          top: 220,
          child: Container(
            height: 475,
            width: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: const Color(0xFFDCC8C5),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  height: 50,
                  width: 270,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCC8C5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      widget.prst, 
                      style: GoogleFonts.poppins(color: const Color(0xFF05564B), fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                  child: Row(
                    children: [
                      SvgPicture.asset("assets/clock.svg"),
                      const SizedBox(width: 10),
                      Text(
                        widget.avgtime, 
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          SvgPicture.asset("assets/money.svg"),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Column(
                        children: [
                          const SizedBox(height: 5),
                          Text(
                            widget.avgprice, 
                            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 5),
                          Text(
                            "/${widget.Unite}", 
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          SvgPicture.asset("assets/outils.svg"),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Column(
                        children: [
                          const SizedBox(height: 5),
                          Text(
                            outils, 
                            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
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
                              widget.Description, 
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                              ),
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
                          height: 40,
                          width: 110,
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCC8C5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "Description", 
                              style: GoogleFonts.poppins(color: const Color(0xFF05564B), fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: (){
                    _navigateToNextPage(context,widget.prst);
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all<Size>(const Size(180, 50)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFFFF8787)),
                  ),
                  child: Text(
                    "Lancer demande",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  ),
    );
  }
}