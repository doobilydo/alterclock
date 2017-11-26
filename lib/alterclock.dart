import 'dart:core';
import 'dart:async';
import 'dart:html';
import 'dart:math';
import 'package:angular/angular.dart';

/**
 * Alterclock will sync with normal time every 3 minutes.
 *
 *  H: M: S
 * 01:00:00 - 01:00:00
 * 01:03:00 - 01:05:00
 * 01:06:00 - 01:10:00
 * 01:09:00 - 01:15:00
 * 01:12:00 - 01:20:00
 * 01:15:00 - 01:25:00 (1/4 of an hour)
 */
@Component(
  selector: 'alter-clock',
  templateUrl: 'alterclock_component.html',
)
class AlterClock {
  String title = "Alter-clock";
  DateTime now;

  var intervalHour,
      intervalMinute,
      intervalSecond,
      militaryHour,
      normalMinute,
      normalSecond,
      meridiem;

  AlterClock() {
    update();
  }

  /// Update the time.
  void update() {
    const delay = const Duration(milliseconds: 100);
    new Timer.periodic(delay, (Timer t) => this.display());
  }

  /// Display the time.
  display() {
    now = new DateTime.now();

    intervalHour = "${padLeftTwo(getReal12Hour())}";
    intervalMinute = "${padLeftTwo(getMi())}";
    intervalSecond = "${padLeftTwo(getSi())}";

    militaryHour = "${padLeftTwo(getReal24Hour())}";
    normalMinute = "${padLeftTwo(getRealMinute())}";
    normalSecond = "${padLeftTwo(getRealSecond())}";

    meridiem = getMeridiem();

    var secondTimer = document.querySelector('#second-timer'),
        minuteTimer = document.querySelector('#minute-timer'),
        hourTimer = document.querySelector('#hour-timer');

    var a = (getSi() / 36) * 360,
        m = (getMi() / 100) * 360,
        h = (getReal24Hour() / 24) * 360;

    updateTimer(a, secondTimer);
    updateTimer(m, minuteTimer);
    updateTimer(h, hourTimer);
  }

  /// Update the progress meter for
  /// hour, minute, and second.
  void updateTimer(var a, element) {
    var r = (a * PI / 180),
        x = sin(r) * 125,
        y = cos(r) * -125,
        mid = (a > 180) ? 1 : 0,
        anim = """
M 0 0 V -125 A 125 125 1 $mid 1 $x $y z
        """;

    //print(anim);
    element.setAttribute('d', anim);
  }

  /// Left-pad the string with two zeros.
  /// 00, 01, 10
  String padLeftTwo(int n) => n.toString().padLeft(2, "0");

  /// Left-pad the string with 'p' number of zeros.
  String padLeftVariable(int n, int p) => n.toString().padLeft(p, "0");

  //-------------------------------------

  getMeridiem() =>
      (getReal24Hour() < 12) ? "am" /*ante meridiem*/ : "pm" /*post meridiem*/;

  /// Actual milliseconds.
  int getRealMilliSecond() => now.millisecond;

  /// Actual seconds.
  /// Sh
  int getRealSecond() => now.second;

  /// Actual minutes.
  /// Mh
  int getRealMinute() => now.minute;

  /// Actual hour (24-hour)
  /// Hh
  int getReal24Hour() => now.hour;

  /// Actual hour (12-hour)
  int getReal12Hour() => ((now.hour % 12) == 0) ? 1 : (now.hour % 12);

  /// Actual minutes in terms of seconds.
  int getMs() => getRealMinute() * 60;

  //-------------------------------------

  /// A "slow second", equal to 3.6 seconds. There are 10 slow seconds
  /// in one second.
  /// (Don't think I want to use this.)
  int getSlowSecond() => (getSi() / 3.6).truncate();

  /// Interval second as integer.
  int getSi() => (getMs() + getRealSecond()) % 36;

  /// Interval minute as integer.
  int getMi() => ((getMs() + getRealSecond()) / 36).truncate();

  //-------------------------------------

  /// Convert Interval minute to normal minute.
  int convertToNormalMinute(int intervalMinute) =>
      ((intervalMinute / 100) * 60).truncate();

  /// Convert Interval seconds to normal seconds.
//  int convertToNormalSecond(int intervalSecond, intervalMinute, normalMinute) =>

}
