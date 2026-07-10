import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tibeb/core/theme/system/color_scheme.dart';
import 'package:tibeb/l10n/app_localizations.dart';
import 'package:tibeb/screens/audiobook_player_screen.dart';

class AudiobookFab extends ConsumerStatefulWidget {
  final GlobalKey? tutorialKey;
  final VoidCallback? onPressed;

  const AudiobookFab({super.key, this.tutorialKey, this.onPressed});

  @override
  ConsumerState<AudiobookFab> createState() => _AudiobookFabState();
}

class _AudiobookFabState extends ConsumerState<AudiobookFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _scale = Tween<double>(
      begin: 1.0,
      end: 1.06,
    ).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;

    return ScaleTransition(
      scale: _scale,
      child: FloatingActionButton(
        key: widget.tutorialKey,
        heroTag: 'audiobook_import_fab',
        onPressed: widget.onPressed ?? () => AudiobookImportSheet.show(context),
        backgroundColor: t.primary,
        elevation: 8,
        tooltip: AppLocalizations.of(context)!.importFab,
        shape: const CircleBorder(),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [t.primary, t.primary.withValues(alpha: 0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: t.primary.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.headphones_rounded,
            color: Colors.white,
            size: 26,
          ),
        ),
      ),
    );
  }
}
