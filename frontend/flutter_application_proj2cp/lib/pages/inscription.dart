import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';



class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _locationController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 70),
            Container(
              height:100,
              width:300,
              child: Image.asset("assets/logo.png"),
            ),
            SizedBox(height: 30),
            Center(
              child: Text(
                "Inscription",
                style: TextStyle(
                  color: Color(0xFF05564B),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: "Poppins",
                ),
              ),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
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
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Nom",
                      hintStyle: TextStyle(fontFamily: "Poppins", color: Color(0xFF777777),),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0,),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(width: 75),
                Container(
                  width: 100,
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
                    controller: _surnameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Prénom",
                      hintStyle: TextStyle(fontFamily: "Poppins", color: Color(0xFF777777),),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0,),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
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
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "E-mail",
                  hintStyle: TextStyle(fontFamily: "Poppins", color: Color(0xFF777777),),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0,),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20),
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
                controller: _locationController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "Adresse",
                  hintStyle: TextStyle(fontFamily: "Poppins", color: Color(0xFF777777),),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0,),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20),
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
                  hintStyle: TextStyle(fontFamily: "Poppins", color: Color(0xFF777777),),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0,),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: (){},
              child: Text("S'inscrire",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins"
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
            SizedBox(height: 20),
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
                  Text("or",style: TextStyle(color: Colors.grey, fontSize: 16, fontFamily: "Poppins"),),
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
                      style: TextStyle(fontSize: 16, fontFamily: "Poppins",),
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
                      style: TextStyle(fontSize: 16, fontFamily: "Poppins",),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("J’accepte les termes d’utilisation de l’application",style: TextStyle(color: Color(0xFF777777), fontFamily: "Poppins", fontSize: 14,),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
