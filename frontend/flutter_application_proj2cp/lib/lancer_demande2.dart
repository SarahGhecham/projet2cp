import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';


class Lancerdemande2Page extends StatefulWidget {
  const Lancerdemande2Page({super.key});

  @override
  State<Lancerdemande2Page> createState() => _Lancerdemande2PageState();
}

class _Lancerdemande2PageState extends State<Lancerdemande2Page> {

  var nomprest = "Lavage de sol";
  final _heuredebutController = TextEditingController();
  void _oneDaySelected(DateTime day, DateTime focusedDay)
  {
    setState(() {
      today = day;
    });
  }
  DateTime today = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height:180),
            SizedBox(
              height: 18,
              width: 25,
              child: SvgPicture.asset("assets/fleche.svg"),
            ),
            const SizedBox(width: 50),
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
            const SizedBox(width: 50),
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
                child: TableCalendar(
                  locale: 'fr_FR',
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
                onPressed: (){},
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
