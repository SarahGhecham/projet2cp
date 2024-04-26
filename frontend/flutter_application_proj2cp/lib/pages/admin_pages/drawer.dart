import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/constants/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawerDash extends StatefulWidget {
  final Function(int) onPageSelected;

  const DrawerDash({required this.onPageSelected, Key? key}) : super(key: key);

  @override
  _DrawerDashState createState() => _DrawerDashState();
}

class _DrawerDashState extends State<DrawerDash> {
  int _selectedIndex = 0;

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
                      title: 'Overview',
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
                    SizedBox(height: 26),
                    _buildListTile(
                      icon: 'assets/icons/orders.png',
                      title: 'Orders',
                      index: 3,
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
        },
      ),
    );
  }
}
