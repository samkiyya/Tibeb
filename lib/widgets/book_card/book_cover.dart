import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BookCover extends StatelessWidget {
  final String path;
  final BoxFit fit;
  final Color placeholderColor;
  final String? title;
  final String? author;

  const BookCover({
    super.key,
    required this.path,
    required this.placeholderColor,
    this.fit = BoxFit.cover,
    this.title,
    this.author,
  });

  @override
  Widget build(BuildContext context) {
    final isNetwork = path.startsWith('http');

    if (isNetwork) {
      return CachedNetworkImage(
        imageUrl: path,
        fit: fit,
        placeholder: (_, _) => Container(color: placeholderColor),
        errorWidget: (_, _, _) => _fallback(),
      );
    }

    if (path.isNotEmpty) {
      return Image.file(
        File(path),
        fit: fit,
        errorBuilder: (_, _, _) => _fallback(),
      );
    }

    if (title != null && title!.isNotEmpty) {
      return SemanticCover(
        title: title!,
        author: author ?? 'Unknown',
        fit: fit,
      );
    }

    return _fallback();
  }

  Widget _fallback() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Image.asset('assets/icon.png', fit: BoxFit.contain),
    );
  }
}

class SemanticCover extends StatelessWidget {
  final String title;
  final String author;
  final BoxFit fit;

  const SemanticCover({
    super.key,
    required this.title,
    required this.author,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    // Curated list of premium gradients
    final List<List<Color>> gradients = [
      [
        const Color(0xFF0F2027),
        const Color(0xFF203A43),
        const Color(0xFF2C5364),
      ], // Deep Space
      [const Color(0xFF3A6073), const Color(0xFF16222F)], // Slate Dusk
      [const Color(0xFF114B5F), const Color(0xFF1A936F)], // Emerald Teal
      [
        const Color(0xFF451E3E),
        const Color(0xFF851E3E),
        const Color(0xFFFE9601),
      ], // Warm Sun
      [
        const Color(0xFF1C1A27),
        const Color(0xFF3A3845),
        const Color(0xFF827397),
      ], // Royal Charcoal
      [const Color(0xFF2B5876), const Color(0xFF4E4376)], // Indigo Night
      [const Color(0xFF000428), const Color(0xFF004e92)], // Deep Velvet Blue
      [const Color(0xFF1e130c), const Color(0xFF9a8478)], // Muted Clay
    ];

    final int index = title.hashCode.abs() % gradients.length;
    final grad = gradients[index];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: grad,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Elegant layout borders
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.12),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              // Main title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Lexend',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.1,
                    height: 1.25,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              // Minimal separator line
              Container(
                width: 16,
                height: 1,
                color: Colors.white.withValues(alpha: 0.35),
              ),
              const SizedBox(height: 6),
              // Author
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  author.toUpperCase(),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.7),
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              const Spacer(flex: 3),
              // Ge'ez styling / Bottom brand mark
              Text(
                'ጥበብ', // "Tibeb" in Ge'ez
                style: TextStyle(
                  fontFamily: 'System',
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withValues(alpha: 0.25),
                  letterSpacing: 1.0,
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ],
      ),
    );
  }
}
