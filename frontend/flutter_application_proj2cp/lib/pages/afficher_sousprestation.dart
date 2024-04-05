// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';

// Modèle de prestation
class Prestation {
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final Duration duration;

  Prestation({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.duration,
  });
}

class SousPrestationPage extends StatelessWidget {
  // Données fictives pour les prestations
  final List<Prestation> prestations = [
    Prestation(
      name: 'Prestation 1',
      description: 'Description de la prestation 1',
      imageUrl:
          'https://media.istockphoto.com/id/134248179/fr/photo/construction-travaillant-putting-pl%C3%A2tre-sur-un-mur.jpg?s=612x612&w=0&k=20&c=dNwrcFueXuo1O_9k24gClYJ9erbB2D6MglFkWzX1AcM=',
      price: 50.0,
      duration: Duration(minutes: 30),
    ),
    Prestation(
      name: 'Prestation 2',
      description: 'Description de la prestation 2',
      imageUrl: 'https://via.placeholder.com/150',
      price: 70.0,
      duration: Duration(minutes: 45),
    ),
    Prestation(
      name: 'Prestation 3',
      description: 'Description de la prestation 3',
      imageUrl: 'https://via.placeholder.com/150',
      price: 90.0,
      duration: Duration(hours: 1),
    ),
  ];

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
                SizedBox(width: 105),
                Align(
                  alignment: Alignment.center,
                  child: Center(
                    child: Text(
                      'Peinture',
                      style: TextStyle(
                        color: Color(0xff05564B),
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: prestations.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 95,
                  width: 335,
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color(0xFFD6E3DC),
                  ),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        width: 80,
                        height: 74,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            prestations[index].imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              prestations[index].name,
                              style: TextStyle(
                                color: Color(0xff05564B),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '${prestations[index].price} € ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '${prestations[index].duration.inMinutes} min',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
