import 'package:flutter/material.dart';

class ObscureTextProvider extends ChangeNotifier {
  bool? _isTrue = false;
  bool get isTrue => _isTrue!;

  changeBool() {
    _isTrue = !_isTrue!;
    notifyListeners();
  }
}
