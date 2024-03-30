import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/widgets/bottom_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        // Add any appbar customization here
      ),
      body: const Center(
        child: Text('Welcome to the homepage!'),
        // Add your homepage content here
      ),
    );
  }
}
