import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/constants/constants.dart';
import 'package:flutter_application_proj2cp/pages/pagesentree.dart';
import 'package:flutter_application_proj2cp/widgets/bottom_nav_bar.dart';

import 'package:flutter_application_proj2cp/pages/home_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
    return ScreenUtilInit(
      designSize: const Size(393, 808),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (context, child) {
        return const GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Beaver',
          /*theme: ThemeData(
            iconTheme: const IconThemeData(color: vertClair),
          ),*/
          home: BottomNavBar(),
        );
      },

      //child: const HomePage(title: 'First Method'),
    );
  }
}
