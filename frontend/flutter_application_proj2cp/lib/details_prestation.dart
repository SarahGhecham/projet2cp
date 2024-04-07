import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';


class details_prestationPage extends StatefulWidget {
  @override
  State<details_prestationPage> createState() => _details_prestationPageState();
}

class _details_prestationPageState extends State<details_prestationPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              height: 18,
              width: 25,
              child: SvgPicture.asset("assets/fleche.svg"),
            ),
            SizedBox(width: 130),
            Text(
              "Details",
              style: GoogleFonts.poppins(fontSize: 20),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          Stack(
            children: [
              Positioned(
                child: Container(
                  height: 300,
                  width: 315,
                  child: Image.asset("assets/lavage_sol.png"),
                ),
              ),
              Positioned(
                top: 250,
                right: 55,
                child: Container(
                  height: 400,
                  width: 300,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFFDCC8C5),
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              )
            ],
          ),
        ],
      )
    );
  }
}