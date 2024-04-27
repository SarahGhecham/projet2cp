import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/constants/constants.dart';
import 'package:flutter_application_proj2cp/pages/admin_pages/ajouter_domaine.dart';
import 'package:google_fonts/google_fonts.dart';

class AddPrestationPage2 extends StatefulWidget {
  const AddPrestationPage2({super.key});

  @override
  State<AddPrestationPage2> createState() => _AddPrestationPage2State();
}

class _AddPrestationPage2State extends State<AddPrestationPage2> {
  final List<String> _prixOptions = ['Option 1', 'Option 2', 'Option 3'];
  final List<String> _dureeOptions = ['Option A', 'Option B', 'Option C'];
  List<String> _materiels = [];
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
        padding: const EdgeInsets.all(20.0),
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
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 45,
                    width: 300,
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
                            decoration: InputDecoration(
                              hintText: 'Saisir un prix',
                              hintStyle: GoogleFonts.poppins(
                                color: const Color(0xFF777777),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 11.0,
                                horizontal: 16.0,
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
                                  padding: const EdgeInsets.only(right: 10.0),
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
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 45,
                    width: 300,
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
                            decoration: InputDecoration(
                              hintText: 'Saisir une durée',
                              hintStyle: GoogleFonts.poppins(
                                color: const Color(0xFF777777),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 11.0,
                                horizontal: 16.0,
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
                                  padding: const EdgeInsets.only(right: 10.0),
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
                          const EdgeInsets.only(left: 10.0, right: 40, top: 10),
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
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                            _materiels[index],
                            style: GoogleFonts.poppins(
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
                height: 230,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 200),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddDomainePage(),
                      ),
                    );
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
            ],
          ),
        ),
      ),
    );
  }
}
