


import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supporthive1/view/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 🔥 INIT HIVE
  await Hive.initFlutter();

  /// 🔥 OPEN BOX (for game + notes etc.)
  await Hive.openBox('gameBox');
  await Hive.openBox('breathingSessions');
   await Hive.openBox('notesBox');
   

  runApp(const SupportHiveApp());
}
class SupportHiveApp extends StatelessWidget {
  const SupportHiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SupportHive',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF5F5F0),
        fontFamily: 'Roboto',
      ),
      home: const WelcomeScreen(),
    );
  }
}