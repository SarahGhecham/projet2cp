import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_proj2cp/constants/constants.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/creer_artisan.dart';

class Artisan {
  final String name;
  final String image;
  Artisan({required this.name, required this.image});
}

class ArtisansList extends StatefulWidget {
  const ArtisansList({super.key});

  @override
  State<ArtisansList> createState() => _ArtisansListState();
}

class _ArtisansListState extends State<ArtisansList> {
  List<Artisan?> artisans = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.only(
          bottom: kBottomNavigationBarHeight + 70,
        ),
        itemCount: artisans.length,
        itemBuilder: (context, index) {
          final artisan = artisans[index];
          return Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: creme, width: 1),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      color: creme,
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage(artisan?.image ?? ''),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
