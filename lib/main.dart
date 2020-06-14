import 'package:background_fetch/background_fetch.dart';
import 'package:covid_charts/core/services/backgroundFetch.dart';
import 'package:covid_charts/ui/screens/OnBoarding.dart';
import 'package:covid_charts/ui/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'core/services/sharedPref.dart';
int appLaunch;

  Future<void>  main() async{
  FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.dumpErrorToConsole(details);
      if (kReleaseMode)
        exit(1);
    };
  WidgetsFlutterBinding.ensureInitialized();
  appLaunch = await SharedPref.getInt("appLaunch") ?? 0;
  runApp(MyApp());
  BackgroundFetch.registerHeadlessTask(BackgroundProcess.backgroundFetchHeadlessTask);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: 'Covid Charts',
      theme: ThemeData(fontFamily: 'Montserrat'),
      home: appLaunch == 0 ? OnBoarding() : HomeScreen(),
      debugShowCheckedModeBanner: false,
      builder: (BuildContext context, Widget child) {
      final MediaQueryData data = MediaQuery.of(context);
      return MediaQuery(
        data: data.copyWith(textScaleFactor: data.textScaleFactor>1.25 ? 1.25:data.textScaleFactor),
        child: child,
      );
    },
    );
  }
}

