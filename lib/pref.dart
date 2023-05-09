import 'package:shared_preferences/shared_preferences.dart';

class AlarmPref {

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> setAlarms(alarms) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setStringList('alarms', alarms);
    // print("set alarm.");
  }

  Future<List<String>> getAlarms() async {
    final SharedPreferences prefs = await _prefs;
    var list = prefs.getStringList('alarms') ?? [];
    // print("get alarm." + list.toString());
    return list;
  }

  Future<void> initAlarm() async {
    final SharedPreferences prefs = await _prefs;
    var list = prefs.getStringList('alarms') ?? [];
    var didInit = prefs.getBool('init') ?? false;
    if(list.isEmpty && !didInit){
      await prefs.setBool('init', true);
      await prefs.setStringList('alarms', ['00:30']);
    }

  }

}