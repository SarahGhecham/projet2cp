import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';


class details_prestationPage extends StatefulWidget {
  const details_prestationPage({super.key});

  @override
  State<details_prestationPage> createState() => _details_prestationPageState();
}

class _details_prestationPageState extends State<details_prestationPage> {
  var prst = "Lavage de sol";
  var avgtime = "1h - 2h";
  var avgprice = "500da - 1500da";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            SizedBox(
              height: 18,
              width: 25,
              child: SvgPicture.asset("assets/fleche.svg"),
            ),
            const SizedBox(width: 130),
            Text(
              "Details",
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 20,
            left: 50,
            child: Container(
              width: 300, // Adjust the width as needed
              height: 300, // Adjust the height as needed
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0), // Adjust the border radius as needed
                color: Colors.grey[200], // Set container background color
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0), // Match the container's border radius
                child: Image.asset(
                  'assets/lavage_sol.png', // Replace 'your_image.jpg' with your image path
                  fit: BoxFit.cover, // Ensure the image covers the entire container
                ),
              ),
            ),
          ),
          Positioned(
            left: 57,
            top: 300,
            child: Container(
              height: 450,
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
                        prst, style: GoogleFonts.poppins(color: const Color(0xFF05564B), fontSize: 18, fontWeight: FontWeight.bold),
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
                          avgtime, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
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
                              avgprice, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const SizedBox(height: 5),
                            Text(
                              "/h", style: GoogleFonts.poppins(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
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
                                "Nettoyage complet et professionnel des sols avec des produits efficaces et non nocifs ", style: GoogleFonts.poppins(),
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
                            height: 35,
                            width: 110,
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCC8C5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "Description", style: GoogleFonts.poppins(color: const Color(0xFF05564B), fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: (){},
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(const Size(180, 50)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xFFFF8787)),
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
    );
  }
}