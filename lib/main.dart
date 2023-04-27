  import 'package:ultimate_gpt/page_home.dart';
  import 'package:flutter/material.dart';

  void main() {runApp(const AIDatasetsTrainerApp());}

  class AIDatasetsTrainerApp extends StatelessWidget {
    const AIDatasetsTrainerApp({Key? key}) : super(key: key);
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'UltimateGPT',
        theme: ThemeData(primarySwatch: Colors.blue,),
        home: const HomePage(title: 'UltimateGPT'),
      );
    }
  }