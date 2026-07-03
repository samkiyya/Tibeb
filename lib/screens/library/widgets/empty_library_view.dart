import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme.dart';


class EmptyLibraryView extends ConsumerWidget {
  final VoidCallback onImportFiles;

  const EmptyLibraryView({super.key, required this.onImportFiles});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tibpiColors;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.library_books,
            size: 64,
            color: t.textSecondary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Your library is empty',
            style: TextStyle(color: t.textPrimary),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onImportFiles,
            style: ElevatedButton.styleFrom(
              backgroundColor: t.primary,
              foregroundColor: t.textOnPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: TibebRadius.borderLg,
              ),
            ),
            icon: const Icon(Icons.add),
            label: const Text(
              'Add Books',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
