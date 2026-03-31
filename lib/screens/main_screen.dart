import 'package:flutter/material.dart';
import '../widget/outfit_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Lista de pantallas para navegar
  final List<Widget> _pages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: const Color.fromARGB(255, 51, 37, 74),
        title: Column(
          children: [
            Row(
              children: [
                Icon(Icons.checkroom, size: 30),
                Text(
                  "StyleStack",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
                Text("- Home"),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    "https://imgs.search.brave.com/Zt0iPvoSENj43SyjOZQD4CPzonxOPfInlysGYnb9La8/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9tZWRp/YS5pc3RvY2twaG90/by5jb20vaWQvMTE3/OTQyMDM0My9lcy9m/b3RvL2hvbWJyZS1z/b25yaWVudGUtYWwt/YWlyZS1saWJyZS1l/bi1sYS1jaXVkYWQu/anBnP3M9NjEyeDYx/MiZ3PTAmaz0yMCZj/PW5fRVAwM1ItNEtt/SV9WZzJlVkQ0SGxL/RGpzLW5ONkc2Nm9Z/ZGRDVzFJelU9",
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Text("Cristhian Padilla "),
              ],
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: IndexedStack(index: _currentIndex, children: _pages),
          ),

          Positioned(
            left: 5,
            right: 5,
            bottom: 8,
            child: const OutfitWidget(),
          )
        ],
      ),
      bottomNavigationBar: Container(
        height: 90,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 51, 37, 74),
          border: Border.all(color: const Color(0xFF4c4056), width: 2),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(60),
            bottomRight: Radius.circular(60),
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
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: const Color.fromARGB(255, 183, 38, 180),
          unselectedItemColor: const Color.fromARGB(255, 57, 54, 54),
          onTap: (index) => setState(() => _currentIndex = index),
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _currentIndex == 0
                    ? const Color.fromARGB(255, 183, 38, 180)
                    : const Color.fromARGB(255, 57, 54, 54),
                size: 35,
                shadows: _currentIndex == 0
                    ? [
                        Shadow(
                          color: const Color.fromARGB(
                            255,
                            183,
                            38,
                            180,
                          ).withValues(alpha: 0.8),
                          blurRadius: 15.0,
                        ),
                        Shadow(
                          color: const Color.fromARGB(
                            255,
                            183,
                            38,
                            180,
                          ).withValues(alpha: 0.5),
                          blurRadius: 30.0,
                        ),
                      ]
                    : [],
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                color: _currentIndex == 1
                    ? const Color.fromARGB(255, 183, 38, 180)
                    : const Color.fromARGB(255, 57, 54, 54),
                size: 35,
                shadows: _currentIndex == 1
                    ? [
                        Shadow(
                          color: const Color.fromARGB(
                            255,
                            183,
                            38,
                            180,
                          ).withValues(alpha: 0.8),
                          blurRadius: 15.0,
                        ),
                        Shadow(
                          color: const Color.fromARGB(
                            255,
                            183,
                            38,
                            180,
                          ).withValues(alpha: 0.5),
                          blurRadius: 30.0,
                        ),
                      ]
                    : [],
              ),
              label: "Favoritos",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add,
                color: _currentIndex == 2
                    ? const Color.fromARGB(255, 183, 38, 180)
                    : const Color.fromARGB(255, 57, 54, 54),
                size: 35,
                shadows: _currentIndex == 2
                    ? [
                        Shadow(
                          color: const Color.fromARGB(
                            255,
                            183,
                            38,
                            180,
                          ).withValues(alpha: 0.8),
                          blurRadius: 15.0,
                        ),
                        Shadow(
                          color: const Color.fromARGB(
                            255,
                            183,
                            38,
                            180,
                          ).withValues(alpha: 0.5),
                          blurRadius: 30.0,
                        ),
                      ]
                    : [],
              ),
              label: "Agregar",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.recommend,
                color: _currentIndex == 3
                    ? const Color.fromARGB(255, 183, 38, 180)
                    : const Color.fromARGB(255, 57, 54, 54),
                size: 35,
                shadows: _currentIndex == 3
                    ? [
                        Shadow(
                          color: const Color.fromARGB(
                            255,
                            183,
                            38,
                            180,
                          ).withValues(alpha: 0.8),
                          blurRadius: 15.0,
                        ),
                        Shadow(
                          color: const Color.fromARGB(
                            255,
                            183,
                            38,
                            180,
                          ).withValues(alpha: 0.5),
                          blurRadius: 30.0,
                        ),
                      ]
                    : [],
              ),
              label: "Recomendaciones ",
            ),
          ],
        ),
      ),
    );
  }
}
