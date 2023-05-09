import 'package:flutter/material.dart';
import 'clock.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ads.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      localizationsDelegates: AppLocalizations.localizationsDelegates, // 追加
      supportedLocales: AppLocalizations.supportedLocales,             // 追加

      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
      ),
      themeMode: ThemeMode.system, // モードをシステム設定にする
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).timer),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(child:Container(alignment: Alignment.center, child:const Clock())),
            Container(margin: const EdgeInsets.all(20),child:const Ads(size: AdSize.banner))
          ]
        ),
      ),
    );
  }
}
