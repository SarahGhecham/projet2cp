import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/pages/home/home_page_client.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_proj2cp/pages/inscription.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class LogInPageWeb extends StatefulWidget {
  const LogInPageWeb({super.key});
  @override
  State<LogInPageWeb> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPageWeb> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _authenticateUser() async {
    final email = _usernameController.text;
    final password = _passwordController.text;

    final url = Uri.parse('http://10.0.2.2:3000/connexion/login');

    try {
      final response = await http.post(
        url,
        body: json.encode({'Email': email, 'Motdepasse': password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        var token = responseData['token'];
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);


        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } else {
        print('Authentication failed');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Authentication Failed'),
            content: const Text('Invalid username or password. Please try again.'),
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
              const SizedBox(height: 100),
              SizedBox(
                height: 200,
                width: 350,
                child: Image.asset("assets/logo1.png"),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "Connexion",
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF05564B),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Container(
                width: 500,
                height: 50,
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
                width: 500,
                height: 50,
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
                  minimumSize: MaterialStateProperty.all<Size>(const Size(200, 50)),
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
              const SizedBox(height: 30),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 150,
                      child: Divider(
                        color: Color(0xFFDDDDDD),
                        thickness: 1.0,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "or",
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const SizedBox(
                      width: 150,
                      child: Divider(
                        color: Color(0xFFDDDDDD),
                        thickness: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/apple.svg",
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(height: 5), // Adjust the height as needed
                    ],
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Connexion avec Apple",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/google.svg",
                        width: 25,
                        height: 25,
                      ),
                      const SizedBox(height: 5), // Adjust the height as needed
                    ],
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Connexion avec Google",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 70),
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
                                builder: (context) => const SignUpPage()));
                      },
                      child: Text(
                        "S'inscrire",
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF05564B),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
