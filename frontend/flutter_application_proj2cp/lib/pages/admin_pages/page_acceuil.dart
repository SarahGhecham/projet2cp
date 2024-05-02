import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/constants/constants.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/drawer.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/filter_by.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/search_bar.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class HeaderAdmin {
  final String userName;
  final String profilePictureUrl;

  HeaderAdmin({
    required this.userName,
    required this.profilePictureUrl,
  });
}

class CustomChartTitle extends StatelessWidget {
  final String title;
  final IconData iconData;

  const CustomChartTitle({required this.title, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(iconData, color: Colors.black, size: 16),
        SizedBox(width: 5),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
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
  int _nombreClients = 0;
  int _nombreArtisans = 0;
  int _nombreDemandes = 0;

  String selectedFilter = 'Jour'; // Initialize with default filter
  @override
  void initState() {
    super.initState();
    _loadStatistics(); // Load statistics when the widget initializes
  }

  Future<void> _loadStatistics() async {
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:3000/admins/obtenirStatistiques'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _nombreClients = data['nombreClients'];
          _nombreArtisans = data['nombreArtisans'];
          _nombreDemandes = data['nombreDemandes'];
        });
      } else {
        throw Exception('Failed to load statistics');
      }
    } catch (e) {
      print('Error loading statistics: $e');
    }
  }

  void updateChartData(String filter) {
    setState(() {
      selectedFilter = filter;
    });
  }

  List<charts.Series<ArtisansInscris, String>> _getSeriesDataArtisans() {
    List<ArtisansInscris> filteredData = dataArtisans;

    // Filter data based on selected filter
    if (selectedFilter == 'Jour') {
      filteredData = dataArtisans; // Use original data
    } else if (selectedFilter == 'Semaine') {
      // Update data for the week based on logic to group daily data
      filteredData = [];
      int weeklyInscriptions = 0;
      for (var item in data) {
        if (int.parse(item.jour) <= 7) {
          weeklyInscriptions += item.inscriptions;
        } else {
          filteredData.add(ArtisansInscris(
              jour: ((data.indexOf(item) / 7).floor() + 1).toString(),
              inscriptions: weeklyInscriptions,
              barColor: charts.ColorUtil.fromDartColor(crevette)));
          weeklyInscriptions = item.inscriptions;
        }
      }
      // Add the last week's data if needed
      if (weeklyInscriptions > 0) {
        filteredData.add(ArtisansInscris(
            jour: ((data.length / 7).floor() + 1).toString(),
            inscriptions: weeklyInscriptions,
            barColor: charts.ColorUtil.fromDartColor(crevette)));
      }
    } else if (selectedFilter == 'Mois') {
      // Update data for the month based on logic to group daily data
      filteredData = [];
      int monthlyInscriptions = 0;
      for (var item in data) {
        if (int.parse(item.jour) <= 30) {
          monthlyInscriptions += item.inscriptions;
        } else {
          filteredData.add(ArtisansInscris(
              jour: ((data.indexOf(item) / 30).floor() + 1).toString(),
              inscriptions: monthlyInscriptions,
              barColor: charts.ColorUtil.fromDartColor(crevette)));
          monthlyInscriptions = item.inscriptions;
        }
      }
      // Add the last month's data if needed
      if (monthlyInscriptions > 0) {
        filteredData.add(ArtisansInscris(
            // Typo corrected here
            jour: ((data.length / 30).floor() + 1).toString(),
            inscriptions: monthlyInscriptions,
            barColor: charts.ColorUtil.fromDartColor(crevette)));
      }
    }

    // Always return a list even if filteredData is empty
    return [
      charts.Series(
        id: "Artisans Inscrits",
        data: filteredData,
        domainFn: (ArtisansInscris series, _) => series.jour.toString(),
        measureFn: (ArtisansInscris series, _) => series.inscriptions,
        colorFn: (ArtisansInscris series, _) => series.barColor,
      )
    ];
  }

  List<charts.Series<ClientsInscris, String>> _getSeriesData() {
    List<ClientsInscris> filteredData = data;

    // Filter data based on selected filter
    if (selectedFilter == 'Jour') {
      filteredData = data; // Use original data
    } else if (selectedFilter == 'Semaine') {
      // Update data for the week based on logic to group daily data
      filteredData = [];
      int weeklyInscriptions = 0;
      for (var item in data) {
        if (int.parse(item.jour) <= 7) {
          weeklyInscriptions += item.inscriptions;
        } else {
          filteredData.add(ClientsInscris(
              jour: ((data.indexOf(item) / 7).floor() + 1).toString(),
              inscriptions: weeklyInscriptions,
              barColor: charts.ColorUtil.fromDartColor(crevette)));
          weeklyInscriptions = item.inscriptions;
        }
      }
      // Add the last week's data if needed
      if (weeklyInscriptions > 0) {
        filteredData.add(ClientsInscris(
            jour: ((data.length / 7).floor() + 1).toString(),
            inscriptions: weeklyInscriptions,
            barColor: charts.ColorUtil.fromDartColor(crevette)));
      }
    } else if (selectedFilter == 'Mois') {
      // Update data for the month based on logic to group daily data
      filteredData = [];
      int monthlyInscriptions = 0;
      for (var item in data) {
        if (int.parse(item.jour) <= 30) {
          monthlyInscriptions += item.inscriptions;
        } else {
          filteredData.add(ClientsInscris(
              jour: ((data.indexOf(item) / 30).floor() + 1).toString(),
              inscriptions: monthlyInscriptions,
              barColor: charts.ColorUtil.fromDartColor(crevette)));
          monthlyInscriptions = item.inscriptions;
        }
      }
      // Add the last month's data if needed
      if (monthlyInscriptions > 0) {
        filteredData.add(ClientsInscris(
            // Typo corrected here
            jour: ((data.length / 30).floor() + 1).toString(),
            inscriptions: monthlyInscriptions,
            barColor: charts.ColorUtil.fromDartColor(crevette)));
      }
    }

    // Always return a list even if filteredData is empty
    return [
      charts.Series(
        id: "Clients Inscrits",
        data: filteredData,
        domainFn: (ClientsInscris series, _) => series.jour.toString(),
        measureFn: (ClientsInscris series, _) => series.inscriptions,
        colorFn: (ClientsInscris series, _) => series.barColor,
      )
    ];
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
                      child: Image.asset(
                        'assets/icons/notifs.png',
                        height: 30,
                        width: 30,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10), // Spacer between the two rows
              Padding(
                padding: const EdgeInsets.only(left: 25.0), // Adjusted padding
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
                    SizedBox(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: vertClair,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        width: 300,
                        child: charts.BarChart(
                          _getSeriesDataArtisans(),
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
                  ],
                ),
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
                    SizedBox(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: vertClair,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        width: 300,
                        child: charts.BarChart(
                          _getSeriesDataArtisans(),
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
                  ],
                ),
              ),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ClientsInscris {
  final String jour;
  final int inscriptions;
  final charts.Color barColor;

  ClientsInscris({
    this.jour = '', // Default value for jour
    this.inscriptions = 0, // Default value for inscriptions
    required this.barColor,
  });
}

class ArtisansInscris {
  final String jour;
  final int inscriptions;
  final charts.Color barColor;

  ArtisansInscris({
    this.jour = '', // Default value for jour
    this.inscriptions = 0, // Default value for inscriptions
    required this.barColor,
  });
}

final List<ClientsInscris> data = [
  ClientsInscris(
      jour: '01',
      inscriptions: 100,
      barColor: charts.ColorUtil.fromDartColor(crevette)),
  ClientsInscris(
      jour: '02',
      inscriptions: 39,
      barColor: charts.ColorUtil.fromDartColor(crevette)),
  ClientsInscris(
      jour: '03',
      inscriptions: 22,
      barColor: charts.ColorUtil.fromDartColor(crevette)),
  ClientsInscris(
      jour: '04',
      inscriptions: 401,
      barColor: charts.ColorUtil.fromDartColor(crevette)),
  ClientsInscris(
      jour: '05',
      inscriptions: 300,
      barColor: charts.ColorUtil.fromDartColor(crevette)),
  ClientsInscris(
      jour: '06',
      inscriptions: 12,
      barColor: charts.ColorUtil.fromDartColor(crevette)),
  ClientsInscris(
      jour: '07',
      inscriptions: 110,
      barColor: charts.ColorUtil.fromDartColor(crevette)),
];

final List<ArtisansInscris> dataArtisans = [
  ArtisansInscris(
      jour: '01',
      inscriptions: 100,
      barColor: charts.ColorUtil.fromDartColor(crevette)),
  ArtisansInscris(
      jour: '02',
      inscriptions: 39,
      barColor: charts.ColorUtil.fromDartColor(crevette)),
  ArtisansInscris(
      jour: '03',
      inscriptions: 22,
      barColor: charts.ColorUtil.fromDartColor(crevette)),
  ArtisansInscris(
      jour: '04',
      inscriptions: 401,
      barColor: charts.ColorUtil.fromDartColor(crevette)),
  ArtisansInscris(
      jour: '05',
      inscriptions: 300,
      barColor: charts.ColorUtil.fromDartColor(crevette)),
  ArtisansInscris(
      jour: '06',
      inscriptions: 12,
      barColor: charts.ColorUtil.fromDartColor(crevette)),
  ArtisansInscris(
      jour: '07',
      inscriptions: 110,
      barColor: charts.ColorUtil.fromDartColor(crevette)),
];
