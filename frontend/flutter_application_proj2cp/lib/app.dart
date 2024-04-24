import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/constants/constants.dart';
import 'package:flutter_application_proj2cp/pages/ajouter_domaine.dart';
import 'package:flutter_application_proj2cp/pages/connexion.dart';
import 'package:flutter_application_proj2cp/pages/connexionweb.dart';
import 'package:flutter_application_proj2cp/pages/entree/pagesentree.dart';
import 'package:flutter_application_proj2cp/pages/profile_screen.dart';
import 'package:flutter_application_proj2cp/pages/profile_screen.dart';
import 'package:flutter_application_proj2cp/pages/home/home_page_client.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_application_proj2cp/widgets/bottom_nav_bar.dart';
import 'package:flutter_application_proj2cp/lancer_demande3.dart';
import 'package:flutter_application_proj2cp/lancer_demande3Web.dart';
import 'package:flutter_application_proj2cp/demande_confirmé.dart';
import 'package:flutter_application_proj2cp/lancer_demande2.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_application_proj2cp/lancer_demande1.dart';
import 'package:flutter_application_proj2cp/lancer_demande1Web.dart';
import 'package:flutter_application_proj2cp/pages/mademande.dart';
import 'package:flutter_application_proj2cp/details_prestation.dart';



class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
    return ScreenUtilInit(
      designSize: const Size(393, 808),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Beaver',
          /*theme: ThemeData(
            iconTheme: const IconThemeData(color: vertClair),
          ),*/
          home: Lancerdemande1Page(),
        );
      },

      //child: const HomePage(title: 'First Method'),
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