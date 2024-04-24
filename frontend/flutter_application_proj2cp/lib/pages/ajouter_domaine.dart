import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class AddDomainePage extends StatefulWidget {
  @override
  _AddDomainePageState createState() => _AddDomainePageState();
}

class _AddDomainePageState extends State<AddDomainePage> {
  TextEditingController _domaineController = TextEditingController();
  File? _imageFile;

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
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
      Uri.parse('http://10.0.2.2:3000/admins/AjouterDomaine'),
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
        title: Text('Add Domaine'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _domaineController,
                decoration: InputDecoration(
                  labelText: 'Nom du Domaine',
                ),
              ),
              SizedBox(height: 20),
              _imageFile != null
                  ? Image.file(_imageFile!)
                  : Placeholder(
                      fallbackHeight: 200,
                      fallbackWidth: double.infinity,
                    ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _selectImage,
                child: Text('Sélectionner une image'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _ajouterDomaine,
                child: Text('Ajouter Domaine'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
