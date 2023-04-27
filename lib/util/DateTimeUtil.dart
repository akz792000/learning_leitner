import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart' as intl;

class DateTimeUtil {
  static tz.TZDateTime now() {
    return tz.TZDateTime.now(tz.local);
  }

  static format(String pattern, tz.TZDateTime dateTime) {
    return intl.DateFormat(pattern).format(dateTime);
  }

  static String adjustDateTime(tz.TZDateTime dateTime) {
    var timezoneOffset = DateTime.now().timeZoneOffset;
    var timeDiff = Duration(
      hours: timezoneOffset.inHours,
      minutes: timezoneOffset.inMinutes % 60,
    );

    // adjust the time diff
    var adjust = dateTime.add(timeDiff);
    return intl.DateFormat("yyyy-MM-dd HH:mm").format(adjust);
  }

  static int daysToNow(tz.TZDateTime from) {
    var to = tz.TZDateTime.now(tz.local);
    return to.difference(from).inDays;
  }

  static int daysToNowWithoutTime(tz.TZDateTime from) {
    var to = tz.TZDateTime.now(tz.local);
    var utcFrom = tz.TZDateTime.utc(from.year, from.month, from.day);
    var utcTo = tz.TZDateTime.utc(to.year, to.month, to.day);
    return utcTo.difference(utcFrom).inDays;
  }
}
