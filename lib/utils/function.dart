import 'package:timeago/timeago.dart' as timeago;


String timeUntil(DateTime date) {
  return timeago.format(date, allowFromNow: true, locale: 'en');
}