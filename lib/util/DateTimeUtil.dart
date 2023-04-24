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

  static daysToNow(tz.TZDateTime from) {
    var to = tz.TZDateTime.now(tz.local);
    return to.difference(from).inDays;
  }

}
