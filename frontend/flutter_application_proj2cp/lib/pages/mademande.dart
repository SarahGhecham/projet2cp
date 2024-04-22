// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

// Modèle de prestation
class demande {
  final String name;
  final String description;
  final String imageUrl;
  final double note;

  demande({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.note,
  });
}

class mademandePage extends StatelessWidget {
  // Données fictives pour les prestations
  final List<demande> demandes = [
    demande(
      name: 'Islam Djennad ',
      description: 'Description de la prestation 1',
      imageUrl:
          'https://media.istockphoto.com/id/134248179/fr/photo/construction-travaillant-putting-pl%C3%A2tre-sur-un-mur.jpg?s=612x612&w=0&k=20&c=dNwrcFueXuo1O_9k24gClYJ9erbB2D6MglFkWzX1AcM=',
      note: 4.2,
    ),
    demande(
      name: 'Islam Djennad ',
      description: 'Description de la prestation 1',
      imageUrl:
          'https://media.istockphoto.com/id/134248179/fr/photo/construction-travaillant-putting-pl%C3%A2tre-sur-un-mur.jpg?s=612x612&w=0&k=20&c=dNwrcFueXuo1O_9k24gClYJ9erbB2D6MglFkWzX1AcM=',
      note: 4.2,
    ),
    demande(
      name: 'Islam Djennad ',
      description: 'Description de la prestation 1',
      imageUrl:
          'https://media.istockphoto.com/id/134248179/fr/photo/construction-travaillant-putting-pl%C3%A2tre-sur-un-mur.jpg?s=612x612&w=0&k=20&c=dNwrcFueXuo1O_9k24gClYJ9erbB2D6MglFkWzX1AcM=',
      note: 3.7,
    ),
    demande(
      name: 'Islam Djennad ',
      description: 'Description de la prestation 1',
      imageUrl:
          'https://media.istockphoto.com/id/134248179/fr/photo/construction-travaillant-putting-pl%C3%A2tre-sur-un-mur.jpg?s=612x612&w=0&k=20&c=dNwrcFueXuo1O_9k24gClYJ9erbB2D6MglFkWzX1AcM=',
      note: 4.2,
    ),
    demande(
      name: 'Islam Djennad ',
      description: 'Description de la prestation 1',
      imageUrl:
          'https://media.istockphoto.com/id/134248179/fr/photo/construction-travaillant-putting-pl%C3%A2tre-sur-un-mur.jpg?s=612x612&w=0&k=20&c=dNwrcFueXuo1O_9k24gClYJ9erbB2D6MglFkWzX1AcM=',
      note: 4.2,
    ),
    demande(
      name: 'Mouloud Karim',
      description: 'Description de la prestation 2',
      imageUrl: 'https://via.placeholder.com/150',
      note: 4.7,
    ),
    demande(
      name: 'Ghiles Fernan',
      description: 'Description de la prestation 3',
      imageUrl: 'https://via.placeholder.com/150',
      note: 3.9,
    ),
  ];

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 70),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 81),
                Center(
                  child: Text(
                    // Title text inside the container
                    'Ma demande',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Lato',
                    ),
                  ),
                ),
                /* RotatedBox(
      quarterTurns:
          3, // Rotate the icon 90 degrees counter-clockwise
      child: IconButton(
        icon: Icon(Icons.more_vert), // Three horizontal points icon
        onPressed: () {
          // Handle settings button press
          // Implement your settings functionality here
        },
      ),
    ),*/
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 35.0, top: 15.0),
                        width: 211,
                        height: 59,
                        child: Opacity(
                          opacity: 0.8,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFD6E3DC),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      color: Color(0xff05564B),
                                      size: 16,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "14/12/2024 16 h",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Lato',
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 2),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.place,
                                      color: Color(0xff05564B),
                                      size: 16,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "cite 500 logts bejaia",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Lato',
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Container(
                        margin: EdgeInsets.only(top: 15.0),
                        width: 92,
                        height: 58,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            demandes[0].imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Description',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          fontFamily: 'Lato',
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.0, left: 35),
                    width: 322,
                    height: 79,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(220, 200, 197, 1).withOpacity(0.22),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Color.fromRGBO(220, 200, 197, 1),
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Some text inside the container",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: demandes.length,
                    itemBuilder: (context, index) {
                      bool isFirstItem = index == 0;
                      return Container(
                        height: 77,
                        width: 323,
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
                                  margin: EdgeInsets.only(left: 10, top: 14),
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(45),
                                    child: Image.network(
                                      demandes[index].imageUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 13),
                                          child: Row(
                                            children: [
                                              Text(
                                                demandes[index].name,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'Lato',
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                              Icon(Icons.star,
                                                  color: Color(0xffFABB05)),
                                              SizedBox(width: 0.5),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 8),
                                                child: Text(
                                                  '${demandes[index].note}  ',
                                                  style: TextStyle(
                                                    fontSize: 8,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'Lato',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Positioned(
                              bottom: 15,
                              right: 15,
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 17,
                                    margin: EdgeInsets.only(right: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: InkWell(
                                      onTap: () {},
                                      child: Center(
                                        child: Text(
                                          'Accepter',
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
                                  Container(
                                    width: 50,
                                    height: 17,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: InkWell(
                                      onTap: () {},
                                      child: Center(
                                        child: Text(
                                          'Refuser',
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
