import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/lancer_demande3.dart';
import 'package:flutter_application_proj2cp/profile_artisan.dart';
import 'package:flutter_application_proj2cp/rendez-vous_terminée.dart';
import 'package:flutter_application_proj2cp/demande_confirmé.dart';
import 'package:flutter_application_proj2cp/lancer_demande1.dart';
import 'package:flutter_application_proj2cp/details_prestation.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_application_proj2cp/demande_lancée.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfileartisanPage(),
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