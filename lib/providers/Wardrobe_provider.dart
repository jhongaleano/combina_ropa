import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../models/models_camera.dart';
import 'package:vibration/vibration.dart';

class WardrobeProvider extends ChangeNotifier {
  List<ModelsCamera> _prendas = [];
  final ImagePicker _picker = ImagePicker();

  List<ModelsCamera> get prendas => _prendas;

  List<ModelsCamera> get prendasFavoritas =>
      _prendas.where((item) => item.isFavorite).toList();

  WardrobeProvider() {
    _cargarPrendasDisco();
  }

  Future<File?> prendaImagen() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 60,
    );
    if (photo != null) {
      return File(photo.path);
    }
    return null;
  }

  void agregarPrenda({
    required String name,
    required String category,
    required String imagePath,
  }) {
    final newPrenda = ModelsCamera(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      category: category,
      image: imagePath,
      isFavorite: false,
    );
    print("Prenda Creada: ${newPrenda.name} en ${newPrenda.category}");
    print("Ruta de imagen: ${newPrenda.image}");
    _prendas.add(newPrenda);
    _guardarPrendasEnDisco(); 
    notifyListeners();
  }

  void toggleFavorite(String id) async {
    final index = _prendas.indexWhere((item) => item.id == id);
    if (index != -1) {
      _prendas[index].isFavorite = !_prendas[index].isFavorite;
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 100, amplitude: 500);
      }
      _guardarPrendasEnDisco();
      notifyListeners();
    }
  }

  void eliminarPrenda(String id) async {
    _prendas.removeWhere((item) => item.id == id);
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 100, amplitude: 255);
    }
    _guardarPrendasEnDisco();
    notifyListeners();
  }

  void _guardarPrendasEnDisco() async {
    final prefs = await SharedPreferences.getInstance();
    final String data = json.encode(_prendas.map((t) => t.toMap()).toList());
    await prefs.setString('armario_data', data);
  }

  void _cargarPrendasDisco() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('armario_data');
    if (data != null) {
      final List decoded = json.decode(data);
      _prendas = decoded.map((item) => ModelsCamera.fromMap(item)).toList();
      notifyListeners();
    }
  }
}
