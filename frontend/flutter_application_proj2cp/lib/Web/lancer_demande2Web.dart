import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_application_proj2cp/Web/lancer_demande3Web.dart';

class Lancerdemande2PageWeb extends StatefulWidget {
  final int hour;
  final int min;
  final bool urgent;

  const Lancerdemande2PageWeb({Key? key, required this.hour, required this.min, required this.urgent}) : super(key: key);
  @override
  State<Lancerdemande2PageWeb> createState() => _Lancerdemande2PageState();
}


class _Lancerdemande2PageState extends State<Lancerdemande2PageWeb> {
  var nomprest = "Lavage de sol";
  final _heuredebutController = TextEditingController();
  
   late DateTime selectedDay; // Variable pour stocker le jour sélectionné
  void _oneDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
      print("Jour sélectionné : $today"); 
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
      builder: (context) => Lancerdemande3PageWeb(hour: widget.hour, min: widget.min,urgent: widget.urgent,heureMinutes:heureMinutes,jour:today),
    ),
  );
  }

 

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 800,
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
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  nomprest,
                  style: GoogleFonts.poppins(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 500, vertical: 0),
                child: Text(
                  "Quelle heure vous convient?",
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Container(
                height: 80,
                width: 140,
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
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 510),
                child: Text(
                  "Quel jour vous convient?",
                  style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Container(
                height: 370,
                width: 345,
                decoration: BoxDecoration(
                  color: const Color(0xFFD6E3DC),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TableCalendar(
                  
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
            const SizedBox(height: 50),
            Center(
              child: ElevatedButton(
                onPressed: () => _navigateToNextPage(context),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(const Size(400, 55)),
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
                    fontSize: 25,
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
