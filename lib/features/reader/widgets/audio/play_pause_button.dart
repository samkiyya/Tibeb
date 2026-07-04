// features/reader/widgets/audio/play_pause_button.dart
//
// Clean replacement — accepts plain bool instead of ValueNotifier,
// matching the new provider-driven approach.

import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class PlayPauseButton extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onTap;

  const PlayPauseButton({
    super.key,
    required this.isPlaying,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: t.primary.withValues(alpha: 0.15),
          shape: BoxShape.circle,
          border: Border.all(
              color: t.primary.withValues(alpha: 0.4), width: 1.5),
        ),
        child: Icon(
          isPlaying
              ? Icons.pause_rounded
              : Icons.play_arrow_rounded,
          color: t.primary,
          size: 26,
        ),
      ),
    );
  }
}
