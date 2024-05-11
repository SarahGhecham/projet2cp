import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/pages/activite/activite_client.dart';
import 'package:flutter_application_proj2cp/pages/home/home_page_client.dart';
import 'package:flutter_application_proj2cp/profilartisan_client.dart';
import 'package:flutter_application_proj2cp/widgets/bottom_nav_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_proj2cp/pages/inscription.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_proj2cp/config.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/bottom_nav_bar.dart';
import 'package:flutter_application_proj2cp/pages/artisan/Bottomnavbar_artisan.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  Future<void> _authenticateUser() async {
    final email = _usernameController.text;
    final password = _passwordController.text;

    final url = Uri.parse(
        'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/connexion/login');

    try {
      final response = await http.post(
        url,
        body: json.encode({'Email': email, 'Motdepasse': password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        var token = responseData['token'];
        var role = responseData['role'];
        print(role);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        if (role == "Admin") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  BottomNavBarAdmin(), // Remplacez ArtisanPage par le nom de votre page pour les artisans
            ),
          );
        } else if (role == "Client") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  BottomNavBar(), // Remplacez ClientPage par le nom de votre page pour les clients
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  BottomNavBarartisan(), // Remplacez ClientPage par le nom de votre page pour les clients
            ),
          );
        }
      } else {
        var responseData = json.decode(response.body);
        var errorMessage = responseData['message'];

        if (response.statusCode == 401) {
          if (errorMessage == "adresse e-mail invalide") {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Authentification échouée'),
                content:
                const Text("Adresse e-mail invalide. Veuillez réessayer."),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          } else if (errorMessage == "mot de passe incorrect") {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Authentification échouée'),
                content:
                const Text('Mot de passe incorrect. Veuillez réessayer.'),
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
                title: const Text('Authentification échouée'),
                content: const Text(
                    "Nom d'utilisateur ou mot de passe incorrect. Veuillez réessayer."),
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
          print('L\'authentification a échoué');
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Authentification échouée'),
              content: const Text(
                  'Nom d\'utilisateur ou mot de passe incorrect. Veuillez réessayer.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    } catch (error) {
      print('Erreur: $error');
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
              const SizedBox(height: 150),
              SizedBox(
                height: 100,
                width: 300,
                child: Image.asset("assets/logo1.png"),
              ),
              const SizedBox(height: 40),
              Center(
                child: Text(
                  "Connexion",
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF05564B),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 60),
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
                  controller: _usernameController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: GoogleFonts.poppins(
                      color: const Color(0xFF777777),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 16.0,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 40),
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
                  decoration: InputDecoration(
                    hintText: "Mot de passe",
                    hintStyle: GoogleFonts.poppins(
                      color: const Color(0xFF777777),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 16.0,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _authenticateUser,
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
                child: Text(
                  "Connexion",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Vous n’avez pas de compte client ?",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF777777),
                      fontSize: 16,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpPage(),
                        ),
                      );
                    },
                    child: Text(
                      "S'inscrire",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF05564B),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
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