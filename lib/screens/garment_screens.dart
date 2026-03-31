import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../providers/Wardrobe_provider.dart';

class GarmentScreen extends StatefulWidget {
  const GarmentScreen({super.key});

  @override
  State<GarmentScreen> createState() => _GarmentScreenState();
}

class _GarmentScreenState extends State<GarmentScreen> {
  File? _imagenSeleccionada;
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
    final wardrobeProvider = context.watch<WardrobeProvider>();

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 15),
            GestureDetector(
              onTap: () => _capturarFoto(wardrobeProvider),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFF9891a2).withValues(alpha: 0.12),
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: _imagenSeleccionada == null
                          ? Opacity(
                              opacity: 0.5,
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
                          child: Icon(
                            Icons.camera_alt,
                            size: 30,
                            color: const Color(0xFFcabb97),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_imagenSeleccionada != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  "¡Imagen capturada!",
                  style: TextStyle(color: Colors.greenAccent[100]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
