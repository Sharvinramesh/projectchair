// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:projectchair/datas/datamodel.dart';
import 'package:projectchair/screens/splash_screen.dart';

// Constant key for saving user login state
const SAVE_KEY_NAME = 'userLoggedIn';

Future<void> main() async {
  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters if not already registered
  if (!Hive.isAdapterRegistered(UserdatamodelAdapter().typeId)) {
    Hive.registerAdapter(UserdatamodelAdapter());
  }

  if (!Hive.isAdapterRegistered(CategorymodelAdapter().typeId)) {
    Hive.registerAdapter(CategorymodelAdapter());
  }

  if (!Hive.isAdapterRegistered(ProductmodelAdapter().typeId)) {
    Hive.registerAdapter(ProductmodelAdapter());
  }

  if (!Hive.isAdapterRegistered(SellProductAdapter().typeId)) {
    Hive.registerAdapter(SellProductAdapter());
  }

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
