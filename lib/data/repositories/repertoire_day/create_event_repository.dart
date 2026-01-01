import 'package:band_app/data/services/api/api_client.dart';
import 'package:band_app/utils/result.dart';

class CreateEventRepository {
  final ApiClient supabase;

  CreateEventRepository(this.supabase);

  Future<Result<bool>> createEvent(
    String title,
    String observations,
    DateTime date,
  ) async {
    try {
      await supabase.client.from('repertoire_day').insert({
        'title': title,
        'observations': observations,
        'date': date.toIso8601String(),
      });
      return Result.ok(true);
    } catch (e) {
      return Result.error(
        Exception(
          'Não foi possível criar o evento. Por favor, tente novamente mais tarde.',
        ),
      );
    }
  }
}
