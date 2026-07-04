import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

/// Accepts either a plain [isPlaying] bool OR a [ValueNotifier<bool>].
/// Prefer the plain bool API for new code; the notifier API is kept for
/// the legacy reading_screen.dart path.
class PlayPauseButton extends StatelessWidget {
  final bool? isPlaying;
  final ValueNotifier<bool>? isPlayingNotifier;
  final VoidCallback onTap;

  const PlayPauseButton({
    super.key,
    this.isPlaying,
    this.isPlayingNotifier,
    required this.onTap,
  }) : assert(
          isPlaying != null || isPlayingNotifier != null,
          'Provide either isPlaying or isPlayingNotifier',
        );

  @override
  Widget build(BuildContext context) {
    if (isPlayingNotifier != null) {
      return ValueListenableBuilder<bool>(
        valueListenable: isPlayingNotifier!,
        builder: (context, playing, child) => _button(context, playing),
      );
    }
    return _button(context, isPlaying!);
  }

  Widget _button(BuildContext context, bool playing) {
    final t = context.tibpiColors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: t.accent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}
