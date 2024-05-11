import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/constants/constants.dart';
import 'package:flutter_application_proj2cp/pages/activite/activite_client.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/drawer_services.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/profil_admin.dart';
import 'package:flutter_application_proj2cp/pages/afficher_prestation.dart';
import 'package:flutter_application_proj2cp/pages/artisan/acceuil_artisan.dart';
import 'package:flutter_application_proj2cp/pages/artisan/commentaire_artisan.dart';
import 'package:flutter_application_proj2cp/pages/artisan/activite_artisan.dart';

import 'package:flutter_application_proj2cp/pages/home/home_page_client.dart';
import 'package:flutter_application_proj2cp/pages/profile_screen.dart';
import 'package:flutter_application_proj2cp/profile_artisan.dart';

class BottomNavBarartisan extends StatefulWidget {
  const BottomNavBarartisan({super.key});

  @override
  State<BottomNavBarartisan> createState() => _BottomNavBarartisanState();
}

class _BottomNavBarartisanState extends State<BottomNavBarartisan> {
  int _selectedIndex = 0;

  // Define your page views
  final List<Widget> _pages = [
    Acc_artisan(),
    ActiviteArtisan(),
    ProfileartisanPage(),
    //Activite(),
    //PrestationPage(),
    //Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          _pages[_selectedIndex],
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: Container(
                height: 56,
                padding: const EdgeInsets.all(12),
                margin:
                const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                decoration: BoxDecoration(
                  color: vertFonce,
                  borderRadius: BorderRadius.all(Radius.circular(27)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => _onItemTapped(0),
                      child: Image.asset(
                        _selectedIndex == 0
                            ? 'assets/images/home_filled.png'
                            : 'assets/images/home.png',
                        width: 25,
                        height: 25,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _onItemTapped(1),
                      child: Image.asset(
                        _selectedIndex == 1
                            ? 'assets/images/activity.png'
                            : 'assets/images/activity_notfilled.png',
                        width: 27,
                        height: 27,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _onItemTapped(2),
                      child: Image.asset(
                        _selectedIndex == 3
                            ? 'assets/images/profile_filled.png'
                            : 'assets/images/profile_notfilled.png',
                        width: 35,
                        height: 35,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}