import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_proj2cp/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentPage2 extends StatefulWidget {
  final int ArtisanId;
  @override
  const CommentPage2({
    Key? key,
    required this.ArtisanId,
  }) : super(key: key);
  @override
  State<CommentPage2> createState() => _CommentPage2State();
}

class _CommentPage2State extends State<CommentPage2> {
  int visibleComments = 5; // Number of comments initially visible
  List<Comment> comments = [];
  late String _token;
  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? '';
    print('Token: $_token');
    await Future.wait([_fetchComments()]);
  }
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> _fetchComments() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://${AppConfig.serverAddress}:${AppConfig.serverPort}/client/ConsulterCommentaires/${widget.ArtisanId}'),
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['commentaires'];
        setState(() {
          comments = data.map((commentData) {
            return Comment(
              customerName: commentData['client']['username'],
              serviceName: commentData['prestation']['NomPrestation'],
              comment: commentData['commentaire'],
            );
          }).toList();
        });
      } else {
        throw Exception('Failed to load comments');
      }
    } catch (error) {
      print('Error fetching comments: $error');
      // Handle error, e.g., display an error message to the user
    }
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
            // Display fetched comments
            if (comments.isNotEmpty)
              for (int i = 0; i < comments.length; i++)
                CommentCard(
                  comment: comments[i],
                ),
            // Add UI for "Voir plus" button if needed
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
  final Comment comment;

  CommentCard({
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
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
                  // Left side - Photo and customer name
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
                      comment.customerName,
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
                            text: comment.serviceName,
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
                        comment.comment,
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),

                    // Row for the buttons
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
                  '4.5', // Replace with the actual rating of the artisan
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