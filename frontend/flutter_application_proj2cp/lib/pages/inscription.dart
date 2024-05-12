import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/widgets/bottom_nav_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_proj2cp/pages/home/home_page_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_proj2cp/config.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _locationController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _emailController = TextEditingController();
  List<dynamic> _predictions = [];
  bool _showSuggestions = true;

  @override
  void _searchPlaces(String input) async {
    const apiKey = 'AIzaSyBUoTHDCzxA7lix93aS8D5EuPa-VCuoAq0';
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=(cities)&key=$apiKey&language=fr';

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    setState(() {
      _predictions = data['predictions'];
    });
  }
  Future<void> _signUpUser() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final email = _emailController.text;
    final telephone = _telephoneController.text;
    final location = _locationController.text;

    final url = Uri.parse('http://${AppConfig.serverAddress}:${AppConfig.serverPort}/client/sign-up');

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'Username': username,
          'MotdepasseClient': password,
          'EmailClient': email,
          'AdresseClient': location,
          'NumeroTelClient': telephone,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        var responseData = json.decode(response.body);
        var token = responseData['token'];
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomNavBar(),
          ),
        );
      } else if (response.statusCode == 400) {
        var responseData = json.decode(response.body);
        var errorMessage = responseData['message'];

        if (errorMessage.contains("n'est pas rempli")) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Inscription échouée'),
              content: Text(errorMessage),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else if (errorMessage.contains("numéro de téléphone n'a pas le bon format")) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Inscription échouée'),
              content: Text(errorMessage),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else if (errorMessage == "L'adresse saisie est invalide") {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Inscription échouée'),
              content: Text(errorMessage),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else if (errorMessage == 'Compte email déjà existant' || errorMessage == 'Compte email existant') {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Inscription échouée'),
              content: Text(errorMessage),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Inscription échouée'),
              content: const Text('Impossible de s\'inscrire. Veuillez réessayer.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } else {
        print('L\'inscription a échoué');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Inscription échouée'),
            content: const Text('Impossible de s\'inscrire. Veuillez réessayer.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 110),
              SizedBox(
                height: 100,
                width: 300,
                child: Image.asset("assets/logo1.png"),
              ),
              const SizedBox(height: 30),
              const Center(
                child: Text(
                  "Inscription",
                  style: TextStyle(
                    color: Color(0xFF05564B),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: "Poppins",
                  ),
                ),
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 125,
                    height: 41,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCC8C5).withOpacity(0.22),
                      border: Border.all(
                        color: const Color(0xFFDCC8C5),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: _usernameController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        hintText: "Identifiant",
                        hintStyle: TextStyle(
                          fontFamily: "Poppins",
                          color: Color(0xFF777777),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 10.0,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(width: 27),
                  Container(
                    width: 125,
                    height: 41,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCC8C5).withOpacity(0.22),
                      border: Border.all(
                        color: const Color(0xFFDCC8C5),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: _telephoneController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        hintText: "Numéro",
                        hintStyle: TextStyle(
                          fontFamily: "Poppins",
                          color: Color(0xFF777777),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 10.0,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: 277,
                height: 41,
                decoration: BoxDecoration(
                  color: const Color(0xFFDCC8C5).withOpacity(0.22),
                  border: Border.all(
                    color: const Color(0xFFDCC8C5),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: "E-mail",
                    hintStyle: TextStyle(
                      fontFamily: "Poppins",
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
              const SizedBox(height: 20),
              Container(
                width: 277,
                height: 41,
                decoration: BoxDecoration(
                  color: const Color(0xFFDCC8C5).withOpacity(0.22),
                  border: Border.all(
                    color: const Color(0xFFDCC8C5),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                    controller: _locationController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: "Adresse",
                      hintStyle: TextStyle(
                        fontFamily: "Poppins",
                        color: Color(0xFF777777),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10.0,
                      ),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        _searchPlaces(value);
                        setState(() {
                          _showSuggestions =
                          true; // Show suggestions when typing
                        });
                      } else {
                        setState(() {
                          _showSuggestions = false; //
                        });
                      }
                    }
                ),
              ),
              Visibility(
                visible: _showSuggestions,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        color: Color(0xFFDCC8C5),
                        thickness: 2.0,
                      );
                    },
                    shrinkWrap: true,
                    itemCount: _predictions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          _predictions[index]["description"],
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                          ),
                        ),
                        onTap: () {
                          _locationController.text = _predictions[index]["description"];
                          setState(() {
                            _showSuggestions = false;
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 277,
                height: 41,
                decoration: BoxDecoration(
                  color: const Color(0xFFDCC8C5).withOpacity(0.22),
                  border: Border.all(
                    color: const Color(0xFFDCC8C5),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: _passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Mot de passe",
                    hintStyle: TextStyle(
                      fontFamily: "Poppins",
                      color: Color(0xFF777777),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10.0,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _signUpUser,
                style: ButtonStyle(
                  minimumSize:
                  MaterialStateProperty.all<Size>(const Size(100, 37)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  backgroundColor:
                  MaterialStateProperty.all<Color>(const Color(0xFFFF8787)),
                ),
                child: const Text(
                  "S'inscrire",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      fontFamily: "Poppins"),
                ),
              ),

              const SizedBox(height: 120),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "J’accepte les termes d’utilisation de l’application",
                    style: TextStyle(
                      color: Color(0xFF777777),
                      fontFamily: "Poppins",
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}