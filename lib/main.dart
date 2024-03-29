import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learning_leitner/entity/InfoEntity.dart';
import 'package:learning_leitner/repository/CardRepository.dart';
import 'package:learning_leitner/repository/InfoRepository.dart';
import 'package:learning_leitner/service/RouteService.dart';

import 'config/DependencyConfig.dart';
import 'config/RouteConfig.dart';
import 'entity/CardEntity.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:sizer/sizer.dart';
import 'package:timezone/data/latest.dart' as tz;

main() async {
  await setup();
  runApp(MyApp());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize time zone
  tz.initializeTimeZones();

  // initialize Hive
  await Hive.initFlutter();

  // Registering the adapter
  Hive.registerAdapter(CardEntityAdapter());
  Hive.registerAdapter(InfoEntityAdapter());

  // Opening the box
  await Hive.openBox(CardRepository.boxId);
  await Hive.openBox(InfoRepository.boxId);

  // get the directory where the hive save data
  Directory directory = await path_provider.getApplicationDocumentsDirectory();
  debugPrint(directory.path);

  // Register dependency config
  await DependencyConfig.registerDependencies();
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        title: 'zlietner',
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
        ),
        debugShowCheckedModeBanner: false,
        //home: const HomeView(),
        navigatorKey: Get.find<RouteService>().navigatorKey,
        onGenerateRoute: (settings) => RouteConfig().generateRoute(settings),
      );
    });
  }
}
