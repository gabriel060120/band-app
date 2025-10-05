import 'package:band_app/utils/result.dart';

class RepertoireDayRepository {
  Future<Result<List<String>>> fetchRepertoireDays() async {
    try {
      List<String> days = ['https://www.cifraclub.com.br/thamires-garcia/ate-que-ele-venha-e-chova-justica/#tabs=false&instrument=keyboard&key=7', 'https://www.cifraclub.com.br/ministerio-zoe/ate-que-o-senhor-venha/#tabs=false&instrument=keyboard', 'https://www.cifraclub.com.br/fernandinho/pra-sempre/#tabs=false&instrument=keyboard',];
      return Result.ok(days);
    } catch (e) {
      return Result.error(Exception());
    }
  }
}