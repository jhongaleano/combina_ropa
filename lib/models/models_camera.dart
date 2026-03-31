class ModelsCamera {
  final String id;
  final String name;
  final String category;
  final String image;
  bool isFavorite;

  ModelsCamera({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    this.isFavorite = false,
  });



  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'category': category,
    'image': image,
    'isFavorite': isFavorite,
  };

  factory ModelsCamera.fromMap(Map<String, dynamic> map) => ModelsCamera(
    id: map['id'],
    name: map['name'],
    category: map['category'],
    image: map['image'],
    isFavorite: map['isFavorite'],
  );

}