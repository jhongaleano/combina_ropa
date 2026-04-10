import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';
import '../providers/Wardrobe_provider.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {

  void _mostrarAgregarCategoriaDialogo(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2636),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Nueva Categoría",
          style: TextStyle(
            color: Color(0xFF00BCD5),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Ej: Ropa de Invierno",
            hintStyle: TextStyle(color: Colors.white),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.purpleAccent),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancelar",
              style: TextStyle(color: Color(0xFFF0DBFF)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(200, 140, 255, 1),
            ),
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<CategoryProvider>().agregarCategoria(
                  controller.text,
                );
                Navigator.pop(context);
              }
            },
            child: const Text(
              "Guardar",
              style: TextStyle(
                color: Color(0xFF62259B),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoriasDinamicas = context.watch<CategoryProvider>().categoria;
    return Scaffold(
      backgroundColor: const Color(0xFF141123),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Categorias",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            TextButton(
              onPressed: () => _mostrarAgregarCategoriaDialogo(context),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.purpleAccent),
                  SizedBox(width: 5),
                  Text(
                    "Agrega una nueva categoria",
                    style: TextStyle(
                      color: Colors.purpleAccent,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15,),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categoriasDinamicas.length,
              itemBuilder: (context, index) {
                final categoriaNombre = categoriasDinamicas[index];

                final prendasDeCategoria = context.watch<WardrobeProvider>().prendas.where((p) => p.category == categoriaNombre).toList();

                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D2636),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color(0xFF22D3EE),
                      width: 2,
                    ),
                  ),
                  child: ExpansionTile(
                    childrenPadding: EdgeInsets.all(20),
                    leading: const Icon(
                      Icons.checkroom,
                      color: Colors.orangeAccent,
                    ),
                    trailing: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white70,
                    ),
                    title: Text(
                      categoriaNombre,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Text(
                      "${prendasDeCategoria.length} ${prendasDeCategoria.length == 1 ? 'prenda disponible' : 'prendas disponibles'}",
                      style: TextStyle(
                        color: Colors.white70
                      ),
                    ),
                    children: [
                      if (prendasDeCategoria.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            "No hay fotos en esta categoría",
                            style: TextStyle(color: Colors.white54),
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: prendasDeCategoria.map((prenda) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(87, 82, 92, 1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.file(
                                        File(prenda.image),
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 15),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:CrossAxisAlignment.start,
                                        mainAxisAlignment:MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            prenda.name,
                                            style: const TextStyle(
                                              color:Color.fromARGB(255, 255, 255, 255),
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 10),
                                          Align(
                                            child: Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    context.read<WardrobeProvider>().toggleFavorite(prenda.id,);
                                                  },
                                                  child: Container(
                                                    padding:const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: const Color.fromARGB(255, 84, 0, 0),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Icon(
                                                      prenda.isFavorite
                                                          ? Icons.favorite
                                                          : Icons.favorite_border,
                                                      color: prenda.isFavorite
                                                          ? const Color.fromARGB(255, 251, 251, 251)
                                                          : Colors.white70,
                                                      size: 24,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 15,),
                                                InkWell(
                                                  onTap: () {
                                                    context.read<WardrobeProvider>().eliminarPrenda(prenda.id,);
                                                  },
                                                  child: Container(
                                                    padding:const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color:  const Color.fromARGB(255, 84, 0, 0),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Icon(
                                                      Icons.delete,
                                                      size: 24,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(), // convertir el mapa de prendas en una lista de widgets
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
