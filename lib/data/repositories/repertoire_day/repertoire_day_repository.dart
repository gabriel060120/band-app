import 'package:band_app/data/services/api/api_client.dart';
import 'package:band_app/utils/result.dart';

class RepertoireDayRepository {
  final ApiClient supabase;

  RepertoireDayRepository(this.supabase);

  Future<Result<List<String>>> fetchRepertoireDays() async {
    try {
      final data = await supabase.client
          .from('repertoire_day')
          .select('chiper')
          .order('order');
      return Result.ok(
        data.map<String>((element) => element['chiper']).toList(),
      );
    } catch (e) {
      return Result.error(Exception('Erro na busca do DB'));
    }
  }
}
