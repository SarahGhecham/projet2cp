import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';


class Lancerdemande3Page extends StatefulWidget {
  @override
  State<Lancerdemande3Page> createState() => _Lancerdemande3PageState();
}

class _Lancerdemande3PageState extends State<Lancerdemande3Page> {

  var nomprest = "Lavage de sol";
  final _searchController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height:180),
            Container(
              height: 18,
              width: 25,
              child: SvgPicture.asset("assets/fleche.svg"),
            ),
            SizedBox(width: 50),
            Container(
              width: 200,
              height: 11,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color(0xFFD9D9D9), width: 1.5),
              ),
              child: LinearProgressIndicator(
                value: 1,
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF05564B)),
              ),
            ),
            SizedBox(width: 50),
            Container(
              height: 16,
              width: 20,
              child: SvgPicture.asset("assets/cancel.svg"),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                nomprest, style: GoogleFonts.poppins(fontSize :18),
              ),
            ),
            SizedBox(height: 50),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Votre adresse :",
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 35,
                  width: 35,
                  child: SvgPicture.asset("assets/pin_light.svg"),
                ),
                SizedBox(width: 10),
                Container(
                  width: 250,
                  height: 41,
                  decoration: BoxDecoration(
                    color: Color(0xFFDCC8C5).withOpacity(0.22),
                    border: Border.all(
                      color: Color(0xFFDCC8C5),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: _searchController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Adresse",
                      hintStyle: GoogleFonts.poppins(
                        color: Color(0xFF777777),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),

                      border: InputBorder.none,
                    ),
                  ),
                ),

              ],
            ),
            SizedBox(height: 80),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Ajouter une description à votre demande:",
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 60),
            Center(
              child: Container(
                width: 277,
                height: 200,
                decoration: BoxDecoration(
                  color: Color(0xFFDCC8C5).withOpacity(0.22),
                  border: Border.all(
                    color: Color(0xFFDCC8C5),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: _searchController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Description",
                    hintStyle: GoogleFonts.poppins(
                      color: Color(0xFF777777),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 10.0,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 60),
            Center(
              child: ElevatedButton(
                onPressed: (){},
                child: Text(
                  "Suivant",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(Size(315, 55)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Color(0xFF05564B)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
