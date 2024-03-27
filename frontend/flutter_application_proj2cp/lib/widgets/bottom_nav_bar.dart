import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/constants/constants.dart';
import 'package:flutter_application_proj2cp/pages/home/home_page_client.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  // Define your page views
  final List<Widget> _pages = [
    HomeScreen(),
    //ActivityScreen(),
    //MessagesScreen(),
    //ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _pages[_selectedIndex],
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: Container(
                height: 56,
                padding: const EdgeInsets.all(12),
                margin:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                decoration: BoxDecoration(
                  color: vertFonce,
                  borderRadius: const BorderRadius.all(Radius.circular(27)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => _onItemTapped(0),
                      child: Image.asset(
                        _selectedIndex == 0
                            ? 'assets/icons/home_select.png'
                            : 'assets/icons/home.png',
                        width: 25,
                        height: 25,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _onItemTapped(1),
                      child: Image.asset(
                        _selectedIndex == 1
                            ? 'assets/icons/activity_select.png'
                            : 'assets/icons/activity.png',
                        width: 30,
                        height: 30,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _onItemTapped(2),
                      child: Image.asset(
                        _selectedIndex == 2
                            ? 'assets/icons/messages_select.png'
                            : 'assets/icons/messages.png',
                        width: 30,
                        height: 30,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _onItemTapped(3),
                      child: Image.asset(
                        _selectedIndex == 3
                            ? 'assets/icons/profile_select.png'
                            : 'assets/icons/profile.png',
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
