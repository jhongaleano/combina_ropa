import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models_api.dart';

class MusicService {
  static const String _baseUrl = 'https://fakestoreapi.com/products';

  Future<List<Producto>> getProducto() async {

    final url = Uri.parse('$_baseUrl?}');

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
      throw 'No se pudo conectar con la API, error: $e';
    }
  }
}
