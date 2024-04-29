import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:table_calendar/table_calendar.dart';
import 'package:image_picker/image_picker.dart';

class ProfileartisanPage extends StatefulWidget {
  const ProfileartisanPage({super.key});

  @override
  _ProfileartisanPageState createState() => _ProfileartisanPageState();
}

class _ProfileartisanPageState extends State<ProfileartisanPage> {
  @override
  var note = "4.5";
  final _debutController = TextEditingController();
  final _finController = TextEditingController();
  int day = 0;
  @override
  void initState() {
    super.initState();
    day = 0; // Set initial day to 0
  }

  void changeDayValue(int newValue) {
    setState(() {
      day = newValue; // Update the value of day
    });
  }

  final ImagePicker _imagePicker = ImagePicker();
  var _pickedImagePath = null; // var jsp si c ccorrect hna
  TextEditingController _NomController = TextEditingController();
  TextEditingController _PrenomController = TextEditingController();
  TextEditingController _PhoneController = TextEditingController();
  TextEditingController _EmailController = TextEditingController();
  TextEditingController _RayonController = TextEditingController();
  TextEditingController _AdresseController = TextEditingController();
  bool _isEditing = false;

  void _toggleEditing(bool value) {
    setState(() {
      _isEditing = value;
    });
  }

  bool _showOngoing = true;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  List<DateTime> highlightedDates = [
    DateTime(2024, 4, 27),
    DateTime(2024, 4, 28),
    DateTime(2024, 4, 29),
  ];

  int selectedDayIndex = 0;
  Map<int, Map<TimeOfDay, TimeOfDay>> allHoraires = {
    0: {
      // horaire0
      TimeOfDay(hour: 10, minute: 30): TimeOfDay(hour: 11, minute: 30),
      TimeOfDay(hour: 13, minute: 30): TimeOfDay(hour: 16, minute: 00),
    },
    1: {
      // horaire1
      TimeOfDay(hour: 8, minute: 00): TimeOfDay(hour: 9, minute: 30),
      TimeOfDay(hour: 14, minute: 00): TimeOfDay(hour: 17, minute: 00),
    },
    2: {
      // horaire2
      TimeOfDay(hour: 8, minute: 00): TimeOfDay(hour: 9, minute: 30),
      TimeOfDay(hour: 14, minute: 00): TimeOfDay(hour: 17, minute: 00),
    },
    3: {
      // horaire3
      TimeOfDay(hour: 8, minute: 00): TimeOfDay(hour: 9, minute: 30),
      TimeOfDay(hour: 14, minute: 00): TimeOfDay(hour: 17, minute: 00),
    },
    4: {
      // horaire4
      TimeOfDay(hour: 8, minute: 00): TimeOfDay(hour: 9, minute: 30),
      TimeOfDay(hour: 14, minute: 00): TimeOfDay(hour: 17, minute: 00),
    },
    5: {
      // horaire5
      TimeOfDay(hour: 8, minute: 00): TimeOfDay(hour: 9, minute: 30),
      TimeOfDay(hour: 14, minute: 00): TimeOfDay(hour: 17, minute: 00),
    },
    6: {
      // horaire6
      TimeOfDay(hour: 9, minute: 00): TimeOfDay(hour: 3, minute: 20),
      TimeOfDay(hour: 1, minute: 00): TimeOfDay(hour: 18, minute: 00),
    },
  };

