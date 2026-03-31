import 'package:flutter/material.dart';

class OutfitWidget extends StatelessWidget {
  const OutfitWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1C1C2D),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Hero(
            tag: 'outfit_tag',
            child: CircleAvatar(
              radius: 35,
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.style, size: 40, color: Color(0xFF28283C)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Texto de prueba',
                  style: TextStyle(
                    color: Color(0xFFFF708D),
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.4,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Ropa Casual',
                  style: TextStyle(
                    color: Colors.white, // Blanco
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.open_in_full, size: 26),
                color: Color(0xFFC88CFF),
                onPressed: () {
                  _expandirOutfit(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void _expandirOutfit(BuildContext context) {
  final String tituloOutfit = 'Casual Chic';
  final List<String> itemOutfit = [
    'Sweater Beige',
    'Jeans Azules Clásicos',
    'Zapatos Marrones de Cuero',
    'Bolsa de Tela',
  ];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) =>
        PaginaDetalleOutfit(titulo: tituloOutfit, items: itemOutfit),
  );
}

class PaginaDetalleOutfit extends StatelessWidget {
  final String titulo;
  final List<String> items;

  const PaginaDetalleOutfit({
    Key? key,
    required this.titulo,
    required this.items,
    // this.imagenAssetName = 'assets/outfit_placeholder.png', // Default
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Hero(
              tag: 'outfit_tag',
              child: Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(child: Icon(Icons.style, size: 100)),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Detalles outfit',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...items.map(
              (item) => Card(
                color: Color(0xFF28283C),
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(
                    Icons.check_circle,
                    color: Color(0xFFC88CFF),
                  ),
                  title: Text(item, style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
