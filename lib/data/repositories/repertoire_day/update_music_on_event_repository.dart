import 'package:band_app/data/services/api/api_client.dart';
import 'package:band_app/domain/models/repertoire_day/music.dart';
import 'package:band_app/domain/models/lyrics/lyrics.dart';

import '../../../utils/result.dart';

class UpdateMusicOnEventRepository {
  final ApiClient supabase;

  UpdateMusicOnEventRepository(this.supabase);

  Future<Result<List<Music>>> getAllMusics() async {
    try {
      final response = await supabase.client
          .from('music')
          .select('id, name, artist')
          .order('name', ascending: true);

      final list = (response as List)
          .map<Music>(
            (m) => Music(
              id: m['id'],
              name: m['name'] ?? '',
              artist: m['artist'] ?? '',
              lyrics: [],
              ciphers: [],
              order: 0,
            ),
          )
          .toList();

      return Result.ok(list);
    } catch (e) {
      return Result.error(Exception('Erro ao buscar músicas'));
    }
  }

  Future<Result<void>> addMusicsToEvent({
    required String eventId,
    required List<Music> musics,
  }) async {
    try {
      final rows = musics.asMap().entries.map((e) {
        return {'repertoire_day': eventId, 'music': e.value.id, 'order': e.key};
      }).toList();

      if (rows.isNotEmpty) {
        await supabase.client.from('repertoire_music').insert(rows);
      }

      return Result.ok(null);
    } catch (e) {
      return Result.error(Exception('Erro ao adicionar músicas ao evento'));
    }
  }

  Future<Result<void>> removeMusicsToEvent({
    required String eventId,
    required List<Music> musics,
  }) async {
    try {
      for (final m in musics) {
        await supabase.client.from('repertoire_music').delete().match({
          'repertoire_day': eventId,
          'music': m.id,
        });
      }

      return Result.ok(null);
    } catch (e) {
      return Result.error(Exception('Erro ao remover músicas do evento'));
    }
  }
}
