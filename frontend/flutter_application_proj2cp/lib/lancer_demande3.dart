import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Lancerdemande3Page extends StatefulWidget {
  const Lancerdemande3Page({super.key});

  @override
  State<Lancerdemande3Page> createState() => _Lancerdemande3PageState();
}

class _Lancerdemande3PageState extends State<Lancerdemande3Page> {
  var nomprest = "Lavage de sol";
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<dynamic> _predictions = [];
  bool _showSuggestions = true;
  @override

  void _searchPlaces(String input) async {
    const apiKey = 'AIzaSyD_d366EANPIHugZe9YF5QVxHHa_Bzef_4';
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=(cities)&key=$apiKey&language=fr';

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    setState(() {
      _predictions = data['predictions'];
    });
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
            const SizedBox(height: 180),
            SizedBox(
              height: 18,
              width: 25,
              child: SvgPicture.asset("assets/fleche.svg"),
            ),
            const SizedBox(width: 50),
            Container(
              width: 200,
              height: 11,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFD9D9D9), width: 1.5),
              ),
              child: const LinearProgressIndicator(
                value: 1,
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF05564B)),
              ),
            ),
            const SizedBox(width: 50),
            SizedBox(
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
            const SizedBox(height: 50),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                nomprest,
                style: GoogleFonts.poppins(fontSize: 18),
              ),
            ),
            const SizedBox(height: 50),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Votre adresse :",
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 35,
                  width: 35,
                  child: SvgPicture.asset("assets/pin_light.svg"),
                ),
                const SizedBox(width: 10),
                Column(
                  children: [
                    Container(
                      width: 280,
                      height: 45,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCC8C5).withOpacity(0.22),
                        border: Border.all(
                          color: const Color(0xFFDCC8C5),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                          controller: _controller,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "Adresse",
                            hintStyle: GoogleFonts.poppins(
                              color: const Color(0xFF777777),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 10.0,
                            ),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              _searchPlaces(value);
                              setState(() {
                                _showSuggestions = true; // Show suggestions when typing
                              });
                            }
                          }),
                    ),
                  ],
                ),
              ],
            ),
            Visibility(
              visible: _showSuggestions,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _predictions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_predictions[index]["description"]),
                    onTap: () {
                      _controller.text = _predictions[index]["description"];
                      setState(() {
                        _showSuggestions = false;
                      });
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 80),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Ajouter une description à votre demande:",
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 60),
            Center(
              child: Container(
                width: 277,
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFFDCC8C5).withOpacity(0.22),
                  border: Border.all(
                    color: const Color(0xFFDCC8C5),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: _descriptionController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Description",
                    hintStyle: GoogleFonts.poppins(
                      color: const Color(0xFF777777),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 10.0,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 60),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  minimumSize:
                      MaterialStateProperty.all<Size>(const Size(315, 55)),
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
      ),
    );
  }
}
