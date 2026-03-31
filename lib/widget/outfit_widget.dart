import 'dart:async';
import 'dart:math';

import 'package:combina_ropa/models/models_api.dart';
import 'package:combina_ropa/service/service.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class OutfitWidget extends StatefulWidget {
  const OutfitWidget({super.key});

  @override
  State<OutfitWidget> createState() => _OutfitWidgetState();
}

class _OutfitWidgetState extends State<OutfitWidget> {
  final Random _random = Random();
  StreamSubscription<AccelerometerEvent>? _accelSub;

  List<Producto> _outfits = [];
  Producto? _current;
  bool _loading = true;
  String? _error;

  DateTime _lastShake = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void initState() {
    super.initState();
    _loadOutfits();
    _startShakeDetection();
  }

  Future<void> _loadOutfits() async {
    try {
      final data = await MusicService().getProducto();
      if (!mounted) return;

      setState(() {
        _outfits = data;
        _current = _outfits.isNotEmpty
            ? _outfits[_random.nextInt(_outfits.length)]
            : null;
        _loading = false;
        _error = _outfits.isEmpty ? 'No se encontraron outfits.' : null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'No se pudo cargar la API: $e';
      });
    }
  }

  void _startShakeDetection() {
    const double shakeThreshold = 15.0;
    const int cooldownMs = 800;

    _accelSub = accelerometerEventStream().listen((event) {
      final magnitude =
          sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

      final now = DateTime.now();
      final enoughTimePassed =
          now.difference(_lastShake).inMilliseconds > cooldownMs;

      if (magnitude > shakeThreshold && enoughTimePassed) {
        _lastShake = now;
        _changeOutfitRandom();
      }
    });
  }

  void _changeOutfitRandom() {
    if (_outfits.isEmpty) return;

    setState(() {
      Producto next;
      do {
        next = _outfits[_random.nextInt(_outfits.length)];
      } while (_outfits.length > 1 && next.id == _current?.id);

      _current = next;
    });
  }

  void _openDetail(BuildContext context) {
    if (_current == null) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => OutfitDetailSheet(producto: _current!),
    );
  }

  @override
  void dispose() {
    _accelSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return _buildContainer(
        child: const Center(
          child: SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (_error != null) {
      return _buildContainer(
        child: Text(
          _error!,
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      );
    }

    final producto = _current!;
    final titulo = producto.title.trim().isEmpty ? 'Sin titulo' : producto.title;
    final categoria = producto.category.trim().isEmpty
        ? 'Sugerencia actual'
        : producto.category;

    return _buildContainer(
      child: Row(
        children: [
          Hero(
            tag: 'outfit_tag_${producto.id}',
            child: CircleAvatar(
              radius: 35,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(producto.image),
              onBackgroundImageError: (_, __) {},
              child: producto.image.isEmpty
                  ? const Icon(Icons.style, size: 36, color: Color(0xFF28283C))
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  categoria,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFFF708D),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  titulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.casino, size: 24),
            color: const Color(0xFFC88CFF),
            tooltip: 'Cambiar outfit',
            onPressed: _changeOutfitRandom,
          ),
          IconButton(
            icon: const Icon(Icons.open_in_full, size: 24),
            color: const Color(0xFFC88CFF),
            tooltip: 'Ver detalle',
            onPressed: () => _openDetail(context),
          ),
        ],
      ),
    );
  }

  Widget _buildContainer({required Widget child}) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C2D),
        borderRadius: BorderRadius.circular(24),
      ),
      child: child,
    );
  }
}

class OutfitDetailSheet extends StatelessWidget {
  final Producto producto;

  const OutfitDetailSheet({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C2D),
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'outfit_tag_${producto.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  producto.image,
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 240,
                    color: Colors.white,
                    child: const Center(
                      child: Icon(Icons.style, size: 80, color: Color(0xFF28283C)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              producto.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              producto.category,
              style: const TextStyle(
                color: Color(0xFFFF708D),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '\$${producto.price.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Color(0xFFC88CFF),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              producto.description,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}