// ignore_for_file: no_leading_underscores_for_local_identifiers, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:taskmate/db/db_helper.dart';
import 'package:taskmate/screens/splash.dart';

const SAVE_KEY = 'userLoggedIn';
const CATEGORY_KEY = 'alreadyAdded';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Clear the database ()
  await DBHelper.clearDatabase();

  // Initialize shared preferences and clear all data
  final _sharedPrefs = await SharedPreferences.getInstance();
  await _sharedPrefs.clear();

  // Create the database
  await DBHelper.createDatabase();
  await DBHelper.createTaskDatabase();

  // Run the Flutter application
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Debug banner is disabled
      debugShowCheckedModeBanner: false,

      // App title
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),

      // Initial screen is the Splash widget
      home: const Splash(),
    );
  }
}