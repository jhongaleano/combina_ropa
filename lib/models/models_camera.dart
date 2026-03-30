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



  Map<String,dynamic>tojson()=>{
    'id':id,
    'name':name,
    'category':category,
    'image':image,
    'isFavorite':isFavorite
  };

  factory ModelsCamera.fromJson(Map<String,dynamic>
  json)=>ModelsCamera(
    id: json['id'],
    name: json['name'],
    category: json['category'],
    image: json['image'],
    isFavorite: json['isFavorite']
  );

}