  String _formatTime(TimeOfDay time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  void removeTimeRange(int day, TimeOfDay startTime, TimeOfDay endTime) {
    setState(() {
      allHoraires[day]?.removeWhere((key, value) =>
          (key.hour == startTime.hour && key.minute == startTime.minute) &&
          (value.hour == endTime.hour && value.minute == endTime.minute));
    });
  }

  void addTimeRange(int day, TimeOfDay startTime, TimeOfDay endTime) {
    setState(() {
      if (allHoraires[day] == null) {
        // Day doesn't exist in the map yet, create a new Map for it
        allHoraires[day] = {};
      }

      allHoraires[day]![startTime] = endTime;
    });
  }

  TimeOfDay stringToTimeOfDay(String timeString) {
    // Split the string at the colon (":")
    List<String> parts = timeString.split(":");

    // Ensure we have two parts (hour and minute)
    if (parts.length != 2) {
      throw FormatException("Invalid time format. Expected 'HH:MM'.");
    }

    // Parse hour and minute as integers
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    // Validate hour (0-23) and minute (0-59)
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      throw FormatException(
          "Invalid time values. Hour must be between 0 and 23, and minute must be between 0 and 59.");
    }

    // Return the TimeOfDay object
    return TimeOfDay(hour: hour, minute: minute);
  }

