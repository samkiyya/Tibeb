import 'package:flutter/material.dart';
import '../../../core/theme/semantics/color_scheme.dart';

class AddBookFab extends StatelessWidget {
  final VoidCallback onPressed;

  const AddBookFab({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;
    return FloatingActionButton(
      heroTag: 'fab-add',
      onPressed: onPressed,
      backgroundColor: t.primary,
      child: Icon(Icons.add, color: t.textOnPrimary, size: 28),
    );
  }
}
