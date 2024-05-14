import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/constants/constants.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/drawer_orders.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/drawer_services.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/drawer_users.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/page_acc_admin.dart';

import 'package:google_fonts/google_fonts.dart';

class DrawerDash extends StatefulWidget {
  final Function(int) onPageSelected;

  final int initialSelectedIndex;

  const DrawerDash({
    required this.onPageSelected,
    this.initialSelectedIndex = 0, // Default value is 0
    Key? key,
  }) : super(key: key);

  @override
  _DrawerDashState createState() => _DrawerDashState();
}

class _DrawerDashState extends State<DrawerDash> {
  late int _selectedIndex = widget.initialSelectedIndex;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 120.0),
      width: MediaQuery.of(context).size.width * 0.65,
      child: Drawer(
        child: Container(
          color: cremeClair,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              SizedBox(height: 40),
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildListTile(
                      icon: 'assets/icons/Chart.png',
                      title: 'Stats',
                      index: 0,
                    ),
                    SizedBox(height: 26),
                    _buildListTile(
                      icon: 'assets/icons/services.png',
                      title: 'Services',
                      index: 1,
                    ),
                    SizedBox(height: 26),
                    _buildListTile(
                      icon: 'assets/icons/users.png',
                      title: 'Utilisateurs',
                      index: 2,
                    ),
                  ])
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(
      {required String icon, required String title, required int index}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      width: MediaQuery.of(context).size.width * 0.5,
      decoration: BoxDecoration(
        color: _selectedIndex == index ? crevette : creme,
        borderRadius: BorderRadius.circular(7),
      ),
      child: ListTile(
        leading: Image.asset(
          icon,
          width: 25,
          height: 25,
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 15,
            color: kWhite,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
          widget.onPageSelected(index);
          _navigateToScreen(index, context);
        },
      ),
    );
  }

  void _navigateToScreen(int index, BuildContext context) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePageAdmin()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DrawerServices()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DrawerUsers()),
        );
        break;
    }
  }
}
