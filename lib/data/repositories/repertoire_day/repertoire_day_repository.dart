import 'package:band_app/data/services/api/api_client.dart';
import 'package:band_app/domain/models/repertoire_day/repertoire_day.dart';
import 'package:band_app/utils/result.dart';

class RepertoireDayRepository {
  final ApiClient supabase;

  RepertoireDayRepository(this.supabase);

  Future<Result<List<RepertoireDay>>> fetchRepertoireDays() async {
    try {
      final nowIso = DateTime.now().toUtc().toIso8601String();
      final response = await supabase.client
          .from('repertoire_day')
          .select('''
    id,
    date,
    title,
    repertoire_music(
      order,
      music(
        id,
        name,
        lyrics(*),
        cipher(*)
      )
    )
  ''')
          .filter('date', 'gte', nowIso)
          .order('date', ascending: true);

      return Result.ok(
        response
            .map<RepertoireDay>((day) => RepertoireDay.fromMap(day))
            .toList(),
      );
    } catch (e) {
      return Result.error(Exception('Erro na busca do DB'));
    }
  }
}
