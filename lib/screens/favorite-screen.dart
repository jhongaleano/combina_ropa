import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models_camera.dart';
import '../providers/Wardrobe_provider.dart';
class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});
  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}
class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {

      final wardrobeProvider = Provider.of<WardrobeProvider>(context);

      final listaFavoritos = wardrobeProvider.prendasFavoritas;

      return Scaffold(
        backgroundColor: const Color(0xFF1B1721), 
        body: listaFavoritos.isEmpty 
          ? const Center(
              child: Text(
                "No tienes favoritos aun", 
                style: TextStyle(color: Colors.white54)
              )
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: listaFavoritos.length,
              itemBuilder: (context, index) {

                final prenda = listaFavoritos[index];

                return _buildFavoriteCard(prenda);
              },
            ),
      );
    }

    Widget _buildFavoriteCard(ModelsCamera prenda) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(3), 
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF22D3EE),
            Color.fromRGBO(200, 140, 255, 1),
          ],
        ),
      ),

      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2E2735),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: Image.file(
                    File(prenda.image),
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(125, 248, 226, 209),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.favorite, 
                        color:Color(0xFFFB923C), 
                        size: 28, 
                      ),
                      onPressed: () {
                        context.read<WardrobeProvider>().toggleFavorite(prenda.id);
                      },
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        prenda.name.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          letterSpacing: 1.2,
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          prenda.category,
                          style: const TextStyle(
                            color: Color(0xFFFB923C), 
                            fontSize: 18,
                            fontWeight: FontWeight(8)
                          ),
                        ),
                      ),
                    ],
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