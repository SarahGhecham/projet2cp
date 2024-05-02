/*import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/constants/constants.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/ajouter_domaine.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/creer_artisan.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/drawer.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/search_bar.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/users_artisans.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/users_clients.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawerUsers extends StatefulWidget {
  const DrawerUsers({super.key});

  @override
  State<DrawerUsers> createState() => _DrawerUsersState();
}

class _DrawerUsersState extends State<DrawerUsers> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentPageIndex = 2;
  bool _showClients = true;
  void onPageSelected(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerDash(
        onPageSelected: onPageSelected,
        initialSelectedIndex: _currentPageIndex,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 35.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly, // Space evenly
                  children: [
                    // Options icon with adjusted padding
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 25.0), // Adjusted padding
                      child: GestureDetector(
                        onTap: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                        child: SizedBox(
                          width: 30, // Adjusted width
                          height: 30,
                          child: Image.asset(
                            'assets/icons/options.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    // Search bar with expanded flex
                    Expanded(
                      flex: 2, // Give search bar more space (optional)
                      child: BarRecherche(),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: SizedBox(
                    width: 270,
                    height: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        color: cremeClair,
                        border: Border.all(color: creme, width: 1.5),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _showClients = true;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: _showClients
                                    ? vertFonce
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 35, vertical: 5),
                              child: Text(
                                'En cours',
                                style: TextStyle(
                                  color:
                                      _showClients ? Colors.white : cremeClair,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _showClients = false;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: !_showClients
                                    ? vertFonce
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 35, vertical: 5),
                              child: Text(
                                'Terminé',
                                style: TextStyle(
                                  color:
                                      !_showClients ? Colors.white : cremeClair,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Visibility(
                            visible: !_showClients,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreerArtisan(),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(),
                                child: Image.asset(
                                  'assets/icons/ajouter.png', // Replace with your asset path
                                  width: 30, // Adjust the width of the image
                                  height: 30, // Adjust the height of the image
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 80,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height -
                      kToolbarHeight -
                      10.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 35),
                    child: _showClients ? ClientsList() : ArtisansList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/constants/constants.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/ajouter_domaine.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/creer_artisan.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/drawer.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/search_bar.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/users_artisans.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/users_clients.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawerUsers extends StatefulWidget {
  const DrawerUsers({Key? key}) : super(key: key);

  @override
  State<DrawerUsers> createState() => _DrawerUsersState();
}

class _DrawerUsersState extends State<DrawerUsers> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentPageIndex = 2;
  bool _showClients = true;

  void onPageSelected(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerDash(
        onPageSelected: onPageSelected,
        initialSelectedIndex: _currentPageIndex,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 35.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: GestureDetector(
                        onTap: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: Image.asset(
                            'assets/icons/options.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: BarRecherche(),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0, left: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 270,
                        height: 40,
                        decoration: BoxDecoration(
                          color: cremeClair,
                          border: Border.all(color: creme, width: 1.5),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showClients = true;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _showClients
                                      ? vertFonce
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 35, vertical: 5),
                                child: Text(
                                  'Clients',
                                  style: TextStyle(
                                    color: _showClients
                                        ? Colors.white
                                        : cremeClair,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showClients = false;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: !_showClients
                                      ? vertFonce
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 35, vertical: 5),
                                child: Text(
                                  'Artisans',
                                  style: TextStyle(
                                    color: !_showClients
                                        ? Colors.white
                                        : cremeClair,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: !_showClients,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreerArtisan(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/icons/ajouter.png',
                                width: 30,
                                height: 30,
                              ),
                              // SizedBox(width: 5),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(
                  height: MediaQuery.of(context).size.height -
                      kToolbarHeight -
                      10.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 35),
                    child: _showClients ? ClientsList() : ArtisansList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
