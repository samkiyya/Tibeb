import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme.dart';
import '../../providers/settings_provider.dart';

class AboutSection extends ConsumerWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tibpiColors;

    return Center(
      child: Column(
        children: [
          FutureBuilder<String>(
            future: ref.read(settingsProvider.notifier).getAppVersion(),
            builder: (context, snapshot) {
              final version = snapshot.data ?? '...';
              return Text(
                'tibeb $version',
                style: TextStyle(
                  color: t.textSecondary.withValues(alpha: 0.5),
                  fontSize: 12,
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          Text(
            'Made with ❤️ by Samuel',
            style: TextStyle(
              color: t.textTertiary.withValues(alpha: 0.5),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}