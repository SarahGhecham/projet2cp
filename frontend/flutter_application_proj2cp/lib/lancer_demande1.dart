import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';


class Lancerdemande1Page extends StatefulWidget {
  @override
  State<Lancerdemande1Page> createState() => _Lancerdemande1PageState();
}

class _Lancerdemande1PageState extends State<Lancerdemande1Page> {

  var nomprest = "Lavage de sol";
  var hour = 1;
  var min = 30;

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
                value: 0.33,
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
      body: Column(
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
              "De combien d’heure de service avez vous besoin?",
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFF8787),
                ),
                child: InkWell(
                  onTap: (){},
                  child: Icon(
                    Icons.remove,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(width: 30),
              Container(
                height: 78,
                width: 132,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFDCC8C5),
                ),
                child: Center(
                  child: Text(
                    hour.toString() + " : " + min.toString(), style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(width: 30),
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFF8787),
                ),
                child: InkWell(
                  onTap: (){},
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 80),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "Est ce que votre demande est urgente ?",
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: (){},
                child: Text(
                  "Non",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(Size(132, 69)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Color(0xFFDCC8C5)),
                ),
              ),
              SizedBox(width: 40),
              ElevatedButton(
                onPressed: (){},
                child: Text(
                  "Oui",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(Size(132, 69)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Color(0xFFFF8787)),
                ),
              ),
            ],
          ),
          SizedBox(height: 80),
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
    );
  }
}
