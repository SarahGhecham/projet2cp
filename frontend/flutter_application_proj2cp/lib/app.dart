import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/constants/constants.dart';
import 'package:flutter_application_proj2cp/logo.dart';
import 'package:flutter_application_proj2cp/pages/activite/activite_client.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/bottom_nav_bar.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/ajouter_domaine.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/drawer_services.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/page_acc_admin.dart';

import 'package:flutter_application_proj2cp/pages/admin_pages/profil_admin.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/profil_client.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/users_clients.dart';

import 'package:flutter_application_proj2cp/pages/artisan/activiteArtisan_encours.dart';
import 'package:flutter_application_proj2cp/pages/artisan/activiteArtisan_termine.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/drawer_users.dart';

import 'package:flutter_application_proj2cp/pages/admin_pages/prestation_provider.dart';
import 'package:flutter_application_proj2cp/pages/connexion.dart';
import 'package:flutter_application_proj2cp/Web/connexionweb.dart';
import 'package:flutter_application_proj2cp/pages/entree/pagesentree.dart';
import 'package:flutter_application_proj2cp/pages/inscription.dart';
import 'package:flutter_application_proj2cp/pages/profile_screen.dart';
import 'package:flutter_application_proj2cp/pages/afficher_prestation.dart';
import 'package:flutter_application_proj2cp/widgets/bottom_nav_bar.dart';

import 'package:flutter_application_proj2cp/pages/home/home_page_client.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/creer_artisan.dart';
import 'package:get/get.dart';
import 'package:flutter_application_proj2cp/widgets/bottom_nav_bar.dart';
import 'package:flutter_application_proj2cp/lancer_demande3.dart';
import 'package:flutter_application_proj2cp/Web/lancer_demande3Web.dart';
import 'package:flutter_application_proj2cp/demande_confirmé.dart';
import 'package:flutter_application_proj2cp/lancer_demande1.dart';
import 'package:flutter_application_proj2cp/details_prestation.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_application_proj2cp/lancer_demande1.dart';
import 'package:flutter_application_proj2cp/demande_lancee.dart';
import 'package:flutter_application_proj2cp/Web/lancer_demande1Web.dart';
import 'package:flutter_application_proj2cp/pages/mademande.dart';
import 'package:flutter_application_proj2cp/details_prestation.dart';
import 'package:flutter_application_proj2cp/rendez-vous_terminée.dart';
import 'package:flutter_application_proj2cp/pages/artisan/detail_demande_lancee.dart';
import 'package:flutter_application_proj2cp/pages/artisan/rendez_vous_termine_artisan.dart';

import 'package:flutter_application_proj2cp/pages/artisan/activiteArtisan_encours.dart';
import 'package:flutter_application_proj2cp/pages/artisan/activite_artisan.dart';

import 'package:provider/provider.dart';

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
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => PrestationInfoProvider()),
          ],
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Beaver',

            /*theme: ThemeData(
              iconTheme: const IconThemeData(color: vertClair),
            ),*/

            home: SplashScreen(),
          ),
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
    return _isLoggedIn ? BottomNavBar() : LogInPage();
  }
}

 */