import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/pages/pagesentree.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PageEntree(),
    );
  }
}
