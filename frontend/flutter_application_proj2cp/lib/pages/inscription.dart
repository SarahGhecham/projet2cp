import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/widgets/bottom_nav_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_proj2cp/pages/home/home_page_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> _signUpUser() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final email = _emailController.text;
    final telephone = _telephoneController.text;
    final location = _locationController.text;

    final url = Uri.parse('http://10.0.2.2:3000/client/sign-up');

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
        print("trace");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavBar(),
          ),
        );
      } else {
        print('Sign up failed');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Signup Failed'),
            content: const Text('Failed to sign up. Please try again.'),
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
              const SizedBox(height: 70),
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
              const SizedBox(height: 50),
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
              const SizedBox(height: 30),
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
              const SizedBox(height: 20),
              const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Divider(
                        color: Color(0xFFDDDDDD),
                        thickness: 1.0,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "or",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontFamily: "Poppins"),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
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
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Connexion avec Apple",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Poppins",
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
                      const SizedBox(height: 5),
                    ],
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Connexion avec Google",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Poppins",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 60),
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
