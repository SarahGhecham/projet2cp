import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_proj2cp/lancer_demande2.dart';


class Lancerdemande1Page extends StatefulWidget {
  final nomprest;
 const Lancerdemande1Page({Key? key, required this.nomprest}) : super(key: key);

  @override
  State<Lancerdemande1Page> createState() => _Lancerdemande1PageState();
}

class _Lancerdemande1PageState extends State<Lancerdemande1Page> {

  var nomprest = "Lavage de sol";
  var hour = 1;
  var min = 30;
  var urgent = false;
  void _navigateToNextPage(BuildContext context,String prst) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Lancerdemande2Page(hour: hour, min: min,urgent: urgent,nomprest: prst,),
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
         title: Row(
           mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 30),
            Container(
              width: 170,
              height: 11,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFD9D9D9), width: 1.5),
              ),
              child: const LinearProgressIndicator(
                value: 0.33,
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF05564B)),
              ),
            ),
            const SizedBox(width: 60),
            SizedBox(
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
          const SizedBox(height: 50),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              widget.nomprest, style: GoogleFonts.poppins(fontSize :18),
            ),
          ),
          const SizedBox(height: 50),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "De combien d’heure de service avez vous besoin?",
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFF8787),
                ),
                child: InkWell(
                  onTap: (){
                    setState(() {
                      if (hour != 0 || min != 0) {
                        min -= 30;
                        if (min < 0) {
                          hour--;
                          min = 30;
                        }
                      }
                    });
                  },
                  child: const Icon(
                    Icons.remove,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 30),
              Container(
                height: 78,
                width: 132,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFDCC8C5),
                ),
                child: Center(
                  child: Text(
                    "$hour : ${min == 0 ? "00" : min.toString()}",
                    style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 30),
              Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFF8787),
                ),
                child: InkWell(
                  onTap: (){
                    setState(() {
                      if (hour < 8) {
                        min += 30;
                        if (min > 30) {
                          hour++;
                          min = 0;
                        }
                      }
                    });
                  },

                  child: const Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 80),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "Est ce que votre demande est urgente ?",
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: (){
                  setState(() {
                    urgent = false; // La demande est considérée comme urgente
                     });
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(const Size(132, 69)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  backgroundColor:
                  MaterialStateProperty.all<Color>(const Color(0xFFDCC8C5)),
                ),
                child: Text(
                  "Non",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(width: 50),
              ElevatedButton(
                onPressed: (){
                  setState(() {
                    urgent = true; // La demande est considérée comme urgente
                     });
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(const Size(132, 69)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  backgroundColor:
                  MaterialStateProperty.all<Color>(const Color(0xFFFF8787)),
                ),
                child: Text(
                  "Oui",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 90),
          Center(
            child: ElevatedButton(
              onPressed: () => _navigateToNextPage(context,widget.nomprest),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all<Size>(const Size(315, 55)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                backgroundColor:
                MaterialStateProperty.all<Color>(const Color(0xFF05564B)),
              ),
              child: Text(
                "Suivant",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
