// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:PROJET2CP/pages/profile_screen.dart';
import 'package:PROJET2CP/afficher_peinture.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Profile(),
    );
  }
}
