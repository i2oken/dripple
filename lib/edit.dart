import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:intl/intl.dart';
import 'pref.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AlarmEditor extends StatefulWidget {
  const AlarmEditor({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AlarmEditor();
  }
}

class _AlarmEditor extends State<AlarmEditor>{

  AlarmPref alarmPref = AlarmPref();
  List<String> alarms = [];
  List<int> min = [];
  List<int> sec = [];

  Future<List<String>> _setList() async {
      return await alarmPref.getAlarms();
  }

  @override
  void initState() {
    super.initState();
    min = List.generate(5, (index) => index + 1);
    sec = List.generate(59, (index) => index + 1);
    min.insert(0,0);
    sec.insert(0,0);
    _setList().then((_alarms){
      setState(() {
        alarms = _alarms;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    List<List<int>> timePicker = [min,sec];

    return Scaffold(
        appBar: AppBar(
            title : Text(AppLocalizations.of(context).edit_alarm)
        ),
        body : Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextButton(
                child: Text('+${AppLocalizations.of(context).add_alarm}'),
                onPressed: () {
                  Picker(
                      adapter: PickerDataAdapter<String>(pickerData: timePicker, isArray: true),
                      delimiter: [
                        PickerDelimiter(child: Container(
                          width: 30.0,
                          alignment: Alignment.center,
                          child: const Text(":"),
                        ))
                      ],
                      hideHeader: true,
                      title: Text(AppLocalizations.of(context).min_sec,textAlign: TextAlign.center),
                      onConfirm: (Picker picker, List value) {
                        var f = NumberFormat("00");
                        var selectedMin = f.format(value[0]);
                        var selectedSec = f.format(value[1]);
                        var time = "$selectedMin:$selectedSec";

                        setState(() {
                          alarms.add(time);
                          alarms.sort((a, b) => a.compareTo(b));
                          alarmPref.setAlarms(alarms);
                        });
                      }
                  ).showDialog(context);
                },
              ),
              SizedBox(
                width:200,
                child:
                Column(
                  children: [
                    for(var alarm in alarms)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(alarm, style: const TextStyle( fontSize: 20)),
                        TextButton(onPressed: () {
                          var idx = alarms.indexOf(alarm);
                          setState(() {
                            alarms.removeAt(idx);
                            alarmPref.setAlarms(alarms);
                          });
                        }, child: const Icon(Icons.close)),
                      ],
                    )
                  ]
                )
              ),
          ]),
        ),
    );
  }
}