import 'dart:core';
import 'dart:async';
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
  template: '''
	<h1>{{title}}</h1>
	<div>{{realTime}}</div>
	<br>
	<div>{{alterTime}}</div>
	''',
)
class AlterClock {
  String title = "Alter-clock";
  String alterTime = "zero hour";
  String realTime;
  DateTime now;

  AlterClock() {
    update();
  }

  /// Update the time.
  void update() {
    const delay = const Duration(milliseconds: 1);
    new Timer.periodic(delay, (Timer t) => this.display());
  }

  /// Display the time.
  display() {
    now = new DateTime.now();
    //print("\x1B[2J\x1B[0;0H");
    // ${padLeftVariable(getRealMilliSecond(), 3)}
    // ${padLeftTwo(getSlowSecond())}
    realTime = """
${padLeftTwo(getRealHour())}:${padLeftTwo(getRealMinute())}:${padLeftTwo(getRealSecond())} - Real time
	    """;
    alterTime = """
${padLeftTwo(getRealHour())}:${padLeftTwo(getMi())}:${padLeftTwo(getSi())} - Interval time
          """;
  }

  /// Left-pad the string with two zeros.
  /// 00, 01, 10
  String padLeftTwo(int n) {
    return n.toString().padLeft(2, "0");
  }

  /// Left-pad the string with 'p' number of zeros.
  String padLeftVariable(int n, int p) {
    return n.toString().padLeft(p, "0");
  }

  /// Actual milliseconds.
  int getRealMilliSecond() {
    return now.millisecond;
  }

  /// Actual seconds.
  /// Sh
  int getRealSecond() {
    return now.second;
  }

  /// Actual minutes.
  /// Mh
  int getRealMinute() {
    return now.minute;
  }

  /// Actual hour
  /// Hh
  int getRealHour() {
    return now.hour;
  }

  /// Actual minutes in terms of seconds.
  int getMs() {
    return getRealMinute() * 60;
  }

  /// A "slow second", equal to 3.6 seconds. There are 10 slow seconds
  /// in one second.
  int getSlowSecond() {
    return (getSi() / 3.6).truncate();
  }

  /// Interval second as integer.
  int getSi() {
    return (getMs() + getRealSecond()) % 36;
  }

  /// Interval minute as integer.
  int getMi() {
    return ((getMs() + getRealSecond()) / 36).truncate();
  }
}
