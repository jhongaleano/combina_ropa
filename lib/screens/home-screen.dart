import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models_api.dart'; 
import '../service/service.dart';
import '../providers/category_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  final ProductService _apiService = ProductService();

  void _mostrarAgregarCategoriaDialogo(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2636),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Nueva Categoría",
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Ej: Ropa de Invierno",
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
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
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purpleAccent,
            ),
            onPressed: () {
              if (controller.text.isNotEmpty) {

                context.read<CategoryProvider>().agregarCategoria(controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoriasDinamicas = context.watch<CategoryProvider>().categoria;
    return Scaffold(
      backgroundColor: const Color(0xFF1E1B24),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Outfit Reciente",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            FutureBuilder<List<Producto>>(
              future: _apiService.getProductos(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error: ${snapshot.error}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No hay datos disponibles"));
                }

                final producto = snapshot.data!.first;

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D2636),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple,
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            producto.image,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        producto.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "\$${producto.price}",
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 35),

            const Text(
              "Categorias",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.5,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: categoriasDinamicas.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D2636),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color(0xFF4c4056),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     const Icon(
                        Icons.label_important_outline,
                        color: Colors.orangeAccent,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        categoriasDinamicas[index],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            
            const SizedBox(height: 20),
            
            TextButton(
              onPressed: () => _mostrarAgregarCategoriaDialogo(context),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.purpleAccent),
                  SizedBox(width: 5),
                  Text(
                    "Agrega una nueva categoria",
                    style: TextStyle(color: Colors.purpleAccent),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}