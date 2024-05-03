import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_application_proj2cp/pages/connexion.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Wait for 2 seconds and then navigate to the next page
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => LogInPage(), // Navigate to the next page
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Your splash screen UI here
    return Scaffold(
      body: Center(
        child: Image.asset("assets/logo1.png",height:130 ,width: 500,),
      ),
    );
  }
}