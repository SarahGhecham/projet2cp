import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/pages/home/components/home_header.dart';
import 'package:flutter_application_proj2cp/pages/home/components/service_populair_container.dart';
import 'package:flutter_application_proj2cp/pages/home/components/domain_container.dart';
import 'package:flutter_application_proj2cp/pages/home/components/bar_recherche.dart';

import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static String routeName = '/home';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //custom appBar
              HomeHeader(),
              BarRecherche(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Nos Domaines',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 250,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  children: const [
                    DomaineContainer(
                      image: 'assets/images/domaines/plomberie.jpg',
                      serviceName: 'Plomberie',
                    ),
                    DomaineContainer(
                      image: 'assets/images/domaines/electricite.jpg',
                      serviceName: 'Eléctricité',
                    ),
                    DomaineContainer(
                      image: 'assets/images/domaines/nettoyage.jpg',
                      serviceName: 'Nettoyage',
                    ),
                    DomaineContainer(
                      image: 'assets/images/domaines/peinture.jpg',
                      serviceName: 'Peinture',
                    ),
                    DomaineContainer(
                      image: 'assets/images/domaines/jardinage.jpg',
                      serviceName: 'Jardinage',
                    ),
                    DomaineContainer(
                      image: 'assets/images/domaines/maconnerie.jpg',
                      serviceName: 'Maçonnerie',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Services Populaires',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  children: const [
                    ServiceOffreContainer(
                        image:
                            'assets/images/servicesPopulaires/servicePopulaire1.png'),
                    ServiceOffreContainer(
                        image:
                            'assets/images/servicesPopulaires/servicePopulaire2.png'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Offres Spéciales',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 220,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  children: const [
                    ServiceOffreContainer(
                        image:
                            'assets/images/offresSpecials/offreSpecial1.jpg'),
                    ServiceOffreContainer(
                        image:
                            'assets/images/offresSpecials/offreSpecial2.jpg'),
                  ],
                ),
              ),
              SizedBox(
                height: 80,
              )
            ],
          ),
        ),
      ),
    );
  }
}
