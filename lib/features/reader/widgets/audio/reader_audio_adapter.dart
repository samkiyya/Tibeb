// features/reader/widgets/audio/reader_audio_adapter.dart
//
// Bridges AudioPlayerState (from AudioNotifier) into the ValueNotifier-based
// ReadingAudioSection widget API — no changes needed to the existing widget.

import 'package:flutter/material.dart';
import 'package:tibeb/features/reader/providers/reader_provider.dart';
import 'package:tibeb/shared/models/models.dart';
import '../../../../widgets/reading/reading_audio_section.dart';

class ReaderAudioAdapter extends StatefulWidget {
  final ReaderSettings settings;
  final AudioPlayerState audioState;
  final List<AudioTrack> audioTracks;
  final void Function(Duration) onSeekEnd;
  final bool isOrientationLandscape;

  const ReaderAudioAdapter({
    super.key,
    required this.settings,
    required this.audioState,
    required this.audioTracks,
    required this.onSeekEnd,
    this.isOrientationLandscape = false,
  });

  @override
  State<ReaderAudioAdapter> createState() => _ReaderAudioAdapterState();
}

class _ReaderAudioAdapterState extends State<ReaderAudioAdapter> {
  late final ValueNotifier<Duration> _pos;
  late final ValueNotifier<Duration> _dur;
  late final ValueNotifier<int> _idx;
  bool _dragging = false;
  double _dragValue = 0;

  @override
  void initState() {
    super.initState();
    _pos = ValueNotifier(widget.audioState.position);
    _dur = ValueNotifier(widget.audioState.duration);
    _idx = ValueNotifier(widget.audioState.currentTrackIndex);
  }

  @override
  void didUpdateWidget(ReaderAudioAdapter old) {
    super.didUpdateWidget(old);
    if (!_dragging) _pos.value = widget.audioState.position;
    _dur.value = widget.audioState.duration;
    _idx.value = widget.audioState.currentTrackIndex;
  }

  @override
  void dispose() {
    _pos.dispose();
    _dur.dispose();
    _idx.dispose();
    super.dispose();
  }

  String _fmt(Duration d) {
    String pad(int n) => n.toString().padLeft(2, '0');
    final m = pad(d.inMinutes.remainder(60));
    final s = pad(d.inSeconds.remainder(60));
    return d.inHours > 0 ? '${pad(d.inHours)}:$m:$s' : '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return ReadingAudioSection(
      settings: widget.settings,
      isLoading: widget.audioState.isLoading,
      positionNotifier: _pos,
      durationNotifier: _dur,
      currentIndexNotifier: _idx,
      audioTracks: widget.audioTracks,
      isDraggingSlider: _dragging,
      sliderDragValue: _dragValue,
      onChangeStart: (v) => setState(() {
        _dragging = true;
        _dragValue = v;
      }),
      onChanged: (v) => setState(() {
        _dragValue = v;
        _pos.value = Duration(milliseconds: v.toInt());
      }),
      onChangeEnd: (v) {
        setState(() => _dragging = false);
        widget.onSeekEnd(Duration(milliseconds: v.toInt()));
      },
      formatDuration: _fmt,
      isOrientationLandscape: widget.isOrientationLandscape,
    );
  }
}
