import 'dart:io';

class PrestationInfo {
  String nomPrestation;
  File? imageFilePrestation;
  String description;
  String prixMin;
  String prixMax;
  String dureeMin;
  String dureeMax;
  List<String> materiels;

  PrestationInfo({
    required this.nomPrestation,
    this.imageFilePrestation,
    required this.description,
    required this.prixMin,
    required this.prixMax,
    required this.dureeMin,
    required this.dureeMax,
    required this.materiels,
  });
}
