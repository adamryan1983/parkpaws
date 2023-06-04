import 'package:flutter/material.dart';

class GlassfyProvider extends ChangeNotifier {
  bool _isSupporter = false;

  bool get isSupporter => _isSupporter;

  set isSupporter(bool isSupporter) {
    _isSupporter = isSupporter;

    notifyListeners();
  }
}
