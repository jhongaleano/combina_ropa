import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models_api.dart';

class ProductService {
  static const String _baseUrl = 'https://fakestoreapi.com/products';

  Future<List<Producto>> getProductos() async {
    final url = Uri.parse(_baseUrl);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> decodedData = json.decode(response.body);

        return decodedData.map((item) => Producto.fromMap(item)).toList();
      } else {
        throw 'Error en la respuesta del servidor: ${response.statusCode}';
      }
    } catch (e) {
      throw 'No se pudo conectar con la API de StyleStack: $e';
    }
  }

  Future<Producto> getSugerenciaAleatoria() async {
    final productos = await getProductos();
    productos.shuffle(); // desordenar la lista
    return productos.first; // retornar el primero
  }
}