import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Acc_artisan extends StatefulWidget {
  @override
  _Acc_artisanState createState() => _Acc_artisanState();
}

List<Map<String, dynamic>> clients = [
  {
    'nomprestation': 'Prestation 1',
    'nom': 'Doe',
    'prenom': 'John',
    'photo': 'https://example.com/photo1.jpg',
  },
  {
    'nomprestation': 'Prestation 2',
    'nom': 'Smith',
    'prenom': 'Alice',
    'photo': 'https://example.com/photo2.jpg',
  },
  {
    'nomprestation': 'Prestation 3',
    'nom': 'Johnson',
    'prenom': 'Bob',
    'photo': 'https://example.com/photo3.jpg',
  },
  {
    'nomprestation': 'Prestation 4',
    'nom': 'Williams',
    'prenom': 'Emily',
    'photo': 'https://example.com/photo4.jpg',
  },
  {
    'nomprestation': 'Prestation 5',
    'nom': 'Brown',
    'prenom': 'David',
    'photo': 'https://example.com/photo5.jpg',
  },
  {
    'nomprestation': 'Prestation 6',
    'nom': 'Jones',
    'prenom': 'Emma',
    'photo': 'https://example.com/photo6.jpg',
  },
  {
    'nomprestation': 'Prestation 7',
    'nom': 'Garcia',
    'prenom': 'Michael',
    'photo': 'https://example.com/photo7.jpg',
  },
  {
    'nomprestation': 'Prestation 8',
    'nom': 'Martinez',
    'prenom': 'Olivia',
    'photo': 'https://example.com/photo8.jpg',
  },
  {
    'nomprestation': 'Prestation 9',
    'nom': 'Miller',
    'prenom': 'Sophia',
    'photo': 'https://example.com/photo9.jpg',
  },
  {
    'nomprestation': 'Prestation 10',
    'nom': 'Taylor',
    'prenom': 'William',
    'photo': 'https://example.com/photo10.jpg',
  },
];

class _Acc_artisanState extends State<Acc_artisan> {
  final Key listViewKey = UniqueKey();
  bool ecologique = true;
  bool urgent = true;
  void _removeClient(int index) {
    setState(() {
      clients.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 23),
              Row(
                children: [
                  SizedBox(width: 5),
                  const Padding(
                    padding: EdgeInsets.all(30),
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/z.jpg'),
                      radius: 30,
                    ),
                  ),
                  Text(
                    'Salut Artisan',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      // Handle notification icon tap
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 30.0),
                      child: Image.asset('assets/icons/notif.png'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 41,
                    width: 317,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFDCC8C5),
                    ),
                    child: Text(
                      'Demandes lancées',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Lato',
                      ),
                    ),
                  ),
                  ListView.builder(
                    key: listViewKey,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: clients.length,
                    itemBuilder: (context, index) {
                      bool isFirstItem = index == 0;
                      return Container(
                        height: 93,
                        width: 329,
                        margin: isFirstItem
                            ? EdgeInsets.fromLTRB(30, 00, 30, 10)
                            : EdgeInsets.fromLTRB(30, 10, 30, 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Color(0xFFD6E3DC),
                        ),
                        child: Stack(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 12, top: 19),
                                  width: 55,
                                  height: 55,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(45),
                                    child: clients.isNotEmpty &&
                                            clients[index]['photo'] != null
                                        ? Image.network(
                                            clients[index]['photo'],
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            color: Colors.grey,
                                            child: Icon(
                                              Icons.person,
                                              size: 40,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 15),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        "Peinture de Murs et Plafonds",
                                                    style: GoogleFonts.poppins(
                                                      color: const Color(
                                                          0xFF05564B),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  if (ecologique) ...[
                                                    WidgetSpan(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 2),
                                                        child: SvgPicture.asset(
                                                          'assets/leaf.svg',
                                                          color: const Color(
                                                                  0xff05564B)
                                                              .withOpacity(0.6),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        (clients[index]['nom'] != null &&
                                                clients[index]['prenom'] !=
                                                    null)
                                            ? '${clients[index]['nom']} ${clients[index]['prenom']}  '
                                            : '',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w200,
                                          fontFamily: 'Lato',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 5, // Add margin from the top
                                  right: 5, // Add margin from the right
                                  child: Visibility(
                                    visible: urgent,
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          top: 7, right: 7), // Set margin
                                      child: SvgPicture.asset(
                                        'assets/urgent.svg',
                                        color: Color(0xffFF8787).withOpacity(1),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              bottom: 11,
                              right: 105,
                              child: Container(
                                height: 20,
                                width: 60,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: Colors.green,
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    // Handle accept button tap
                                  },
                                  style: ButtonStyle(
                                    padding:
                                        MaterialStateProperty.all<EdgeInsets>(
                                      EdgeInsets.zero,
                                    ),
                                  ),
                                  child: Text(
                                    'Accepter',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Lato',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Positioned(
                              bottom: 11,
                              right: 35,
                              child: Container(
                                height: 20,
                                width: 60,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: Color(0xffE52E22),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    // Handle refuse button tap
                                  },
                                  style: ButtonStyle(
                                    padding:
                                        MaterialStateProperty.all<EdgeInsets>(
                                      EdgeInsets.zero,
                                    ),
                                  ),
                                  child: Text(
                                    'Refuser',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Lato',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
