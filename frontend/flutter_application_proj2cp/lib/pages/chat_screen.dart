import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> _messages = [];
  TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController =
      ScrollController(); // Add ScrollController

  @override
  void initState() {
    super.initState();
    // Simulate initial messages
    _messages = [
      Message(content: "Hello", isSender: false),
      Message(content: "Hi there!", isSender: true),
      Message(content: "How are you?", isSender: false),
      Message(content: "I'm good, thank you!", isSender: true),
    ];
  }

  void _sendMessage(String content) {
    setState(() {
      _messages.add(Message(content: content, isSender: true));
    });

    // Clear the message input field
    _messageController.clear();

    // Scroll to the bottom of the list
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  AssetImage('assets/artisan.jpg'), // Add artisan image
              radius: 16.0,
            ),
            SizedBox(width: 8.0),
            Text(
              'Artisan Name',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xFFD6E3DC), // Background color of the chat page
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController, // Assign the ScrollController
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    final isSentByUser = message.isSender;
    final bgColor = isSentByUser ? Color(0xFFFF8787) : Color(0xFFF7F3F2);
    final borderRadius = isSentByUser
        ? BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
            bottomLeft: Radius.circular(16.0),
            bottomRight: Radius.circular(4.0),
          )
        : BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
            bottomLeft: Radius.circular(4.0),
            bottomRight: Radius.circular(16.0),
          );
    return Row(
      mainAxisAlignment:
          isSentByUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: borderRadius,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.content,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                _getTime(),
                style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white, // White background color for sender message input
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(width: 8.0),
          IconButton(
            icon: SvgPicture.asset('assets/send.svg'),
            onPressed: () {
              String messageContent = _messageController.text.trim();
              if (messageContent.isNotEmpty) {
                _sendMessage(messageContent);
              }
            },
          ),
        ],
      ),
    );
  }

  // Function to get current time in Algeria timezone
  String _getTime() {
    var algeriaTime = DateTime.now().toUtc().add(Duration(hours: 1));
    return DateFormat('HH:mm').format(algeriaTime);
  }

  // Function to scroll to the last message
  void _scrollToLastMessage() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}

class Message {
  final String content;
  final bool isSender;

  Message({required this.content, required this.isSender});
}

/*void main() {
  runApp(MaterialApp(
    home: ChatScreen(),
    debugShowCheckedModeBanner: false, // Remove debug banner
  ));
}*/
