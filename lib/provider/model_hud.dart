import 'package:flutter/material.dart';

class ModelHud extends ChangeNotifier {
  bool isLoading = false;

  isLoadingChange(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