  Widget build(BuildContext context) {
    Map<TimeOfDay, TimeOfDay> currentHoraire = allHoraires[day] ?? {};
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: SizedBox(
              width: 32,
              height: 32,
              child: Image.asset('assets/images/settings.png'),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    if (_isEditing) {
                      final picker = ImagePicker();
                      final pickedFile = await picker.getImage(
                        source: ImageSource.gallery,
                      );

                      if (pickedFile != null) {
                        setState(() {
                          File imageFile = File(pickedFile.path);
                        });
                      }
                    }
                  },
                  child: Container(
                    width: 150,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.grey[200],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: Image.asset(
                        'assets/artisan.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Note",
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF05564B)),
                  ),
                  Row(
                    children: [
                      SvgPicture.asset("assets/star.svg"),
                      Text(
                        note,
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF05564B)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Disponibilité",
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF05564B)),
                  ),
                  Container(
                    height: 30,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFF7F3F2),
                      border: Border.all(color: Color(0xFF05564B)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF15AC3F),
                          ),
                        ),
                        Text(
                          "Disponible",
                          style: GoogleFonts.poppins(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Domaine",
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF05564B)),
                  ),
                  Container(
                    height: 30,
                    width: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFF7F3F2),
                      border: Border.all(color: Color(0xFF05564B)),
                    ),
                    child: Center(
                      child: Text(
                        "Nettoyage",
                        style: GoogleFonts.poppins(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                minimumSize:
                    MaterialStateProperty.all<Size>(const Size(315, 30)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xFFFF8787)),
              ),
              child: Text(
                "Préstations proposées",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Informations personnelles",
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF05564B)),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Nom",
                  style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 400,
                  height: 41,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCC8C5).withOpacity(0.22),
                    border: Border.all(
                      color: const Color(0xFFDCC8C5),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _isEditing
                      ? TextFormField(
                          controller: _NomController,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Nom",
                            hintStyle: GoogleFonts.poppins(
                              color: const Color(0xFF777777),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 16.0,
                            ),
                            border: InputBorder.none,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 16.0),
                          child: Text(
                            "Nom",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Prénom",
                  style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 400,
                  height: 41,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCC8C5).withOpacity(0.22),
                    border: Border.all(
                      color: const Color(0xFFDCC8C5),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _isEditing
                      ? TextFormField(
                          controller: _PrenomController,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Prénom",
                            hintStyle: GoogleFonts.poppins(
                              color: const Color(0xFF777777),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 16.0,
                            ),
                            border: InputBorder.none,
                          ),
                        )
                      : Text(
                          "Prénom",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Numéro de téléphone",
                  style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 400,
                  height: 41,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCC8C5).withOpacity(0.22),
                    border: Border.all(
                      color: const Color(0xFFDCC8C5),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _isEditing
                      ? TextFormField(
                          controller: _PhoneController,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Numéro Téléphone",
                            hintStyle: GoogleFonts.poppins(
                              color: const Color(0xFF777777),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 16.0,
                            ),
                            border: InputBorder.none,
                          ),
                        )
                      : Text(
                          "Téléphone",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Email",
                  style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 400,
                  height: 41,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCC8C5).withOpacity(0.22),
                    border: Border.all(
                      color: const Color(0xFFDCC8C5),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _isEditing
                      ? TextFormField(
                          controller: _EmailController,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: GoogleFonts.poppins(
                              color: const Color(0xFF777777),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 16.0,
                            ),
                            border: InputBorder.none,
                          ),
                        )
                      : Text(
                          "Email",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Adresse",
                  style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 400,
                  height: 41,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCC8C5).withOpacity(0.22),
                    border: Border.all(
                      color: const Color(0xFFDCC8C5),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _isEditing
                      ? TextFormField(
                          controller: _AdresseController,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Adresse",
                            hintStyle: GoogleFonts.poppins(
                              color: const Color(0xFF777777),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 16.0,
                            ),
                            border: InputBorder.none,
                          ),
                        )
                      : Text(
                          "Adresse",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Rayon géographique",
                  style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 400,
                  height: 41,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCC8C5).withOpacity(0.22),
                    border: Border.all(
                      color: const Color(0xFFDCC8C5),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _isEditing
                      ? TextFormField(
                          controller: _RayonController,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Rayon",
                            hintStyle: GoogleFonts.poppins(
                              color: const Color(0xFF777777),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 16.0,
                            ),
                            border: InputBorder.none,
                          ),
                        )
                      : Text(
                          "Rayon ",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        if (_isEditing) {
                          _toggleEditing(false);
                        } else {
                          _toggleEditing(true);
                        }
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(
                            const Size(100, 35)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFFFF8787)),
                      ),
                      child: Text(
                        _isEditing ? "Valider" : "Editer",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PreferredSize(
                  preferredSize: Size.fromHeight(70.0),
                  child: SizedBox(
                    width: 270,
                    height: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFDCC8C5).withOpacity(0.22),
                        border:
                            Border.all(color: Color(0xFFDCC8C5), width: 1.5),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _showOngoing = false;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: _showOngoing
                                    ? Color(0xFF05564B)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 35, vertical: 5),
                              child: Text(
                                'RDV',
                                style: TextStyle(
                                  color: _showOngoing
                                      ? Colors.white
                                      : Color(0xFFDCC8C5).withOpacity(0.22),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _showOngoing = true;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: !_showOngoing
                                    ? Color(0xFF05564B)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 35, vertical: 5),
                              child: Text(
                                'Horaires',
                                style: TextStyle(
                                  color: !_showOngoing
                                      ? Colors.white
                                      : Color(0xFFDCC8C5).withOpacity(0.22),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Visibility(
              visible: _showOngoing,
              child: Container(
                height: 400,
                width: 335,
                decoration: BoxDecoration(
                  color: const Color(0xFFD6E3DC),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TableCalendar(
                  locale: 'en_US',
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (DateTime date) {
                    // Return true if the date is in the list of highlightedDates, false otherwise
                    return highlightedDates.contains(date);
                  },
                  calendarStyle: CalendarStyle(
                    defaultTextStyle:
                        GoogleFonts.poppins(fontSize: 16, color: Colors.black),
                    selectedDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFF8787),
                    ),
                    todayDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFF8787).withOpacity(0.22),
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  availableGestures: AvailableGestures.all,
                  focusedDay: _focusedDay,
                  firstDay: DateTime(2010, 10, 16),
                  lastDay: DateTime(2030, 3, 14),
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  },
                ),
              ),
            ),
            Visibility(
              visible: !_showOngoing,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          changeDayValue(0);
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: day == 0
                                ? Color(0xFF05564B)
                                : Color(0xFFD6E3DC),
                          ),
                          child: Center(
                            child: Text(
                              "Dim",
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          changeDayValue(1);
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: day == 1
                                ? Color(0xFF05564B)
                                : Color(0xFFD6E3DC),
                          ),
                          child: Center(
                              child: Text(
                            "Lun",
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          changeDayValue(2);
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: day == 2
                                ? Color(0xFF05564B)
                                : Color(0xFFD6E3DC),
                          ),
                          child: Center(
                              child: Text(
                            "Mar",
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          changeDayValue(3);
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: day == 3
                                ? Color(0xFF05564B)
                                : Color(0xFFD6E3DC),
                          ),
                          child: Center(
                              child: Text(
                            "Mer",
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          changeDayValue(4);
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: day == 4
                                ? Color(0xFF05564B)
                                : Color(0xFFD6E3DC),
                          ),
                          child: Center(
                              child: Text(
                            "Jeu",
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          changeDayValue(5);
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: day == 5
                                ? Color(0xFF05564B)
                                : Color(0xFFD6E3DC),
                          ),
                          child: Center(
                              child: Text(
                            "Ven",
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          changeDayValue(6);
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: day == 6
                                ? Color(0xFF05564B)
                                : Color(0xFFD6E3DC),
                          ),
                          child: Center(
                              child: Text(
                            "Sam",
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Column(
                    children: currentHoraire.entries.map((entry) {
                      TimeOfDay startTime = entry.key;
                      TimeOfDay endTime = entry.value;

                      String formattedStartTime = _formatTime(startTime);
                      String formattedEndTime = _formatTime(endTime);

                      return Container(
                          padding:
                              EdgeInsets.all(16.0), // Adjust padding as needed
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$formattedStartTime',
                                style: GoogleFonts.poppins(fontSize: 16),
                              ),
                              SizedBox(width: 30),
                              SvgPicture.asset("assets/line.svg"),
                              SizedBox(width: 30),
                              Text(
                                '$formattedEndTime',
                                style: GoogleFonts.poppins(fontSize: 16),
                              ),
                              SizedBox(width: 40),
                              GestureDetector(
                                  onTap: () {
                                    removeTimeRange(day, startTime, endTime);
                                  },
                                  child: SvgPicture.asset("assets/remove.svg")),
                            ],
                          ));
                    }).toList(),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Color(0xFFD6E3DC),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    content: Container(
                                      width:
                                          280.0, // Adjust the width as needed
                                      height:
                                          290.0, // Adjust the height as needed
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 30.0),
                                            child: Center(
                                                child: Text(
                                              "Rentrez Votre nouvelle horaire",
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            )),
                                          ),
                                          SizedBox(height: 20),
                                          Container(
                                            width: 100,
                                            height: 41,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              border: Border.all(
                                                color: const Color(0xFF05564B),
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: TextFormField(
                                              controller: _debutController,
                                              keyboardType:
                                                  TextInputType.datetime,
                                              decoration: InputDecoration(
                                                hintText: "10:30",
                                                hintStyle: GoogleFonts.poppins(
                                                  color:
                                                      const Color(0xFF000000),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 16.0,
                                                ),
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Container(
                                            width: 100,
                                            height: 41,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              border: Border.all(
                                                color: const Color(0xFF05564B),
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: TextFormField(
                                              controller: _finController,
                                              keyboardType:
                                                  TextInputType.datetime,
                                              decoration: InputDecoration(
                                                hintText: "16:00",
                                                hintStyle: GoogleFonts.poppins(
                                                  color:
                                                      const Color(0xFF000000),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 16.0,
                                                ),
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          ElevatedButton(
                                            onPressed: () {
                                              String start =
                                                  _debutController.text;
                                              String fin = _finController.text;
                                              TimeOfDay starting =
                                                  stringToTimeOfDay(start);
                                              TimeOfDay ending =
                                                  stringToTimeOfDay(fin);
                                              addTimeRange(
                                                  day, starting, ending);
                                              print("done");
                                            },
                                            style: ButtonStyle(
                                              minimumSize: MaterialStateProperty
                                                  .all<Size>(
                                                      const Size(115, 35)),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      const Color(0xFF05564B)),
                                            ),
                                            child: Text(
                                              "Valider",
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: SvgPicture.asset("assets/add.svg")),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
