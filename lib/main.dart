import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/main_screen.dart';
import 'providers/Wardrobe_provider.dart';
import 'providers/category_provider.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WardrobeProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
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
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF141123),
        textTheme: GoogleFonts.manropeTextTheme(
          ThemeData.dark().textTheme,
        )
      ),
      home: const MainScreen(),
    );
  }
}
