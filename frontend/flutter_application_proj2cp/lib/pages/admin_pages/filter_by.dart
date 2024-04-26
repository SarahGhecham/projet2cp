import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/constants.dart';

class Filtrer extends StatefulWidget {
  final Function(String) onSelectFilter;

  const Filtrer({
    required this.onSelectFilter,
    Key? key,
  }) : super(key: key);

  @override
  _FiltrerState createState() => _FiltrerState();
}

class _FiltrerState extends State<Filtrer> {
  String _selectedFilter = 'Jour';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 30),
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            width: 120,
            decoration: BoxDecoration(
              color: cremeClair,
              borderRadius: BorderRadius.circular(10), // Add border radius
              border: Border.all(color: Color.fromARGB(255, 183, 175, 175)),
            ), // Add border),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Image.asset(
                    'assets/icons/filterby.png',
                    width: 20,
                    height: 20,
                  ),
                  SizedBox(width: 10), // Add some space between icon and text
                  Text(
                    'Filtrer',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: marron,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          _buildFilterButton('Jour'),
          SizedBox(width: 10),
          _buildFilterButton('Semaine'),
          SizedBox(width: 10),
          _buildFilterButton('Mois'),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String filter) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = filter;
        });
        widget.onSelectFilter(filter);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        width: 100,
        decoration: BoxDecoration(
          color: _selectedFilter == filter ? crevette : creme,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color.fromARGB(255, 183, 175, 175)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
          child: Text(
            filter,
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: kWhite,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
