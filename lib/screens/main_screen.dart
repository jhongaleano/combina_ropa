import 'package:flutter/material.dart';
import '../screens/home-screen.dart';
import '../widget/outfit_widget.dart';
import '../screens/favorite-screen.dart';
import 'package:combina_ropa/screens/garment_screens.dart';
import 'package:google_fonts/google_fonts.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Lista de pantallas para navegar
  final List<Widget> _pages = [HomeScreen(), FavoriteScreen() ,GarmentScreen()];

  @override
  Widget build(BuildContext context) {
    const activeColor = Color.fromARGB(255, 183, 38, 180);
    const inactiveColor = Color.fromARGB(255, 82, 63, 91);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 30, 20, 45),
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: const Color.fromARGB(255, 51, 37, 74),
        title: Column(
          children: [
            Row(
              children: [
                Icon(Icons.layers, size: 30, color: Colors.white),
                Text(
                  "StyleStack -",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.playfairDisplay().fontFamily,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  _currentIndex == 0
                      ? "Home"
                      : _currentIndex == 1
                      ? "Favoritos"
                      : _currentIndex == 2
                      ? "Agregar Prenda"
                      : "Recomendaciones",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w300,
                    fontFamily: GoogleFonts.raleway().fontFamily,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    "https://static.wikia.nocookie.net/peanuts/images/b/b7/Modern_Snoopy_in_a_nutshell.jpg/revision/latest/scale-to-width/360?cb=20241020133255",
                    width: 35,
                    height: 34,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                const Text("Cristhian Padilla", style: TextStyle(fontSize: 14)),
              ],
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 110),
              child: IndexedStack(index: _currentIndex, children: _pages),
            )
          ),

          Positioned(
            left: 10, 
            right: 10, 
            bottom: 15, 
            child: const OutfitWidget()
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 87,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 51, 37, 74),
          border: Border.all(color: const Color(0xFF4c4056), width: 2),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 128, 110, 143),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedLabelStyle: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.montserrat(
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
          selectedItemColor: activeColor,
          unselectedItemColor: inactiveColor,
          onTap: (index) => setState(() => _currentIndex = index),
          items: [
            _buildNavItem(Icons.home, "Home", 0),
            _buildNavItem(Icons.favorite, "Favoritos", 1),
            _buildNavItem(Icons.add, "Agregar", 2),
            _buildNavItem(Icons.auto_awesome, "Recomendaciones", 3),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
    IconData icon,
    String label,
    int index,
  ) {
    bool isActive = _currentIndex == index;
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        size: 35,
        shadows: isActive
            ? [
                Shadow(
                  color: const Color.fromARGB(
                    255,
                    183,
                    38,
                    180,
                  ).withValues(alpha: 0.8),
                  blurRadius: 15,
                ),
              ]
            : [],
      ),
      label: label,
    );
  }
}
