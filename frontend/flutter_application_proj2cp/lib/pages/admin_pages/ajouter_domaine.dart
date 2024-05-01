import 'dart:convert';

import 'package:flutter_application_proj2cp/config.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_proj2cp/constants/constants.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/ajouter_prestation1.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/drawer_services.dart';

import 'package:flutter_application_proj2cp/pages/admin_pages/prestation_info.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/prestation_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AddDomainePage extends StatefulWidget {
  //final PrestationInfo? prestationInfo;

  AddDomainePage({
    super.key,
  });

  @override
  _AddDomainePageState createState() => _AddDomainePageState();
}

class _AddDomainePageState extends State<AddDomainePage> {
  //PrestationInfo? prestationInfo;
  TextEditingController _domaineController = TextEditingController();
  File? _imageFile;
  List<PrestationInfo> _prestations = [];
  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _addPrestation(PrestationInfo newPrestation) {
    setState(() {
      _prestations.add(newPrestation);
    });
  }

  void _navigateToAddPrestationPage1() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPrestationPage(
          onPrestationAdded: _addPrestation,
        ),
      ),
    );
  }

  void initState() {
    super.initState();
    final prestationInfoProvider =
        Provider.of<PrestationInfoProvider>(context, listen: false);
    final prestationInfo = prestationInfoProvider.prestationInfo;

    if (prestationInfo != null) {
      _prestations.add(prestationInfo);
    }
  }

  Future<void> _ajouterDomaine() async {
    // Get the domain name from the text field
    String nomDomaine = _domaineController.text;

    // Check if an image file is selected
    if (_imageFile == null) {
      print('Aucune image sélectionnée.');
      return;
    }

    // Prepare the request data
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://${AppConfig.serverAddress}:${AppConfig.serverPort}/admins/AjouterDomaine'),
    );

    // Attach the image file to the request
    request.files.add(await http.MultipartFile.fromPath(
      'imageDomaine',
      _imageFile!.path,
    ));

    // Add the domain name to the request fields
    request.fields['NomDomaine'] = nomDomaine;

    try {
      // Send the request
      var streamedResponse = await request.send();

      // Check the response status
      if (streamedResponse.statusCode == 201) {
        // Request successful, parse the response
        var response = await streamedResponse.stream.bytesToString();
        var jsonData = jsonDecode(response);

        // Handle the response data
        if (jsonData['success'] == true) {
          // Success
          print('Domaine ajouté avec succès.');
        } else {
          // Failure
          print('Erreur bruh de l\'ajout du domaine: ${jsonData['message']}');
        }
      } else {
        // Request failed
        print(
            'Erreur bro de l\'ajout du domaine: ${streamedResponse.reasonPhrase}');
      }
    } catch (e) {
      // Handle errors
      print('Error: $e');
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DrawerServices(),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 20),
              child: Text(
                'Ajouter un domaine',
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
      body: Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 30, 30, 0),
                  child: Text(
                    'Nom du domaine',
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
                _imageFile != null
                    ? Image.file(_imageFile!)
                    : Stack(children: [
                        Padding(
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
                    'Liste des prestation',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _prestations.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _prestations.length) {
                      print('hello assia');
                      return GestureDetector(
                        onTap: _navigateToAddPrestationPage1,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Container(
                            width: 300,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCC8C5).withOpacity(0.22),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: Color.fromARGB(255, 109, 109, 109),
                                ),
                                Text(
                                  'Ajouter une prestation',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 109, 109, 109),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      PrestationInfo prestation = _prestations[index];
                      return Padding(
                        padding: const EdgeInsets.all(15),
                        child: Container(
                          width: 300,
                          height: 60,
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCC8C5).withOpacity(0.22),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              prestation.nomPrestation,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 180,
                ),
                Center(
                    child: GestureDetector(
                  onTap: _ajouterDomaine,
                  child: Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                        color: crevette,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Enregistrer',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: kWhite,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )),
                )),
              ],
            ),
          ),
        );
      }),
    );
  }
}
