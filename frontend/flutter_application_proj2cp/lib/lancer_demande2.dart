import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_application_proj2cp/lancer_demande3.dart';

/*class Lancerdemande2Page extends StatefulWidget {
  final int hour;
  final int min;
  final bool urgent;

  const Lancerdemande2Page({Key? key, required this.hour, required this.min, required this.urgent}) : super(key: key);

  @override
  State<Lancerdemande2Page> createState() => _Lancerdemande2PageState();
}

class _Lancerdemande2PageState extends State<Lancerdemande2Page> {

  var nomprest = "Lavage de sol";
  String dateOnly="";
  final _heuredebutController = TextEditingController();
  
  void _oneDaySelected(DateTime day, DateTime focusedDay)
  {
    setState(() {
      today = day;
      //String dateString = day.toString();
      //DateTime dateTime = DateTime.parse(dateString);
      dateOnly = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    print(dateOnly); // Output: 2024-04-04
    });
  }
  DateTime today = DateTime.now();
  void _navigateToNextPage(BuildContext context) {
    String heureMinutes = _heuredebutController.text;
    if (heureMinutes.isEmpty) {
    heureMinutes = "10:00"; // Valeur par défaut si aucun texte n'est saisi
     }
    Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Lancerdemande3Page(hour: widget.hour, min: widget.min,urgent: widget.urgent,heureMinutes:heureMinutes,jour:dateOnly),
    ),
  );}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 30),
            Container(
              width: 200,
              height: 11,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFD9D9D9), width: 1.5),
              ),
              child: const LinearProgressIndicator(
                value: 0.66,
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF05564B)),
              ),
            ),
            const SizedBox(width: 60),
            SizedBox(
              height: 16,
              width: 20,
              child: SvgPicture.asset("assets/cancel.svg"),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                nomprest, style: GoogleFonts.poppins(fontSize :18),
              ),
            ),
            const SizedBox(height: 50),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Quelle heure vous convient?",
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 60),
            Center(
              child: Container(
                height: 78,
                width: 132,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFDCC8C5),
                ),
                child: Center(
                  child: TextFormField(
                    controller: _heuredebutController,
                    keyboardType: TextInputType.datetime,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: "10 : 00",
                      hintStyle: GoogleFonts.poppins(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 80),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Quel jour vous convient?",
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 60),
            Center(
              child: Container(
                height: 400,
                width: 335,
                decoration: BoxDecoration(
                  color: const Color(0xFFD6E3DC),
                  borderRadius: BorderRadius.circular(16),
                ),
                child:
                TableCalendar(
                  locale: 'en_US',
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: GoogleFonts.poppins(fontSize: 16, color: Colors.black,),
                    selectedDecoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFF8787),
                    ),
                    todayDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFF8787).withOpacity(0.22),
                    ),
                  ),
                  headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true, titleTextStyle: GoogleFonts.poppins(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold), ),
                  availableGestures: AvailableGestures.all,
                  selectedDayPredicate: (day)=>isSameDay(day, today),
                  focusedDay: today,
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime(2030, 3, 14),
                  onDaySelected: _oneDaySelected,
                ),
              ),
            ),
            const SizedBox(height: 80),
            Center(
              child: ElevatedButton(
                onPressed: () => _navigateToNextPage(context),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(const Size(315, 55)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  backgroundColor:
                  MaterialStateProperty.all<Color>(const Color(0xFF05564B)),
                ),
                child: Text(
                  "Suivant",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_application_proj2cp/lancer_demande3.dart';

class Lancerdemande2Page extends StatefulWidget {
  final int hour;
  final int min;
  final bool urgent;
  final nomprest;

  const Lancerdemande2Page({Key? key, required this.hour, required this.min, required this.urgent,required this.nomprest}) : super(key: key);

  @override
  State<Lancerdemande2Page> createState() => _Lancerdemande2PageState();
}

class _Lancerdemande2PageState extends State<Lancerdemande2Page> {

  var nomprest = "Lavage de sol";
  String dateOnly="";
  final _heuredebutController = TextEditingController();

  TimeOfDay stringToTimeOfDay(String timeString) {
  
    List<String> parts = timeString.split("h");

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
  
  void _oneDaySelected(DateTime day, DateTime focusedDay)
  {
    setState(() {
      today = day;
      //String dateString = day.toString();
      //DateTime dateTime = DateTime.parse(dateString);
      dateOnly = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    print(dateOnly); // Output: 2024-04-04
    });
  }
  DateTime today = DateTime.now();
  void _navigateToNextPage(BuildContext context,String nomprst) {
    TimeOfDay heureMinutes = stringToTimeOfDay(_heuredebutController.text);
    if (heureMinutes.toString().isEmpty) {
      heureMinutes = stringToTimeOfDay("10:00"); // Valeur par dÃ©faut si aucun texte n'est saisi
    }
    Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Lancerdemande3Page(hour: widget.hour, min: widget.min,urgent: widget.urgent,heureMinutes:heureMinutes.toString(),jour:dateOnly,nomprst: nomprst,),
    ),
  );}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 30),
            Container(
              width: 170,
              height: 11,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFD9D9D9), width: 1.5),
              ),
              child: const LinearProgressIndicator(
                value: 0.66,
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF05564B)),
              ),
            ),
            const SizedBox(width: 60),
            SizedBox(
              height: 16,
              width: 20,
              child: SvgPicture.asset("assets/cancel.svg"),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                widget.nomprest, style: GoogleFonts.poppins(fontSize :18),
              ),
            ),
            const SizedBox(height: 50),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Quelle heure vous convient?",
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 60),
            Center(
              child: Container(
                height: 78,
                width: 132,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFDCC8C5),
                ),
                child: Center(
                  child: TextFormField(
                    controller: _heuredebutController,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: "10h00",
                      hintStyle: GoogleFonts.poppins(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 80),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Quel jour vous convient?",
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 60),
            Center(
              child: Container(
                height: 400,
                width: 335,
                decoration: BoxDecoration(
                  color: const Color(0xFFD6E3DC),
                  borderRadius: BorderRadius.circular(16),
                ),
                child:
                TableCalendar(
                  locale: 'en_US',
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: GoogleFonts.poppins(fontSize: 16, color: Colors.black,),
                    selectedDecoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFF8787),
                    ),
                    todayDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFF8787).withOpacity(0.22),
                    ),
                  ),
                  headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true, titleTextStyle: GoogleFonts.poppins(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold), ),
                  availableGestures: AvailableGestures.all,
                  selectedDayPredicate: (day)=>isSameDay(day, today),
                  focusedDay: today,
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime(2030, 3, 14),
                  onDaySelected: _oneDaySelected,
                ),
              ),
            ),
            const SizedBox(height: 80),
            Center(
              child: ElevatedButton(
                onPressed: () => _navigateToNextPage(context,widget.nomprest),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(const Size(315, 55)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  backgroundColor:
                  MaterialStateProperty.all<Color>(const Color(0xFF05564B)),
                ),
                child: Text(
                  "Suivant",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
