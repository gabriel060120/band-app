// import 'package:band_app/data/repositories/repertoire_day/repertoire_day_repository.dart';
// import 'package:band_app/utils/command.dart';
// import 'package:band_app/utils/result.dart';
// import 'package:flutter/foundation.dart';

// class RepertoireDayViewModel extends ChangeNotifier {
//   RepertoireDayViewModel({
//     required RepertoireDayRepository repertoireDayRepository,
//   }) : 
//   _repertoireDayRepository = repertoireDayRepository {
//     loadRepertoire = Command0<List<String>>(
//       _fetchRepertoireDays,
//     )..execute();
//   }

//   final RepertoireDayRepository _repertoireDayRepository;

//   int pageIndex = 0;
//   late int _totalPages;

//   int get totalPages => _totalPages;

//   late Command0<List<String>> loadRepertoire;

//   List<String> _chipers = [];
//   List<String> get chipers => _chipers;


//   void setPageIndex(int index) {
//     pageIndex = index;  
//     notifyListeners();
//   }

//   void nextPage() {
//     if (pageIndex < totalPages - 1) {
//       pageIndex++;
//     notifyListeners();
//     }
//   }

//   void previousPage() {
//     if (pageIndex > 0) {
//       pageIndex--;
//     notifyListeners();
//     }
//   }

//   Future<Result<List<String>>> _fetchRepertoireDays() async {
//     try{
//       final result = await _repertoireDayRepository.fetchRepertoireDays();
//       result.fold((r) {
//         _totalPages = r.length;
//         _chipers = r;
//       }, (l) {
//         _totalPages = 0;
//         _chipers = [];
//       });
      
//       return result;
//     } finally {
//       notifyListeners();
//     }
//   }
// }