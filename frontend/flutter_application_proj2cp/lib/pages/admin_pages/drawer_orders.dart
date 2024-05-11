/*import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/constants/constants.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/orders_encours.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/orders_termines.dart';
import 'package:google_fonts/google_fonts.dart';

/*class DrawerOrders extends StatefulWidget {
  const DrawerOrders({super.key});

  @override
  State<DrawerOrders> createState() => _DrawerOrdersState();
}

class _DrawerOrdersState extends State<DrawerOrders> {
  bool _showOngoing = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Add this line

        title: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 30),
            child: Text(
              'Activité',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
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
                        _showOngoing = true;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _showOngoing ? vertFonce : Colors.transparent,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                      child: Text(
                        'En cours',
                        style: TextStyle(
                          color: _showOngoing ? Colors.white : cremeClair,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showOngoing = false;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: !_showOngoing ? vertFonce : Colors.transparent,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                      child: Text(
                        'Terminé',
                        style: TextStyle(
                          color: !_showOngoing ? Colors.white : cremeClair,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height - kToolbarHeight - 10.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 35),
            child: _showOngoing
                ? ActiviteEnCoursAdmin()
                : ActiviteTermineesAdmin(),
          ),
        ),
      ),
    );
  }
}*/
*/