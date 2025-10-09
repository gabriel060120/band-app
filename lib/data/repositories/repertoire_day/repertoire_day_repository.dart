import 'package:band_app/utils/result.dart';

class RepertoireDayRepository {
  Future<Result<List<String>>> fetchRepertoireDays() async {
    try {
      List<String> days = [
        'https://www.cifraclub.com.br/jefferson-e-suellen/vem-me-buscar/#tabs=false&instrument=keyboard&key=5',
        'https://www.cifraclub.com.br/paulo-cesar-baruk/clamo-jesus/#tabs=false&instrument=keyboard',
      ];
      return Result.ok(days);
    } catch (e) {
      return Result.error(Exception());
    }
  }
}
