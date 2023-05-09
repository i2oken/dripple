import 'edit.dart';
import 'analytics.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:wakelock/wakelock.dart';
import 'pref.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Clock extends StatefulWidget {
  const Clock({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ClockState();
  }
}

class _ClockState extends State<Clock> {
  AlarmPref alarmPref = AlarmPref();
  final _audio = AudioPlayer();

  int _time = 0;
  int _min = 0;
  int _sec = 0;
  String _timer = '00:00';
  String _timerBtn = "";
  String _nextAlarm = "--:--";
  List<String> alarms = [];
  List<int> alarmSec = [];
  bool inExcution = false;
  Timer? timer;

  setAlarmSec() async {

   var _alarms = await alarmPref.getAlarms();

    setState(() {
      alarms = _alarms;
    });

    alarmSec = [];
    for(var alarm in alarms){
      var _alarmDataSet = alarm.split(":");
      var _alarmMin = int.parse(_alarmDataSet[0]);
      var _alarmSec = int.parse(_alarmDataSet[1]);
      alarmSec.add(_alarmMin * 60 + _alarmSec);
    }

  }

  startTimer() {
    Wakelock.enable();
    setState(() {
      _timerBtn = AppLocalizations.of(context).reset;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _onTimer();
    });
  }

  cancelTimer() {
    Wakelock.disable();
    timer?.cancel();
    _time = 0;
    _min = 0;
    _sec = 0;
    setState(() {
      _timer = '00:00';
      _timerBtn = AppLocalizations.of(context).start;
    });
    setAlarmSec();
  }

  void _onTimer() {

    var f = NumberFormat("00");
    _time++;
    _min = _time ~/ 60;
    _sec = _time % 60;

    if(alarmSec.isNotEmpty){
      if(_time == alarmSec[0]){

        alarmSec.removeAt(0);
        _audio.setVolume(1.0);
        _audio.play(AssetSource("sound.mp3"));
        setState(() {
          alarms.removeAt(0);
        });
      }
    }

    if(mounted){
      setState(() => {
        _timer = "${f.format(_min)}:${f.format(_sec)}"
      });
    }
  }

  @override
  void initState() {
    alarmPref.initAlarm().then((_){
      setAlarmSec();
      _timerBtn = AppLocalizations.of(context).start;
      // print("init alarm.");
    });
    AnalyticsService().logPage('clock');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if(alarms.isNotEmpty){
      _nextAlarm = alarms[0];
    }else{
      _nextAlarm = '--:--';
    }

    return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
        SizedBox(
          height: 120,
          child:
          Text(
              _timer,
              style: GoogleFonts.lato(
                fontSize: 72,
              )
          ),
        ),
      SizedBox(
        width: 100, height:100,//横幅
        child:(
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
            ),
            onPressed: () {
              if(!inExcution){
                startTimer();
                inExcution = true;
              }else{
                cancelTimer();
                inExcution = false;
              }
            },
            child: Text(_timerBtn),
            )
          )
        ),
          Container(
            margin: const EdgeInsets.fromLTRB(0,40, 0,0),
            width:300,
            height:24,
            child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(AppLocalizations.of(context).next_alarm,style: const TextStyle( fontSize: 16)),
                Text(_nextAlarm,style: const TextStyle( fontSize: 20)),
              ],
            ),
          ),
          TextButton(
            child: Text(AppLocalizations.of(context).edit_alarm),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AlarmEditor()),
              ).then((value){
                cancelTimer();
              });
            },
          ),
      ]
    );
  }
}