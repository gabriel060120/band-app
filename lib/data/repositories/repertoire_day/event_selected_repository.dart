import 'package:band_app/data/services/api/api_client.dart';
import 'package:band_app/domain/models/repertoire_day/event_data.dart';
import 'package:band_app/utils/result.dart';

class EventSelectedRepository {
  final ApiClient supabase;

  EventSelectedRepository(this.supabase);

  Future<Result<EventData>> fetchEventData(String id) async {
    try {
      final data = await supabase.client
          .from('repertoire_day')
          .select('''
      id,
      date,
      title,
      observations,
      repertoire_music (
        order,
        music (
          id,
          name,
          artist
        )
      )
    ''')
          .eq('id', id)
          .maybeSingle();
      return Result.ok(EventData.fromMap(data ?? {}));
    } catch (e) {
      return Result.error(
        Exception(
          'Não conseguimos carregar os dados do evento. Por favor, entre em contato com o suporte.',
        ),
      );
    }
  }
}
