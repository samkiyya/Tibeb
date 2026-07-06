import 'package:flutter/material.dart';
import 'package:tibeb/core/theme/theme.dart';

class BookSelectionOverlay extends StatelessWidget {
  final bool isSelected;

  const BookSelectionOverlay({
    super.key,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;

    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? t.primary.withValues(alpha: 0.3)
              : t.scrim.withValues(alpha: 0.26),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? t.primary
                  : t.glassBorder.withValues(alpha: 0.24),
              border: Border.all(color: t.textOnAccent, width: 2),
            ),
            child: Icon(
              isSelected ? Icons.check : Icons.add,
              size: 20,
              color: isSelected
                  ? t.textOnPrimary
                  : t.textOnAccent,
            ),
          ),
        ),
      ),
    );
  }
}