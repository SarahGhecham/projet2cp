import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/pages/entree/intro_screens/intro_page_1.dart';
import 'package:flutter_application_proj2cp/pages/entree/intro_screens/intro_page_2.dart';
import 'package:flutter_application_proj2cp/pages/entree/intro_screens/intro_page_3.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:google_fonts/google_fonts.dart';

class PageEntree extends StatefulWidget {
  const PageEntree({super.key});

  @override
  _PageEntreeState createState() => _PageEntreeState();
}

class _PageEntreeState extends State<PageEntree> {
  final PageController _controller = PageController();

  bool onLastPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              onLastPage = (index == 2);
            });
          },
          children: const [
            IntroPage1(),
            IntroPage2(),
            IntroPage3(),
          ],
        ),
        Container(
            alignment: const Alignment(0, 0.9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 115,
                  height: 36,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffd6e3dc),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )
                        // Other button styles as needed
                        ),
                    onPressed: () {
                      _controller.jumpToPage(2);
                    },
                    child: Text(
                      'Passer',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff05564b),
                      ),
                    ),
                  ),
                ),
                SmoothPageIndicator(controller: _controller, count: 3),
                onLastPage
                    ? SizedBox(
                        width: 115,
                        height: 36,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffd6e3dc),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )
                              // Other button styles as needed
                              ),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const IntroPage1();
                            }));
                          },
                          child: Text(
                            'Fin',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff05564b),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(
                        width: 115,
                        height: 36,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffd6e3dc),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )
                              // Other button styles as needed
                              ),
                          onPressed: () {
                            _controller.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut);
                          },
                          child: Text(
                            'Suivant',
                            style: GoogleFonts.poppins(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff05564b),
                            ),
                          ),
                        ),
                      ),
              ],
            ))
      ],
    ));
  }
}
