import 'package:flutter/foundation.dart';

class RepertoireDayViewModel extends ChangeNotifier {
  final int _totalPages;
  RepertoireDayViewModel({int totalPages = 1}) : _totalPages = totalPages;

  int pageIndex = 0;


  int get totalPages => _totalPages;


  void setPageIndex(int index) {
    pageIndex = index;  
    notifyListeners();
  }

  void nextPage() {
    if (pageIndex < totalPages - 1) {
      pageIndex++;
    notifyListeners();
    }
  }

  void previousPage() {
    if (pageIndex > 0) {
      pageIndex--;
    notifyListeners();
    }
  }
}