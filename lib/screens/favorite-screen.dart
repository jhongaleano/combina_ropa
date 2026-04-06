import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models_api.dart';
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
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2636),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.purpleAccent),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.file(
                    File(prenda.image), 
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: const Icon(Icons.favorite, color: Colors.purpleAccent, size: 35),
                onPressed: () {
                  context.read<WardrobeProvider>().toggleFavorite(prenda.id);
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            prenda.name,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}