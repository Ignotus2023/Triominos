import 'package:intl/intl.dart';

String formatGameDate(DateTime when, String locale) {
  return DateFormat.yMMMd(locale).add_Hm().format(when);
}

String formatDuration(Duration d) {
  if (d.inHours > 0) {
    final mins = (d.inMinutes % 60).toString().padLeft(2, '0');
    return '${d.inHours}h $mins min';
  }
  if (d.inMinutes > 0) return '${d.inMinutes} min';
  return '${d.inSeconds} s';
}
