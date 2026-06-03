import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:space_anywhere/pages/drawer_page.dart';
import 'package:space_anywhere/services/audio_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  await AudioServices.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpaceAnywhere',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: const Color.fromARGB(255, 7, 13, 72)),
      ),
      home: const DrawerPage()
    );
  }
}