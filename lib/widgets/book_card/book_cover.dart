import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BookCover extends StatelessWidget {
  final String path;
  final BoxFit fit;
  final Color placeholderColor;

  const BookCover({
    super.key,
    required this.path,
    required this.placeholderColor,
    this.fit = BoxFit.cover,
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

    return _fallback();
  }

  Widget _fallback() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Image.asset('assets/icon.png', fit: BoxFit.contain),
    );
  }
}