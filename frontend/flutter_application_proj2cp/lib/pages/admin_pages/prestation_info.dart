import 'dart:io';

class PrestationInfo {
  String nomPrestation;
  File? imageFilePrestation;
  String description;
  String prix;
  String duree;
  List<String> materiels;

  PrestationInfo({
    required this.nomPrestation,
    this.imageFilePrestation,
    required this.description,
    required this.prix,
    required this.duree,
    required this.materiels,
  });
}
