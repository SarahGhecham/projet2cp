import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/constants/constants.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/drawer.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/filter_by.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class HeaderAdmin {
  final String userName;
  final String profilePictureUrl;

  HeaderAdmin({
    required this.userName,
    required this.profilePictureUrl,
  });
}

class BarRecherche extends StatelessWidget {
  const BarRecherche({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0), // Adjusted padding
      child: SizedBox(
        height: 40, // Set the height of the search bar
        child: TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: vertClair,
            hintText: 'Rechercher...',
            hintStyle: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[600],
            ), // Custom hint text style
            prefixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/icons/recherche.png'),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0), // Custom border radius
              borderSide: BorderSide.none, // Remove the border side
            ),
            contentPadding: EdgeInsets.zero, // Remove default content padding
          ),
        ),
      ),
    );
  }
}

class HomeScreenAdmin extends StatefulWidget {
  const HomeScreenAdmin({Key? key}) : super(key: key);

  @override
  State<HomeScreenAdmin> createState() => _HomeScreenAdminState();
}

class _HomeScreenAdminState extends State<HomeScreenAdmin> {
  final HeaderAdmin headerAdmin = HeaderAdmin(
    userName: 'Your Username',
    profilePictureUrl: 'https://picsum.photos/250?image=9',
  );
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentPageIndex = 0;

  String selectedFilter = 'Jour'; // Initialize with default filter

  void updateChartData(String filter) {
    setState(() {
      selectedFilter = filter;
    });
  }

  void onPageSelected(int index) {
    setState(() {
      _currentPageIndex = index;
    });
    // You can add logic here to navigate to different pages based on the index
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerDash(onPageSelected: onPageSelected),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage(headerAdmin.profilePictureUrl),
                      radius: 30,
                    ),
                  ),
                  Text(
                    'Salut ${headerAdmin.userName}',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      //
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Image.asset('assets/icons/notif.png'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10), // Spacer between the two rows
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly, // Space evenly
                children: [
                  // Options icon with adjusted padding
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 25.0), // Adjusted padding
                    child: GestureDetector(
                      onTap: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                      child: SizedBox(
                        width: 30, // Adjusted width
                        height: 30,
                        child: Image.asset(
                          'assets/icons/options.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  // Search bar with expanded flex
                  Expanded(
                    flex: 2, // Give search bar more space (optional)
                    child: BarRecherche(),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 30, 20, 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Overview',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ), // Spacer between the two rows
              SizedBox(
                height: 10,
              ),
              Filtrer(
                onSelectFilter: updateChartData,
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 230,
                //width: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  children: [
                    SizedBox(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: vertClair,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        width: 300,
                        child: charts.BarChart(
                          _getSeriesData(),
                          animate: true,
                          barGroupingType: charts
                              .BarGroupingType.grouped, // Adjust bar width
                          domainAxis: charts.OrdinalAxisSpec(
                            renderSpec: charts.SmallTickRendererSpec(
                              labelRotation: 100,
                              labelStyle: charts.TextStyleSpec(
                                  color: charts.MaterialPalette
                                      .black, // Customize label color
                                  fontSize: 14,
                                  fontFamily:
                                      "poppins" // Customize label font size
                                  ),
                            ),
                          ),
                          primaryMeasureAxis: charts.NumericAxisSpec(
                            renderSpec: charts.GridlineRendererSpec(
                              labelStyle: charts.TextStyleSpec(
                                color: charts.MaterialPalette
                                    .black, // Customize label color
                                fontSize: 14, // Customize label font size
                              ),
                              lineStyle: charts.LineStyleSpec(
                                color: charts.MaterialPalette.gray
                                    .shade400, // Customize gridline color
                              ),
                            ),
                          ),
                          behaviors: [
                            charts.SeriesLegend(
                                position: charts
                                    .BehaviorPosition.bottom), // Add legend

                            charts.PanAndZoomBehavior(), // Enable pan and zoom
                          ],
                          selectionModels: [
                            charts.SelectionModelConfig(
                              type: charts.SelectionModelType.info,
                              changedListener: (model) {
                                if (model.hasDatumSelection) {
                                  print(model.selectedSeries[0]
                                      .measureFn(model.selectedDatum[0].index));
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<charts.Series<UtilisateursInscris, String>> _getSeriesData() {
    List<UtilisateursInscris> filteredData = data;

    // Filter data based on selected filter
    if (selectedFilter == 'Jour') {
      filteredData = data; // Use original data
    } else if (selectedFilter == 'Semaine') {
      // Update data for the week
      // Example:
      // filteredData = updatedDataForWeek;
    } else if (selectedFilter == 'Mois') {
      // Update data for the month
      // Example:
      // filteredData = updatedDataForMonth;
    }

    return [
      charts.Series(
        id: "Clients Inscris",
        data: filteredData,
        domainFn: (UtilisateursInscris series, _) => series.jour.toString(),
        measureFn: (UtilisateursInscris series, _) => series.insriptions,
        colorFn: (UtilisateursInscris series, _) => series.barColor,
      )
    ];
  }
}

class UtilisateursInscris {
  final int jour;
  final int insriptions;
  final charts.Color barColor;

  UtilisateursInscris({
    required this.jour,
    required this.insriptions,
    required this.barColor,
  });
}

final List<UtilisateursInscris> data = [
  UtilisateursInscris(
      jour: 1,
      insriptions: 100,
      barColor: charts.ColorUtil.fromDartColor(crevette)),
  UtilisateursInscris(
      jour: 2,
      insriptions: 39,
      barColor: charts.ColorUtil.fromDartColor(crevette)),
  UtilisateursInscris(
      jour: 3,
      insriptions: 22,
      barColor: charts.ColorUtil.fromDartColor(crevette)),
  UtilisateursInscris(
      jour: 10,
      insriptions: 401,
      barColor: charts.ColorUtil.fromDartColor(crevette)),
  UtilisateursInscris(
      jour: 24,
      insriptions: 300,
      barColor: charts.ColorUtil.fromDartColor(crevette)),
  UtilisateursInscris(
      jour: 25,
      insriptions: 12,
      barColor: charts.ColorUtil.fromDartColor(crevette)),
  UtilisateursInscris(
      jour: 26,
      insriptions: 110,
      barColor: charts.ColorUtil.fromDartColor(crevette)),
];
