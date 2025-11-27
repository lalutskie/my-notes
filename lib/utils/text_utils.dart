import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

class TextUtils {
  static String format({required DateTime date, String? format}) {
    if (format != null && format.isNotEmpty) {
      final formatter = DateFormat(format);
      return formatter.format(date);
    }

    // default to timeago if no format provided
    return timeago.format(date, locale: 'en_short');
  }

  static String displayText(String? value, String fallback) {
    if (value == null || value.isEmpty) {
      return fallback;
    }

    return value;
  }

  static String capitalizeEachWord(String text) {
    if (text.isEmpty) return text;

    return text
        .split(' ') // Split by space
        .map(
          (word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
              : '',
        )
        .join(' ');
  }
}
