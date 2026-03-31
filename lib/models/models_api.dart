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

  factory Producto.fromMap(Map<String, dynamic> map) => Producto(
    id: '${map['id'] ?? ''}',
    title: (map['title']) ?? ' ',
    price: (map['price'] as num?)?.toDouble() ?? 0.0,
    description: (map['description']) ?? ' ',
    category: (map['category']) ?? 'Unknown',
    image: (map['image']) ?? 'https://via.placeholder.com/150',
  );
}
