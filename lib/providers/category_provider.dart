import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryProvider extends ChangeNotifier {
  List<String> _categoria = ['Camisa', 'Pantalon', 'Zapatos'];

  List<String> get categoria => _categoria;

  CategoryProvider() {
    _cargarCategoriaDesdoDisco();
  }

  void agregarCategoria(String nombre) async {
    final nombreLimpio = nombre.trim();
    if (nombreLimpio.isNotEmpty &&
        !_categoria.any((c) => c.toLowerCase() == nombreLimpio.toLowerCase())) {
      _categoria.add(nombreLimpio);
      _guardarCategoriaEnDisco();
      notifyListeners();
    }
  }

  void _guardarCategoriaEnDisco() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('categories_data', _categoria);
  }

  void _cargarCategoriaDesdoDisco() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? data  = prefs.getStringList('categories_data');
    if (data != null) {
      _categoria = data;
      notifyListeners();
    }
  }
}
