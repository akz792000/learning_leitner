import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learning_leitner/repository/CardModelRepository.dart';

import 'model/CardModel.dart';
import 'view/home/HomeView.dart';
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
  Hive.registerAdapter(CardModelAdapter());

  // Opening the box
  await Hive.openBox(CardModelRepository.boxId);

  // get the directory where the hive save data
  Directory directory = await path_provider.getApplicationDocumentsDirectory();
  if (kDebugMode) {
    print(directory.path);
  }
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
        home: const HomeView(),
      );
    });
  }
}
