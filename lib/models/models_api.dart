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
  String firstImage = 'https://via.placeholder.com/150';

  if (imagesList.isNotEmpty) {
    // 2. Limpiamos la URL de corchetes, comillas y espacios extras
    firstImage = imagesList[0].toString()
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll('"', '');
  }

  return Producto(
    id: map['id'].toString(),
    title: map['title'] ?? 'Sin título',
    price: (map['price'] as num?)?.toDouble() ?? 0.0,
    description: map['description'] ?? 'Sin descripción',
    category: map['category'] != null ? map['category']['name'].toString() : 'Sin categoría',
    image: firstImage, // Ya está limpia para Image.network
  );
}

  // factory Producto.fromMap(Map<String, dynamic> map) => Producto(
  //   id: '${map['id'] ?? ''}',
  //   title: (map['title']) ?? ' ',
  //   price: (map['price'] ?? 0.0).toDouble(),
  //   description: (map['description']) ?? ' ',
  //   category: (map['category']) ?? 'Unknown',
  //   image: (map['image']) ?? 'https://via.placeholder.com/150',
  // );
}
