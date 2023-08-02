import 'package:flutter/material.dart';

class MainscreenNotifier extends ChangeNotifier {
  int _pageIndex = 0;
  int _selectedIndex = 0;
   int get selectedIndex => _selectedIndex;
  int get pageIndex => _pageIndex;
  set pageIndex(int newIndex) {
    _pageIndex = newIndex;
    notifyListeners();
  }
  set selectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
