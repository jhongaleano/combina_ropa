import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../providers/Wardrobe_provider.dart';
import '../providers/category_provider.dart';
import 'package:gradient_borders/gradient_borders.dart';

class GarmentScreen extends StatefulWidget {
  const GarmentScreen({super.key});

  @override
  State<GarmentScreen> createState() => _GarmentScreenState();
}

class _GarmentScreenState extends State<GarmentScreen> {
  File? _imagenSeleccionada;
  final TextEditingController _nombreControllador = TextEditingController();
  String? _categoriaSeleccionada;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final categories = context.read<CategoryProvider>().categoria;
      if (categories.isNotEmpty) {
        setState(() {
          _categoriaSeleccionada = categories.first;
        });
      }
    });
  }

  @override
  void dispose() {
    _nombreControllador.dispose();
    super.dispose();
  }

  Future<void> _capturarFoto(WardrobeProvider provider) async {
    final foto = await provider.prendaImagen();
    if (foto != null) {
      setState(() {
        _imagenSeleccionada = foto;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final wardrobeProvider = context.read<WardrobeProvider>();
    final categoryProvider = context.watch<CategoryProvider>();
    final listaCategorias = categoryProvider.categoria;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            SizedBox(height: 15),

            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF9891a2).withValues(alpha: 0.12),
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: _imagenSeleccionada == null
                        ? Opacity(
                            opacity: 0.3,
                            child: Image.network(
                              "https://imgs.search.brave.com/loaMQbsanH6z5CqWTGhOCVtoZJdOGwNpkmTWXHAQY-4/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9zdGF0/aWMudmVjdGVlenku/Y29tL3N5c3RlbS9y/ZXNvdXJjZXMvdGh1/bWJuYWlscy8wNDQv/MDI2LzU1Ny9zbWFs/bC9tb2NrdXAtdGVt/cGxhdGUtamVyc2V5/LWZvb3RiYWxsLXdo/aXRlLXNoaXJ0LXNv/Y2Nlci1iYWNrLXZp/ZXctZnJlZS1wbmcu/cG5n",
                              fit: BoxFit.contain,
                            ),
                          )
                        : Image.file(_imagenSeleccionada!, fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  child: Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(203, 133, 122, 125),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFfaf9e8),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(
                            255,
                            144,
                            92,
                            184,
                          ).withValues(alpha: 0.6),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: const Color(0xFFfaf9e8),
                            width: 2,
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () => _capturarFoto(wardrobeProvider),
                          child: Icon(
                            Icons.camera_alt,
                            size: 30,
                            color: const Color(0xFFcabb97),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_imagenSeleccionada != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  "¡Imagen capturada!",
                  style: TextStyle(color: Colors.greenAccent[100]),
                ),
              ),
            const SizedBox(height: 30),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 10, bottom: 8),
              child: Text(
                "Nombre de la prenda",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(15),
                border: const GradientBoxBorder(
                  gradient: LinearGradient(
                    colors: [Color(0xFFC49BF0), Color(0xFFFBE4AD)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  width: 1.5,
                ),
              ),
              child: TextField(
                controller: _nombreControllador,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Ej: Camiseta Oversize" ,
                  hintStyle:const TextStyle(
                    color: Color(0xFFFBE4AD),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 20),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 10, bottom: 8),
              child: Text(
                "Categoría",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(15),
                border: const GradientBoxBorder(
                  gradient: LinearGradient(
                    colors: [Color(0xFFC49BF0), Color(0xFFFBE4AD)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  width: 1.5,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _categoriaSeleccionada,
                  isExpanded: true,
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFFFBE4AD),
                  ),
                  dropdownColor: const Color(0xFF23172d),
                  style: const TextStyle(
                    color: Color(0xFFFBE4AD),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  items: listaCategorias.isEmpty
                      ? [
                          const DropdownMenuItem(
                            value: null,
                            child: Text("Sin categorías"),
                          ),
                        ]
                      : listaCategorias
                            .map(
                              (cat) => DropdownMenuItem(
                                value: cat,
                                child: Text(cat),
                              ),
                            )
                            .toList(),
                  onChanged: (val) =>
                      setState(() => _categoriaSeleccionada = val),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              width: double.infinity, // Ocupa todo el ancho disponible
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFFBE4AD).withValues(alpha: 0.6),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFBE4AD),
                  foregroundColor: Color(0xFF8C759F),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  FocusScope.of(context).unfocus();

                  final name = _nombreControllador.text.trim();
                  if (_imagenSeleccionada != null &&
                      name.isNotEmpty &&
                      _categoriaSeleccionada != null) {
                    wardrobeProvider.agregarPrenda(
                      name: name,
                      category: _categoriaSeleccionada!,
                      imagePath: _imagenSeleccionada!.path,
                    );
                    _nombreControllador.clear();
                    setState(() => _imagenSeleccionada = null);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("¡Prenda guardada con éxito!"),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("! Completa todos los campos y la foto"),
                      ),
                    );
                  }
                },
                child: const Text(
                  "Guardar en Armario",
                  style: TextStyle(
                    color: Color(0xFF8C759F), // Mismo morado apagado
                    fontSize: 20, // Tamaño de fuente
                    fontWeight:
                        FontWeight.w500, // Grosor medio (similar a tu imagen)
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
