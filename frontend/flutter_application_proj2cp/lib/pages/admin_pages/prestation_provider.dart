import 'package:flutter_application_proj2cp/pages/admin_pages/prestation_info.dart';
import 'package:flutter/foundation.dart'; // For ChangeNotifier
import 'package:flutter/material.dart'; // For other Flutter utilities
class PrestationInfoProvider extends ChangeNotifier {
  PrestationInfo? _prestationInfo;

  PrestationInfo? get prestationInfo => _prestationInfo;

  void setPrestationInfo(PrestationInfo prestationInfo) {
    _prestationInfo = prestationInfo;
    notifyListeners();
  }
}