import 'package:band_app/data/services/api/api_client.dart';
import 'package:band_app/domain/models/lyrics/lyrics.dart';
import 'package:band_app/utils/result.dart';

class LyricsRepository {
  final ApiClient supabase;

  LyricsRepository(this.supabase);

  Future<Result<List<Lyrics>>> fetchLyrics() async {
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
        lyrics(*)
      )
    )
  ''')
          .filter('date', 'gte', nowIso)
          .order('date', ascending: true)
          .limit(1);

      final day = response.first['lyrics'];
      return Result.ok(
        day.map<String>((music) => Lyrics.fromMap(music)).toList(),
      );
    } catch (e) {
      return Result.error(Exception('Erro na busca do DB'));
    }
  }
}
