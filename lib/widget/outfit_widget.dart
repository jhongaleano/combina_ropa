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
  List<ModelsCamera> _picksporcategoria = [];
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
    if (_wardrobeProvider != wardrobe) {
      _wardrobeProvider?.removeListener(_onWardrobeChanged);
      _wardrobeProvider = wardrobe;
      wardrobe.addListener(_onWardrobeChanged);
      _onWardrobeChanged();
    }
  }

  List<ModelsCamera> _oneRamdomCategoria(List<ModelsCamera> prendas) {
    final Map<String, List<ModelsCamera>> categorias = {};
    for (final p in prendas) {
      final key = p.category.trim().isEmpty
          ? 'Sin categoria'
          : p.category.trim();
      categorias.putIfAbsent(key, () => []).add(p);
    }
    final List<ModelsCamera> picks = [];
    categorias.forEach((_, items) {
      picks.add(items[_random.nextInt(items.length)]);
    });
    return picks;
  }

  void _onWardrobeChanged() {
    if (!mounted) return;

    final wardrobe = _wardrobeProvider?.prendas ?? [];
    if (wardrobe.isEmpty) {
      setState(() {
        _current = null;
        _picksporcategoria = [];
      });
      return;
    }

    setState(() {
      _picksporcategoria = _oneRamdomCategoria(wardrobe);
      _current = _picksporcategoria[_random.nextInt(_picksporcategoria.length)];
    });
  }

  void _startShakeDetection() {
    const double shakeThreshold = 15.0;
    const int cooldownMs = 800;

    _accelSub = accelerometerEventStream().listen((event) {
      final magnitude = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );

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
    if (outfits.isEmpty || !mounted) return;

    setState(() {
      _picksporcategoria = _oneRamdomCategoria(outfits);
      _current = _picksporcategoria[_random.nextInt(_picksporcategoria.length)];
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
    if (path.startsWith('http://') || path.startsWith('https://')) {
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

    if (_picksporcategoria.isEmpty) {
      return _buildContainer(
        child: const Text(
          'Agrega prendas a tu armario',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return _buildContainer(
      child: SizedBox(
        height: 90,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _picksporcategoria.length,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            final prenda = _picksporcategoria[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _current = prenda;
                });
                _openDetail(context);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Hero(
                    tag: 'outfit_tag_${prenda.id}',
                    child: Container(
                    padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: const LinearGradient(
                          colors: [Colors.cyan, Colors.purple, Colors.orange],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(17),
                        child: Image(
                          image: _imageProvider(prenda.image),
                          height: 75,
                          width: 82,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 86,
                            width: 86,
                            color: Colors.white,
                            child: const Center(
                              child: Icon(
                                Icons.style,
                                size: 40,
                                color: Color(0xFF28283C),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    //),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    prenda.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8.2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
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
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
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
                    child: Icon(
                      Icons.style,
                      size: 80,
                      color: Color.fromARGB(255, 243, 243, 250),
                    ),
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
