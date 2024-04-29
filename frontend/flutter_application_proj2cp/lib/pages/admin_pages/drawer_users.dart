import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/constants/constants.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/ajouter_domaine.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/drawer.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/search_bar.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/users_artisans.dart';
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
    // You can add logic here to navigate to different pages based on the index
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerDash(
        onPageSelected: onPageSelected,
        initialSelectedIndex:
            _currentPageIndex, // Pass the _currentPageIndex here
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
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
                            color:
                                _showClients ? vertFonce : Colors.transparent,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                          child: Text(
                            'En cours',
                            style: TextStyle(
                              color: _showClients ? Colors.white : cremeClair,
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
                            color:
                                !_showClients ? vertFonce : Colors.transparent,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                          child: Text(
                            'Terminé',
                            style: TextStyle(
                              color: !_showClients ? Colors.white : cremeClair,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
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
              SizedBox(
                height: 80,
              ),
              SizedBox(
                height:
                    MediaQuery.of(context).size.height - kToolbarHeight - 10.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 35),
                  child: _showClients ? AddDomainePage() : ArtisansList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
