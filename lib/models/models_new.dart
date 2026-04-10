class Producto {
  final String id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;

  Producto({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'price': price,
    'description': description,
    'category': category,
    'image': image,
  };

  factory Producto.fromMap(Map<String, dynamic> map) {
  // 1. Obtenemos la lista de imágenes
  final List<dynamic> imagesList = map['images'] ?? [];


 

  return Producto(
    id: map['id'].toString(),
    title: map['title'] ?? 'Sin título',
    price: (map['price'] as num?)?.toDouble() ?? 0.0,
    description: map['description'] ?? 'Sin descripción',
    category: map['category'] != null ? map['category']['name'].toString() : 'Sin categoría',
    image: map['category']['image'], // Ya está limpia para Image.network
  );

}




}