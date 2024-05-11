import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_proj2cp/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentPage extends StatefulWidget {
  @override
  _CommentPageState createState() => _CommentPageState();
}

class Commentaire {
  final String commentaire;
  final double note;
  final Map<String, dynamic> client;
  final Map<String, dynamic> prestation;

  Commentaire({
    required this.commentaire,
    required this.note,
    required this.client,
    required this.prestation,
  });

  factory Commentaire.fromJson(Map<String, dynamic> json) {
    return Commentaire(
      commentaire: json['commentaire'],
      note: double.parse(json['note']),
      client: json['client'],
      prestation: json['prestation'],
    );
  }
}

class _CommentPageState extends State<CommentPage> {
  int visibleComments = 5; // Number of comments initially visible
  List<Commentaire> commentaires = [];

  Future<void> fetchCommentaires() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        // Handle case where token is not available
        return;
      }

      final response = await http.get(
        Uri.parse(
            'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/artisan/ConsulterCommentaires'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> commentairesData = data['commentaires'];

        setState(() {
          commentaires.clear(); // Clear existing commentaires
          commentairesData.forEach((commentaireData) {
            commentaires.add(Commentaire.fromJson(commentaireData));
          });
        });
      } else {
        throw Exception('Failed to load commentaires');
      }
    } catch (error) {
      print('Error fetching commentaires: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCommentaires();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Commentaires',
          style: TextStyle(
            fontFamily: 'Lato',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Add functionality to navigate back
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Display visible comments
            for (int i = 0; i < visibleComments; i++)
              if (i < commentaires.length)
                CommentCard(
                  commentaire: commentaires[i],
                ),
            // "Voir plus" button
            if (visibleComments < commentaires.length)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    visibleComments += 2;
                    if (visibleComments > commentaires.length) {
                      visibleComments = commentaires.length;
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF05564B),
                  minimumSize: Size(60, 23),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Voir plus',
                  style: TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class Comment {
  final String customerName;
  final String serviceName;
  final String comment;

  Comment({
    required this.customerName,
    required this.serviceName,
    required this.comment,
  });
}

bool ecologique = true;

class CommentCard extends StatelessWidget {
  final Commentaire commentaire;

  CommentCard({
    required this.commentaire,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Color(0xffF7F3F2),
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 36.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: AssetImage('assets/artisan.jpg'),
                      radius: 35.0,
                    ),
                  ),
                  Center(
                    child: Text(
                      commentaire.client['username'],
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: commentaire.prestation['NomPrestation'],
                            style: GoogleFonts.lato(
                              color: const Color(0xFF05564B),
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (ecologique) ...[
                            WidgetSpan(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: SvgPicture.asset(
                                  'assets/leaf.svg',
                                  color:
                                  const Color(0xff05564B).withOpacity(0.6),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: 25.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xffD6E3DC),
                        border: Border.all(color: Color(0xff05564B)),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        commentaire.commentaire,
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                    SizedBox(height: 45.0),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 0.0,
            left: 2.0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 20.0,
                ),
                SizedBox(width: 2.0),
                Text(
                  commentaire.note.toString(), // Note of the artisan
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 11.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}