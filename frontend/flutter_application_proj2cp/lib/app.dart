import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/constants/constants.dart';
import 'package:flutter_application_proj2cp/lancer_demande1.dart';
import 'package:flutter_application_proj2cp/pages/connexion.dart';
import 'package:flutter_application_proj2cp/pages/entree/pagesentree.dart';
import 'package:flutter_application_proj2cp/widgets/bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_proj2cp/pages/home/home_page_client.dart';
import 'package:flutter_application_proj2cp/lancer_demande1.dart';
import 'package:flutter_application_proj2cp/lancer_demande2.dart';
import 'package:flutter_application_proj2cp/lancer_demande3.dart';
import 'package:flutter_application_proj2cp/details_prestation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';



class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Lancerdemande1Page(), // Use AppNavigator as the home widget
    );
  }
}
/*
class AppNavigator extends StatefulWidget {
  @override
  _AppNavigatorState createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    setState(() {
      _isLoggedIn = token != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn ? HomeScreen() : LogInPage();
  }
}

 */