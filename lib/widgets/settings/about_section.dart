import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme.dart';
import '../../providers/settings_provider.dart';
import '../../l10n/app_localizations.dart';

class AboutSection extends ConsumerWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tibpiColors;
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        children: [
          FutureBuilder<String>(
            future: ref.read(settingsProvider.notifier).getAppVersion(),
            builder: (context, snapshot) {
              final version = snapshot.data ?? '...';
              return Text(
                '${l10n.appName} $version',
                style: TextStyle(
                  color: t.textSecondary.withValues(alpha: 0.6),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          Text(
            l10n.madeWithLove,
            style: TextStyle(
              color: t.textTertiary.withValues(alpha: 0.6),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}