import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/constants/constants.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/ajouter_prestation2.dart';

import 'package:flutter_application_proj2cp/pages/admin_pages/prestation_info.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/prestation_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddPrestationPage extends StatefulWidget {
  final Function(PrestationInfo) onPrestationAdded;

  const AddPrestationPage({Key? key, required this.onPrestationAdded})
      : super(key: key);

  @override
  _AddPrestationPageState createState() => _AddPrestationPageState();
}

class _AddPrestationPageState extends State<AddPrestationPage> {
  final TextEditingController _prestationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _imageFilePrestation;
  PrestationInfo _prestationInfo = PrestationInfo(
    nomPrestation: '',
    description: '',
    prixMin: '',
    prixMax: '',
    dureeMin: '',
    dureeMax: '',
    materiels: [],
  );

  void _navigateToNextPage() {
    final prestationInfo = PrestationInfo(
      nomPrestation: _prestationController.text,
      imageFilePrestation: _imageFilePrestation,
      description: _descriptionController.text,
      prixMin: '',
      prixMax: '',
      dureeMin: '',
      dureeMax: '',
      materiels: [],
    );

    Provider.of<PrestationInfoProvider>(context, listen: false)
        .setPrestationInfo(prestationInfo);
    widget.onPrestationAdded(prestationInfo);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPrestationPage2(),
      ),
    );
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _prestationInfo.imageFilePrestation = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(
                      context); // Navigate back when back arrow is pressed
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 8),
              child: Text(
                'Ajouter une prestation',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 30, 30, 0),
                child: Text(
                  'Nom de la prestation',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: 277,
                  height: 45,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCC8C5).withOpacity(0.22),
                    border: Border.all(
                      color: const Color(0xFFDCC8C5),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: _prestationController,
                    decoration: InputDecoration(
                      //hintText: "Saisir un nom",
                      hintStyle: GoogleFonts.poppins(
                        color: const Color(0xFF777777),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 16.0,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 25, 30, 0),
                child: Text(
                  'Image descriptive',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              Stack(children: [
                _prestationInfo.imageFilePrestation != null
                    ? Image.file(_prestationInfo.imageFilePrestation!)
                    : Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: 300,
                          height: 70,
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCC8C5).withOpacity(0.22),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                Positioned.fill(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: _selectImage,
                        child: Container(
                          width: 140,
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: crevette,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'Séléctionner',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: crevette,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Aucun fichier ',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            //fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 109, 109, 109),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 25, 30, 0),
                child: Text(
                  'Description',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: 277,
                  height: 170,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCC8C5).withOpacity(0.22),
                    border: Border.all(
                      color: const Color(0xFFDCC8C5),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      //hintText: "Saisir un nom",
                      hintStyle: GoogleFonts.poppins(
                        color: const Color(0xFF777777),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 16.0,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 70,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 200),
                child: GestureDetector(
                  onTap: () {
                    _navigateToNextPage();
                  },
                  child: Container(
                      height: 50,
                      width: 130,
                      decoration: BoxDecoration(
                        color: vertFonce,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Suivant',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: kWhite,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
