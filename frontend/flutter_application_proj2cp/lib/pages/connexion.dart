import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_proj2cp/pages/inscription.dart';
import 'package:google_fonts/google_fonts.dart';

class LogInPage extends StatefulWidget {
  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 100),
            Container(
              height:100,
              width:300,
              child: Image.asset("assets/logo.png"),
            ),
            SizedBox(height: 30),
            Center(
              child: Text(
                "Connexion",
                style: GoogleFonts.poppins(
                  color: Color(0xFF05564B),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 50),
            Container(
              width: 277,
              height: 41,
              decoration: BoxDecoration(
                color: Color(0xFFDCC8C5).withOpacity(0.22),
                border: Border.all(
                  color: Color(0xFFDCC8C5),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                controller: _usernameController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: TextStyle(fontFamily: "Poppins", color: Color(0xFF777777),),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0,),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 40),
            Container(
              width: 277,
              height: 41,
              decoration: BoxDecoration(
                color: Color(0xFFDCC8C5).withOpacity(0.22),
                border: Border.all(
                  color: Color(0xFFDCC8C5),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                controller: _passwordController,
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Mot de passe",
                  hintStyle: GoogleFonts.poppins(color: Color(0xFF777777),),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0,),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: (){},
              child: Text("Connexion",
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                ),
              ),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all<Size>(Size(100, 37)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFFF8787)),
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    child: Divider(
                      color: Color(0xFFDDDDDD),
                      thickness: 1.0,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text("or",style: GoogleFonts.poppins(color: Colors.grey, fontSize: 16,),),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 150,
                    child: Divider(
                      color: Color(0xFFDDDDDD),
                      thickness: 1.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/apple.svg", width: 30, height: 30,),
                    SizedBox(height: 5), // Adjust the height as needed
                  ],
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Connexion avec Apple",
                      style: GoogleFonts.poppins(fontSize: 16,),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/google.svg", width: 25, height: 25,),
                    SizedBox(height: 5), // Adjust the height as needed
                  ],
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Connexion avec Google",
                      style: GoogleFonts.poppins(fontSize: 16,),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 70),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Vous n’avez pas de compte client ?",style: GoogleFonts.poppins(color: Color(0xFF777777), fontSize: 16,),),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                  },
                    child: Text("S'inscrire",style: GoogleFonts.poppins(color: Color(0xFF05564B), fontWeight: FontWeight.bold, fontSize: 16,),)),

              ],
            ),
          ],
        ),
      ),
    );
  }
}