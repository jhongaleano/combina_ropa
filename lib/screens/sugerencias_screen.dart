import 'package:flutter/material.dart';
import '../models/models_new.dart';
import '../service/service.dart';

class SuggestionsScreen extends StatefulWidget {
  const SuggestionsScreen({super.key});

  @override
  State<SuggestionsScreen> createState() => _SuggestionsScreenState();
}

class _SuggestionsScreenState extends State<SuggestionsScreen> {
  final ProductService _service = ProductService();
  late Future<List<Producto>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.getProductos();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _service.getProductos();
    });
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E142D),
      body: RefreshIndicator(
        color: const Color(0xFFC88CFF),
        onRefresh: _refresh,
        child: FutureBuilder<List<Producto>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFC88CFF)),
              );
            }

            if (snapshot.hasError) {
              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    'No se pudieron cargar sugerencias',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFC88CFF),
                      foregroundColor: const Color(0xFF1E142D),
                    ),
                    onPressed: _refresh,
                    child: const Text('Reintentar'),
                  ),
                ],
              );
            }

            final productos = snapshot.data ?? const <Producto>[];
            if (productos.isEmpty) {
              return ListView(
                padding: const EdgeInsets.all(20),
                children: const [
                  SizedBox(height: 40),
                  Text(
                    'No hay productos para sugerir.',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              );
            }

            final Map<String, List<Producto>> byCategory = {};
            for (final p in productos) {
              final cat = p.category.trim().isEmpty
                  ? 'Sin categoría'
                  : p.category;
              byCategory.putIfAbsent(cat, () => []).add(p);
            }

            final categories = byCategory.keys.toList()..sort();

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const Text(
                  'Sugerencias',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Prendas traídas desde la API, agrupadas por categoría.',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 16),
                ...categories.map((cat) {
                  final items = byCategory[cat]!;
                  return _CategorySection(title: cat, items: items);
                }),
                const SizedBox(height: 90),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  final String title;
  final List<Producto> items;

  const _CategorySection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFF708D),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 250,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return _ApiProductCard(producto: items[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ApiProductCard extends StatelessWidget {
  final Producto producto;

  const _ApiProductCard({required this.producto});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: const Color(0xFF2D2636),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF4c4056), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _openDetails(context, producto),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  producto.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.white,
                    child: const Center(
                      child: Icon(
                        Icons.style,
                        size: 48,
                        color: Color(0xFF28283C),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    producto.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFC88CFF,
                          ).withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: const Color(
                              0xFFC88CFF,
                            ).withValues(alpha: 0.35),
                          ),
                        ),
                        child: Text(
                          '\$${producto.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Color(0xFFC88CFF),
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.auto_awesome,
                        size: 18,
                        color: Color(0xFFFBE4AD),
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

  void _openDetails(BuildContext context, Producto producto) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _ProductDetailSheet(producto: producto),
    );
  }
}

class _ProductDetailSheet extends StatelessWidget {
  final Producto producto;

  const _ProductDetailSheet({required this.producto});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C2D),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF4c4056)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  producto.image,
                  height: 260,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 260,
                    color: Colors.white,
                    child: const Center(
                      child: Icon(
                        Icons.style,
                        size: 80,
                        color: Color(0xFF28283C),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                producto.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.label_important_outline,
                    size: 18,
                    color: Color(0xFFFF708D),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      producto.category,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                  Text(
                    '\$${producto.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Color(0xFFC88CFF),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                producto.description,
                style: const TextStyle(color: Colors.white70, height: 1.35),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
