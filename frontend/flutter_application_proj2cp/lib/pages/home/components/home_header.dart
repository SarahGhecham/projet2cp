import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/pdp_user.jpg'),
                radius: 30,
              ),
            ),
            Text(
              'Salut User',
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                //aller vers notifs
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Image.asset('assets/icons/notif.png'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

