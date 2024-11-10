import 'package:flutter/material.dart';
import 'package:dominoes_score_calc/presentation/pages/splash.dart';

void main() {
  runApp(const DominoesScoreCalculatorApp());
}

class DominoesScoreCalculatorApp extends StatefulWidget {
  const DominoesScoreCalculatorApp({super.key});

  @override
  _DominoesScoreCalculatorAppState createState() =>
      _DominoesScoreCalculatorAppState();
}

class _DominoesScoreCalculatorAppState
    extends State<DominoesScoreCalculatorApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
