import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/constants/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class drawer_dash extends StatelessWidget {
  const drawer_dash({
    super.key,
  });

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
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                      color: creme,
                    ),
                    child: ListTile(
                      leading: Image.asset(
                        'assets/icons/Chart.png',
                        width: 25, // Adjust the width of the image
                        height: 25,
                      ), // Icon for the button
                      title: Text(
                        'Overview',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: kWhite,
                          fontWeight: FontWeight.w500,
                        ),
                      ), // Text for the button
                      onTap: () {
                        // Handle Option 1 tap
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                      color: creme,
                    ),
                    child: ListTile(
                      leading: Image.asset(
                        'assets/icons/services.png',
                        width: 25, // Adjust the width of the image
                        height: 25,
                      ), // Icon for the button
                      title: Text(
                        'Services',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: kWhite,
                          fontWeight: FontWeight.w500,
                        ),
                      ), // Text for the button
                      onTap: () {
                        // Handle Option 2 tap
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                      color: creme,
                    ),
                    child: ListTile(
                      leading: Image.asset(
                        'assets/icons/users.png',
                        width: 25, // Adjust the width of the image
                        height: 25,
                      ), // Icon for the button
                      title: Text(
                        'Utilisateurs',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: kWhite,
                          fontWeight: FontWeight.w500,
                        ),
                      ), // Text for the button
                      onTap: () {
                        // Handle Option 3 tap
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                      color: creme,
                    ),
                    child: ListTile(
                      leading: Image.asset(
                        'assets/icons/orders.png',
                        width: 25, // Adjust the width of the image
                        height: 25,
                      ), // Icon for the button
                      title: Text(
                        'Orders',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: kWhite,
                          fontWeight: FontWeight.w500,
                        ),
                      ), // Text for the button
                      onTap: () {
                        // Handle Option 4 tap
                      },
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
