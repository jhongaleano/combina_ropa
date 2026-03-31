import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/main_screen.dart';
import 'providers/Wardrobe_provider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WardrobeProvider()),
      ],
      child: const StyleStack(),
    ),
  );
}
class StyleStack extends StatelessWidget {
  const StyleStack({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'StyleStack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF23172d),
      ),
      home: const MainScreen(),
    );
  }
}
