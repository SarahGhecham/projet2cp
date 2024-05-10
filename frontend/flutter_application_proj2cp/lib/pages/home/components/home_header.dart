import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/pages/mademande.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final String profilePictureUrl;

  const HomeHeader({
    Key? key,
    required this.userName,
    required this.profilePictureUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: CircleAvatar(
                backgroundImage: NetworkImage(profilePictureUrl),
                radius: 30,
              ),
            ),
            Text(
              'Salut $userName',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }
}
