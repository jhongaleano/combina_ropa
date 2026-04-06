import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models_api.dart';

class ProductService {
  static const String _baseUrl = 'https://fakestoreapi.com/products';

//   Future<List<Producto>> getProductos() async {
//   final url = Uri.parse(_baseUrl);

//   try {
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);

//       return data.map((item) => Producto.fromMap(item)).toList();
//     } else {
//       throw 'Error HTTP: ${response.statusCode}';
//     }
//   } catch (e) {
//     throw 'Error al cargar productos: $e';
//   }
// }

  Future<List<Producto>> getProductos() async {
    final url = Uri.parse(_baseUrl);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        return data.map((item) {
          return Producto(

            id: item['id'].toString(), 
            title: item['title'] ?? 'Sin título',
            price: (item['price'] as  num?)?.toDouble() ?? 3.4,
            description: item['description'] ?? 'Sin descripcion',
            category: item['category'] ?? 'Sin categoria',
            
            image: item['image'] ?? 'https://via.placeholder.com/150',
          );
        }).toList();
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