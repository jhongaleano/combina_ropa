import 'package:flutter/material.dart';
import './widget/outfit_widget.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Combina tu ropa',
      debugShowCheckedModeBanner: false,

      home: OutfitWidget(),
    );
  }
}
