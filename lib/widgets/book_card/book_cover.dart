import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Renders a book cover from a file path (local or network).
/// Falls back to a [SemanticCover] (gradient + title text) when no image is
/// available, or to a bare icon as a last resort.
class BookCover extends StatelessWidget {
  final String path;
  final BoxFit fit;
  final Color placeholderColor;
  final String? title;
  final String? author;

  /// Optional file extension (e.g. 'md', 'txt') used to choose a
  /// format-specific semantic cover when no image cover is available.
  final String? fileExtension;

  const BookCover({
    super.key,
    required this.path,
    required this.placeholderColor,
    this.fit = BoxFit.cover,
    this.title,
    this.author,
    this.fileExtension,
  });

  @override
  Widget build(BuildContext context) {
    final isNetwork = path.startsWith('http');

    if (isNetwork) {
      return CachedNetworkImage(
        imageUrl: path,
        fit: fit,
        placeholder: (_, _) => Container(color: placeholderColor),
        errorWidget: (_, _, _) => _smartFallback(),
      );
    }

    if (path.isNotEmpty) {
      return Image.file(
        File(path),
        fit: fit,
        errorBuilder: (_, _, _) => _smartFallback(),
      );
    }

    return _smartFallback();
  }

  Widget _smartFallback() {
    if (title != null && title!.isNotEmpty) {
      return SemanticCover(
        title: title!,
        author: author ?? '',
        fileExtension: fileExtension,
        fit: fit,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Image.asset('assets/icon.png', fit: BoxFit.contain),
    );
  }
}

/// A gradient cover card that renders when no image cover exists.
/// Shows the book title, author, optional format badge and a Ge'ez watermark.
class SemanticCover extends StatelessWidget {
  final String title;
  final String author;
  final BoxFit fit;

  /// Optional file extension (e.g. 'md', 'txt') for palette + badge selection.
  final String? fileExtension;

  const SemanticCover({
    super.key,
    required this.title,
    required this.author,
    this.fit = BoxFit.cover,
    this.fileExtension,
  });

  static const _mdGradients = [
    [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
    [Color(0xFF000428), Color(0xFF004e92)],
  ];
  static const _txtGradients = [
    [Color(0xFF2B2B2B), Color(0xFF434343)],
    [Color(0xFF1e130c), Color(0xFF9a8478)],
  ];
  static const _defaultGradients = [
    [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
    [Color(0xFF3A6073), Color(0xFF16222F)],
    [Color(0xFF114B5F), Color(0xFF1A936F)],
    [Color(0xFF451E3E), Color(0xFF851E3E), Color(0xFFFE9601)],
    [Color(0xFF1C1A27), Color(0xFF3A3845), Color(0xFF827397)],
    [Color(0xFF2B5876), Color(0xFF4E4376)],
    [Color(0xFF000428), Color(0xFF004e92)],
    [Color(0xFF1e130c), Color(0xFF9a8478)],
  ];

  @override
  Widget build(BuildContext context) {
    final ext = fileExtension?.toLowerCase().trim();

    final List<Color> grad;
    if (ext == 'md') {
      grad = _mdGradients[title.hashCode.abs() % _mdGradients.length];
    } else if (ext == 'txt') {
      grad = _txtGradients[title.hashCode.abs() % _txtGradients.length];
    } else {
      grad = _defaultGradients[title.hashCode.abs() % _defaultGradients.length];
    }

    final String? badgeLabel = ext == 'md'
        ? 'MD'
        : ext == 'txt'
        ? 'TXT'
        : null;
    final IconData? badgeIcon = ext == 'md'
        ? Icons.article_outlined
        : ext == 'txt'
        ? Icons.text_snippet_outlined
        : null;

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
          // Inner border frame
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.12),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          // Format badge (top-left) for .md / .txt
          if (badgeLabel != null && badgeIcon != null)
            Positioned(
              top: 6,
              left: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(badgeIcon, size: 9, color: Colors.white70),
                    const SizedBox(width: 3),
                    Text(
                      badgeLabel,
                      style: const TextStyle(
                        fontSize: 7,
                        fontWeight: FontWeight.w800,
                        color: Colors.white70,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
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
              Container(
                width: 16,
                height: 1,
                color: Colors.white.withValues(alpha: 0.35),
              ),
              const SizedBox(height: 6),
              if (author.isNotEmpty)
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
              // Ge'ez watermark
              Text(
                'ጥበብ',
                style: TextStyle(
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
