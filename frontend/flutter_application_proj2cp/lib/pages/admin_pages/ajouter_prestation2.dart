import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/constants/constants.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/ajouter_domaine.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/ajouter_prestation1.dart';

import 'package:flutter_application_proj2cp/pages/admin_pages/prestation_info.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/prestation_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddPrestationPage2 extends StatefulWidget {
  const AddPrestationPage2({
    Key? key,
    //required this.prestationInfo,
  }) : super(key: key);

  @override
  _AddPrestationPage2State createState() => _AddPrestationPage2State();
}

class _AddPrestationPage2State extends State<AddPrestationPage2> {
  //final PrestationInfo prestationInfo;
  String _selectedPrixMinOption = '';
  String _selectedDureeMinOption = '';
  String _selectedPrixMaxOption = '';
  String _selectedDureeMaxOption = '';
  List<String> _materiels = [];

  final List<String> _prixOptions = ['Option 1', 'Option 2', 'Option 3'];
  final List<String> _dureeOptions = ['Option A', 'Option B', 'Option C'];
  final TextEditingController _prixMinController = TextEditingController();
  final TextEditingController _prixMaxController = TextEditingController();
  final TextEditingController _dureeMinController = TextEditingController();
  final TextEditingController _dureeMaxController = TextEditingController();

  void _navigateToDomainePage() {
    print("Before fetching prestationInfo");

    final prestationInfoProvider =
        Provider.of<PrestationInfoProvider>(context, listen: false);

    if (prestationInfoProvider.prestationInfo != null) {
      final updatedPrestationInfo = PrestationInfo(
        nomPrestation: prestationInfoProvider.prestationInfo!.nomPrestation,
        imageFilePrestation:
            prestationInfoProvider.prestationInfo!.imageFilePrestation,
        description: prestationInfoProvider.prestationInfo!.description,
        prixMin: _selectedPrixMinOption,
        prixMax: _selectedPrixMaxOption,
        dureeMin: _selectedDureeMinOption,
        dureeMax: _selectedDureeMaxOption,
        materiels: _materiels,
      );

      print(
          "After fetching prestationInfo, nomPrestation: ${updatedPrestationInfo.nomPrestation}");

      prestationInfoProvider.setPrestationInfo(updatedPrestationInfo);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddDomainePage(),
        ),
      );
    } else {
      print("PrestationInfo is null or not available.");
      // Handle the case where prestationInfo is null
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
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 10.0,
          right: 10,
          //bottom: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 30, 30, 0),
                child: Text(
                  'Prix Approximatif',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 45,
                        width: 160,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCC8C5).withOpacity(0.22),
                          border: Border.all(
                            color: const Color(0xFFDCC8C5),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _prixMinController,
                                decoration: InputDecoration(
                                  hintText: 'Min',
                                  hintStyle: GoogleFonts.poppins(
                                    color: const Color(0xFF777777),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 11.0,
                                    horizontal: 8.0,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                items: _prixOptions.map((option) {
                                  return DropdownMenuItem<String>(
                                    value: option,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 1.0),
                                      child: Text(
                                        option,
                                        style: GoogleFonts.poppins(
                                          color: const Color(0xFF777777),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  // Gérer le changement de la valeur sélectionnée
                                },
                                icon: const Icon(Icons.arrow_drop_down),
                              ),
                            ),
                          ],
                        ),
                      )),
                  SizedBox(
                    width: 15,
                  ),
                  Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Container(
                        height: 45,
                        width: 160,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCC8C5).withOpacity(0.22),
                          border: Border.all(
                            color: const Color(0xFFDCC8C5),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _prixMaxController,
                                decoration: InputDecoration(
                                  hintText: 'Max',
                                  hintStyle: GoogleFonts.poppins(
                                    color: const Color(0xFF777777),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 11.0,
                                    horizontal: 8.0,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                items: _prixOptions.map((option) {
                                  return DropdownMenuItem<String>(
                                    value: option,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 1.0),
                                      child: Text(
                                        option,
                                        style: GoogleFonts.poppins(
                                          color: const Color(0xFF777777),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  // Gérer le changement de la valeur sélectionnée
                                },
                                icon: const Icon(Icons.arrow_drop_down),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 25, 30, 0),
                child: Text(
                  'Durée de realisation',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: Container(
                        height: 45,
                        width: 160,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCC8C5).withOpacity(0.22),
                          border: Border.all(
                            color: const Color(0xFFDCC8C5),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _dureeMinController,
                                decoration: InputDecoration(
                                  hintText: 'Min',
                                  hintStyle: GoogleFonts.poppins(
                                    color: const Color(0xFF777777),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 11.0,
                                    horizontal: 8.0,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                items: _dureeOptions.map((option) {
                                  return DropdownMenuItem<String>(
                                    value: option,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 1.0),
                                      child: Text(
                                        option,
                                        style: GoogleFonts.poppins(
                                          color: const Color(0xFF777777),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  // Gérer le changement de la valeur sélectionnée
                                },
                                icon: const Icon(Icons.arrow_drop_down),
                              ),
                            ),
                          ],
                        ),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 45,
                        width: 160,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCC8C5).withOpacity(0.22),
                          border: Border.all(
                            color: const Color(0xFFDCC8C5),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _dureeMaxController,
                                decoration: InputDecoration(
                                  hintText: 'Max',
                                  hintStyle: GoogleFonts.poppins(
                                    color: const Color(0xFF777777),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 11.0,
                                    horizontal: 8.0,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                items: _dureeOptions.map((option) {
                                  return DropdownMenuItem<String>(
                                    value: option,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: Text(
                                        option,
                                        style: GoogleFonts.poppins(
                                          color: const Color(0xFF777777),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  // Gérer le changement de la valeur sélectionnée
                                },
                                icon: const Icon(Icons.arrow_drop_down),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 25, 30, 0),
                child: Text(
                  'Matériel',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _materiels.length + 1, // +1 pour le champ d'ajout
                itemBuilder: (context, index) {
                  if (index == _materiels.length) {
                    // Champ d'ajout
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 10.0, right: 15, top: 10),
                      child: GestureDetector(
                        onTap: () {
                          // Afficher une boîte de dialogue pour saisir le nouveau matériel
                          showDialog(
                            context: context,
                            builder: (context) {
                              String nouveauMateriel = '';
                              return AlertDialog(
                                title: Text('Ajouter un matériel'),
                                content: TextField(
                                  onChanged: (value) {
                                    nouveauMateriel = value;
                                  },
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Annuler',
                                      style: GoogleFonts.poppins(),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (nouveauMateriel.isNotEmpty) {
                                        setState(() {
                                          _materiels.add(nouveauMateriel);
                                        });
                                      }
                                      Navigator.pop(context);
                                    },
                                    child: Text('Ajouter'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.only(left: 20),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.add),
                              Text(
                                'Ajouter un matériel',
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF777777),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    // Afficher les matériels existants
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 10.0, top: 10, right: 40),
                      child: Container(
                        width: 240,
                        height: 45,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCC8C5).withOpacity(0.22),
                          border: Border.all(
                            color: const Color(0xFFDCC8C5),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 15),
                          child: Text(
                            _materiels[index],
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
              SizedBox(
                height: 250,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 230),
                child: GestureDetector(
                  onTap: () {
                    _navigateToDomainePage();
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
                          'Terminer',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: kWhite,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )),
                ),
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
