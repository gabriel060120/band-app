import 'package:intl/intl.dart';

class StringUtils {
  static String convertToDateString(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
