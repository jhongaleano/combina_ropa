import 'dart:async';
import 'dart:math';
import 'dart:io';

import '../models/models_camera.dart';
import '../providers/Wardrobe_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';

class OutfitWidget extends StatefulWidget {
  const OutfitWidget({super.key});

  @override
  State<OutfitWidget> createState() => _OutfitWidgetState();
}

class _OutfitWidgetState extends State<OutfitWidget> {
  final Random _random = Random();
  StreamSubscription<AccelerometerEvent>? _accelSub;
  
  WardrobeProvider? _wardrobeProvider;

  ModelsCamera? _current;
  

  DateTime _lastShake = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void initState() {
    super.initState();
    _startShakeDetection();
  }

 @override
 void didChangeDependencies() {
  super.didChangeDependencies();
  final wardrobe = context.read<WardrobeProvider>();
  if(_wardrobeProvider != wardrobe) {
    _wardrobeProvider?.removeListener(_onWardrobeChanged);
    _wardrobeProvider = wardrobe;
    wardrobe.addListener(_onWardrobeChanged);
    _onWardrobeChanged();
 }
}

void _onWardrobeChanged() {
  if(!mounted) return;
  final wardrobe = _wardrobeProvider?.prendas ?? [];
  if(wardrobe.isEmpty) {
   setState(()=> _current = null);
   return;
  }

  final stillValid = _current != null && wardrobe.any((p) => p.id == _current?.id);
  if(!stillValid) {
    setState(()=> _current = wardrobe[_random.nextInt(wardrobe.length)]);
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
    final outfits = context.read<WardrobeProvider>().prendas;
    if (outfits.isEmpty) return;
    if(!mounted) return;

    setState(() {
      ModelsCamera next;
      do {
        next = outfits[_random.nextInt(outfits.length)];
      } while (outfits.length > 1 && next.id == _current?.id);

      _current = next;
    });
  }

  void _openDetail(BuildContext context) {
    if (_current == null) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => OutfitDetailSheet(prenda: _current!),
    );
  }

  static ImageProvider _imageProvider(String path) {
    if(path.startsWith('http://') || path.startsWith('https://')) {
     return NetworkImage(path);
    }
    return FileImage(File(path));
  }

  @override
  void dispose() {
    _wardrobeProvider?.removeListener(_onWardrobeChanged);
    _accelSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<WardrobeProvider>();
    final outfits = context.read<WardrobeProvider>().prendas;
    if (outfits.isEmpty) {
      return _buildContainer(child: const Text('Agrega prendas a tu armario'));
    }

    final prenda = _current!;
    final titulo = prenda.name.trim().isEmpty ? 'Sin titulo' : prenda.name;
    final categoria = prenda.category.trim().isEmpty
        ? 'Tu armario'
        : prenda.category;

    return _buildContainer(
      child: Row(
        children: [
          Hero(
            tag: 'outfit_tag_${prenda.id}',
            child: CircleAvatar(
              radius: 35,
              backgroundColor: Colors.white,
              backgroundImage: _imageProvider(prenda.image),
              onBackgroundImageError: (_, __) {},
              child: prenda.image.isEmpty
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
  final ModelsCamera prenda;

  const OutfitDetailSheet({super.key, required this.prenda});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Hero(
              tag: 'outfit_tag_${prenda.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  File(prenda.image),
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
              prenda.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              prenda.category,
              style: const TextStyle(
                color: Color(0xFFFF708D),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      );
  }
}