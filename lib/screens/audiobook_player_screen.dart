import 'dart:io' as io;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../core/theme/theme.dart';
import '../models/book_model.dart';
import '../providers/library_provider.dart';
import '../providers/navigation_provider.dart';
import '../services/audio_metadata_parser.dart';

// ---------------------------------------------------------------------------
// AudioBook Model — pure audiobook entry with no EPUB/PDF dependency
// ---------------------------------------------------------------------------

/// Metadata extracted from an imported audio track list.
class AudiobookMeta {
  final String title;
  final String author;
  final String coverPath;
  final List<AudioTrack> tracks;

  const AudiobookMeta({
    required this.title,
    required this.author,
    required this.coverPath,
    required this.tracks,
  });
}

// ---------------------------------------------------------------------------
// AudiobookImportService — file picking + metadata extraction
// ---------------------------------------------------------------------------

class AudiobookImportService {
  static const _supported = ['mp3', 'mp4', 'm4a', 'aac', 'ogg', 'flac', 'wav', 'm4b'];

  /// Pick one or more audio files and return them as an [AudiobookMeta].
  /// Returns null if the user cancels.
  static Future<AudiobookMeta?> pickAndImport() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: _supported,
      allowMultiple: true,
    );

    if (result == null || result.files.isEmpty) return null;

    final files = result.files.where((f) => f.path != null).toList();
    if (files.isEmpty) return null;

    // Sort by filename so that Part01, Part02 … are in natural order.
    files.sort((a, b) => a.name.compareTo(b.name));

    final tracks = files
        .map((f) => AudioTrack(path: f.path!, title: _cleanTitle(f.name)))
        .toList();

    // Use the first file's parent folder name as the default title.
    final folderName = p.basenameWithoutExtension(
      p.dirname(files.first.path!),
    );
    final title = folderName.isNotEmpty ? folderName : 'Audiobook';

    return AudiobookMeta(
      title: title,
      author: 'Unknown',
      coverPath: '',
      tracks: tracks,
    );
  }

  /// Copy an audio file to the app documents directory so it remains
  /// accessible after the original is moved or the cache clears.
  static Future<String> copyToAppStorage(String sourcePath) async {
    final appDir = await getApplicationDocumentsDirectory();
    final audioDir = io.Directory(p.join(appDir.path, 'audiobooks'));
    if (!await audioDir.exists()) await audioDir.create(recursive: true);

    final fileName = p.basename(sourcePath);
    final dest = p.join(audioDir.path, fileName);
    if (!await io.File(dest).exists()) {
      await io.File(sourcePath).copy(dest);
    }
    return dest;
  }

  static String _cleanTitle(String fileName) {
    final name = p.basenameWithoutExtension(fileName);
    // Remove leading track numbers like "01 - ", "Track 1 " etc.
    return name.replaceFirst(RegExp(r'^[\d\s_-]+'), '').trim();
  }
}

// ---------------------------------------------------------------------------
// AudiobookImportSheet — bottom sheet UI for importing a pure audiobook
// ---------------------------------------------------------------------------

class AudiobookImportSheet extends ConsumerStatefulWidget {
  const AudiobookImportSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AudiobookImportSheet(),
    );
  }

  @override
  ConsumerState<AudiobookImportSheet> createState() =>
      _AudiobookImportSheetState();
}

class _AudiobookImportSheetState extends ConsumerState<AudiobookImportSheet> {
  AudiobookMeta? _meta;
  bool _isImporting = false;
  bool _isDone = false;
  String? _error;
  double _importProgress = 0;

  final _titleCtrl = TextEditingController();
  final _authorCtrl = TextEditingController();

  Uint8List? _extractedCoverBytes;
  String? _extractedCoverMime;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _authorCtrl.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    setState(() => _error = null);
    final meta = await AudiobookImportService.pickAndImport();
    if (meta == null) return;

    // Try to extract embedded metadata (title, author, cover) from the
    // first audio file — most audiobooks embed ID3v2 / MP4 ilst tags.
    String extractedTitle = meta.title;
    String extractedAuthor = meta.author;
    Uint8List? coverBytes;
    String? coverMime;

    for (final track in meta.tracks) {
      final parsed = await AudioMetadataParser.parseFile(track.path);
      if (parsed == null) continue;

      // Take the first non-null title / author we find
      if (parsed.title != null && parsed.title!.trim().isNotEmpty && extractedTitle == meta.title) {
        extractedTitle = parsed.title!.trim();
      }
      if (parsed.author != null && parsed.author!.trim().isNotEmpty && extractedAuthor == 'Unknown') {
        extractedAuthor = parsed.author!.trim();
      }
      if (parsed.coverBytes != null && parsed.coverBytes!.isNotEmpty && coverBytes == null) {
        coverBytes = parsed.coverBytes;
        coverMime = parsed.coverMime;
      }
      // Stop scanning once we have all three fields
      if (extractedTitle != meta.title && extractedAuthor != 'Unknown' && coverBytes != null) break;
    }

    setState(() {
      _meta = AudiobookMeta(
        title: extractedTitle,
        author: extractedAuthor,
        coverPath: meta.coverPath,
        tracks: meta.tracks,
      );
      _titleCtrl.text = extractedTitle;
      _authorCtrl.text = extractedAuthor;
      _extractedCoverBytes = coverBytes;
      _extractedCoverMime = coverMime;
    });
  }

  Future<void> _import() async {
    if (_meta == null) return;
    setState(() {
      _isImporting = true;
      _error = null;
      _importProgress = 0;
    });

    try {
      // Copy each track to app storage so the paths are stable.
      final copiedTracks = <AudioTrack>[];
      for (var i = 0; i < _meta!.tracks.length; i++) {
        final track = _meta!.tracks[i];
        final dest = await AudiobookImportService.copyToAppStorage(track.path);
        copiedTracks.add(AudioTrack(path: dest, title: track.title));
        setState(() => _importProgress = (i + 1) / _meta!.tracks.length);
      }

      // Save extracted cover art to disk if we have one
      String coverPath = '';
      if (_extractedCoverBytes != null && _extractedCoverBytes!.isNotEmpty) {
        final appDir = await getApplicationDocumentsDirectory();
        final coversDir = io.Directory(p.join(appDir.path, 'covers'));
        if (!await coversDir.exists()) await coversDir.create(recursive: true);
        final ext = (_extractedCoverMime == 'image/png') ? '.png' : '.jpg';
        final coverFile = io.File(
          p.join(coversDir.path, '${DateTime.now().millisecondsSinceEpoch}$ext'),
        );
        await coverFile.writeAsBytes(_extractedCoverBytes!);
        coverPath = coverFile.path;
      }

      // Build a Book with filePath = 'audioonly://' sentinel.
      // The reading screen knows to show the audio-only player when
      // filePath starts with 'audioonly://'.
      final book = Book(
        title: _titleCtrl.text.trim().isEmpty ? 'Audiobook' : _titleCtrl.text.trim(),
        author: _authorCtrl.text.trim().isEmpty ? 'Unknown' : _authorCtrl.text.trim(),
        coverPath: coverPath,
        filePath: 'audioonly://${copiedTracks.first.path}',
        addedAt: DateTime.now(),
        audioTracks: copiedTracks,
        genre: 'Audiobook',
      );

      await ref.read(libraryProvider.notifier).importAudiobook(book);
      if (mounted) setState(() => _isDone = true);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isImporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;

    return Container(
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: t.glassBorder.withValues(alpha: 0.1)),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            24, 16, 24, MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: _isDone ? _buildDone(t) : _buildForm(t),
        ),
      ),
    );
  }

  Widget _buildHandle(TibebThemeExtension t) => Center(
    child: Container(
      width: 40, height: 4,
      decoration: BoxDecoration(
        color: t.borderSubtle,
        borderRadius: BorderRadius.circular(2),
      ),
    ),
  );

  Widget _buildDone(TibebThemeExtension t) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      _buildHandle(t),
      const SizedBox(height: 24),
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: t.success.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.headphones_rounded, size: 48, color: t.success),
      ),
      const SizedBox(height: 16),
      Text(
        'Audiobook Added!',
        style: TextStyle(
          color: t.textPrimary, fontSize: 20, fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        '"${_titleCtrl.text}" has been added to your library.',
        textAlign: TextAlign.center,
        style: TextStyle(color: t.textSecondary, fontSize: 14),
      ),
      const SizedBox(height: 24),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            // Switch to Library tab (index 1) before dismissing
            ref.read(navigationStateProvider.notifier).changeTab(1);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: t.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: const Text('Go to Library', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    ],
  );

  Widget _buildForm(TibebThemeExtension t) => SingleChildScrollView(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHandle(t),
        const SizedBox(height: 20),

        // Header
        Row(children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: t.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.headphones_rounded, color: t.primary, size: 24),
          ),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Import Audiobook',
              style: TextStyle(color: t.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('MP3 · M4A · M4B · FLAC · OGG · WAV',
              style: TextStyle(color: t.textSecondary, fontSize: 11),
            ),
          ]),
        ]),

        const SizedBox(height: 24),

        // Pick file button
        GestureDetector(
          onTap: _isImporting ? null : _pick,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _meta != null
                  ? t.primary.withValues(alpha: 0.08)
                  : t.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _meta != null ? t.primary : t.borderSubtle,
                width: _meta != null ? 1.5 : 1,
              ),
            ),
            child: _meta == null
                ? Column(children: [
                    Icon(Icons.audio_file_rounded, size: 40, color: t.textTertiary),
                    const SizedBox(height: 8),
                    Text('Tap to select audio files',
                      style: TextStyle(color: t.textSecondary, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text('Select multiple files for a multi-part audiobook',
                      style: TextStyle(color: t.textTertiary, fontSize: 11),
                      textAlign: TextAlign.center,
                    ),
                  ])
                : Row(children: [
                    Icon(Icons.check_circle_rounded, color: t.success, size: 24),
                    const SizedBox(width: 12),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${_meta!.tracks.length} track${_meta!.tracks.length > 1 ? 's' : ''} selected',
                          style: TextStyle(color: t.textPrimary, fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        const SizedBox(height: 2),
                        Text(_meta!.tracks.map((t) => t.title).take(3).join(', ') +
                          (_meta!.tracks.length > 3 ? '…' : ''),
                          style: TextStyle(color: t.textSecondary, fontSize: 11),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    )),
                    Icon(Icons.swap_horiz_rounded, color: t.textTertiary, size: 18),
                  ]),
          ),
        ),

        if (_meta != null) ...[
          const SizedBox(height: 20),

          // Title field
          Text('Title', style: TextStyle(color: t.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextField(
            controller: _titleCtrl,
            style: TextStyle(color: t.textPrimary),
            decoration: InputDecoration(
              hintText: 'Audiobook title',
              hintStyle: TextStyle(color: t.textTertiary),
              filled: true,
              fillColor: t.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: t.borderSubtle),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: t.borderSubtle),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: t.primary, width: 1.5),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Author field
          Text('Author / Narrator', style: TextStyle(color: t.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextField(
            controller: _authorCtrl,
            style: TextStyle(color: t.textPrimary),
            decoration: InputDecoration(
              hintText: 'Author or narrator name',
              hintStyle: TextStyle(color: t.textTertiary),
              filled: true,
              fillColor: t.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: t.borderSubtle),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: t.borderSubtle),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: t.primary, width: 1.5),
              ),
            ),
          ),

          // Track list preview
          if (_meta!.tracks.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text('Tracks', style: TextStyle(color: t.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: t.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: t.borderSubtle),
              ),
              child: Column(
                children: List.generate(
                  _meta!.tracks.length.clamp(0, 5),
                  (i) {
                    final track = _meta!.tracks[i];
                    final isLast = i == (_meta!.tracks.length.clamp(0, 5) - 1);
                    return Column(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        child: Row(children: [
                          Container(
                            width: 24, height: 24,
                            decoration: BoxDecoration(
                              color: t.primary.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text('${i + 1}',
                                style: TextStyle(color: t.primary, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: Text(track.title,
                            style: TextStyle(color: t.textPrimary, fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )),
                          Icon(Icons.music_note_rounded, size: 14, color: t.textTertiary),
                        ]),
                      ),
                      if (!isLast)
                        Divider(height: 1, color: t.borderSubtle),
                    ]);
                  },
                )..addAll(
                  _meta!.tracks.length > 5 ? [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Text('+${_meta!.tracks.length - 5} more tracks',
                        style: TextStyle(color: t.textTertiary, fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                    ),
                  ] : [],
                ),
              ),
            ),
          ],
        ],

        if (_error != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: t.error.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: t.error.withValues(alpha: 0.2)),
            ),
            child: Row(children: [
              Icon(Icons.error_outline_rounded, color: t.error, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(_error!, style: TextStyle(color: t.error, fontSize: 12))),
            ]),
          ),
        ],

        if (_isImporting) ...[
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _importProgress,
              backgroundColor: t.borderSubtle,
              valueColor: AlwaysStoppedAnimation<Color>(t.primary),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Copying tracks to library… ${(_importProgress * 100).toInt()}%',
            style: TextStyle(color: t.textTertiary, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],

        const SizedBox(height: 24),

        // Import button
        if (!_isImporting)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _meta != null ? _import : null,
              icon: const Icon(Icons.library_music_rounded),
              label: const Text('Add to Library', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              style: ElevatedButton.styleFrom(
                backgroundColor: t.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: t.borderSubtle,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
            ),
          ),
      ],
    ),
  );
}

// ---------------------------------------------------------------------------
// AudioOnly Player Screen — full-screen player for pure audiobooks
// ---------------------------------------------------------------------------

/// Shown when a Book has filePath starting with 'audioonly://'.
class AudioOnlyPlayerScreen extends ConsumerStatefulWidget {
  final Book book;
  const AudioOnlyPlayerScreen({super.key, required this.book});

  @override
  ConsumerState<AudioOnlyPlayerScreen> createState() => _AudioOnlyPlayerScreenState();
}

class _AudioOnlyPlayerScreenState extends ConsumerState<AudioOnlyPlayerScreen>
    with SingleTickerProviderStateMixin {
  final _player = AudioPlayer();
  bool _isLoading = true;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  double _speed = 1.0;
  int _currentIndex = 0;
  late AnimationController _artAnim;

  @override
  void initState() {
    super.initState();
    _artAnim = AnimationController(vsync: this, duration: const Duration(seconds: 20))
      ..repeat();

    _initPlayer();

    _player.playerStateStream.listen((state) {
      if (!mounted) return;
      setState(() => _isPlaying = state.playing);
      if (state.playing) {
        _artAnim.forward();
      } else {
        _artAnim.stop();
      }
    });
    _player.positionStream.listen((pos) {
      if (mounted) {
        setState(() => _position = pos);
        _maybeSave(pos);
      }
    });
    _player.durationStream.listen((dur) {
      if (mounted) setState(() => _duration = dur ?? Duration.zero);
    });
    _player.currentIndexStream.listen((idx) {
      if (idx != null && mounted) {
        setState(() => _currentIndex = idx);
        _saveProgress(_player.position.inMilliseconds, idx);
      }
    });
  }

  DateTime _lastSaveTime = DateTime.now();
  int _lastSavedMs = -1;

  void _maybeSave(Duration pos) {
    final now = DateTime.now();
    final ms = pos.inMilliseconds;
    final diff = (ms - _lastSavedMs).abs();
    final elapsed = now.difference(_lastSaveTime);
    if (elapsed > const Duration(seconds: 10) || diff > 5000) {
      _saveProgress(ms, _player.currentIndex ?? 0);
    }
  }

  Future<void> _saveProgress(int ms, int index) async {
    _lastSaveTime = DateTime.now();
    _lastSavedMs = ms;

    final totalTracks = widget.book.audioTracks.length;
    if (totalTracks == 0) return;

    double currentTrackProgress = 0.0;
    if (_duration.inMilliseconds > 0) {
      currentTrackProgress = ms / _duration.inMilliseconds;
    }
    double overallProgress = (index + currentTrackProgress) / totalTracks;
    overallProgress = overallProgress.clamp(0.0, 1.0);

    final updatedBook = widget.book.copyWith(
      audioLastPosition: ms,
      audioLastIndex: index,
      progress: overallProgress,
      lastReadAt: DateTime.now(),
    );

    // Persist position and calculated progress back to database repository
    await ref.read(libraryProvider.notifier).updateBook(updatedBook);
  }

  Future<void> _initPlayer() async {
    final tracks = widget.book.audioTracks;
    if (tracks.isEmpty) return;

    final lastIdx = widget.book.audioLastIndex ?? 0;
    final lastMs = widget.book.audioLastPosition ?? 0;

    final sources = tracks.map((t) => AudioSource.file(t.path, tag: t.title)).toList();
    await _player.setAudioSources(
      sources,
      initialIndex: lastIdx < tracks.length ? lastIdx : 0,
      initialPosition: Duration(milliseconds: lastMs),
    );

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _artAnim.dispose();
    // Flush the final position to the repository before disposing
    final currentPos = _player.position.inMilliseconds;
    final currentIndex = _player.currentIndex ?? 0;
    _saveProgress(currentPos, currentIndex);
    _player.dispose();
    super.dispose();
  }


  String _fmt(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;
    final track = widget.book.audioTracks.isNotEmpty
        ? widget.book.audioTracks[_currentIndex.clamp(0, widget.book.audioTracks.length - 1)]
        : null;

    return Scaffold(
      backgroundColor: t.background,
      body: SafeArea(
        child: Column(children: [
          // Top bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.keyboard_arrow_down_rounded, color: t.textPrimary, size: 28),
              ),
              Expanded(child: Text('Now Playing',
                textAlign: TextAlign.center,
                style: TextStyle(color: t.textSecondary, fontSize: 13, letterSpacing: 1.2, fontWeight: FontWeight.w600),
              )),
              IconButton(
                onPressed: () => _showTrackList(context, t),
                icon: Icon(Icons.queue_music_rounded, color: t.textPrimary, size: 24),
              ),
            ]),
          ),

          const Spacer(),

          // Rotating artwork
          AnimatedBuilder(
            animation: _artAnim,
            builder: (context, _) => Transform.rotate(
              angle: _artAnim.value * 2 * 3.14159,
              child: Container(
                width: 220, height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: t.surface,
                  border: Border.all(color: t.primary.withValues(alpha: 0.3), width: 3),
                  boxShadow: [
                    BoxShadow(color: t.primary.withValues(alpha: 0.2), blurRadius: 40, spreadRadius: 5),
                    BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 20),
                  ],
                  image: widget.book.coverPath.isNotEmpty
                      ? DecorationImage(
                          image: FileImage(io.File(widget.book.coverPath)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: widget.book.coverPath.isEmpty
                    ? Icon(Icons.headphones_rounded, size: 80, color: t.primary)
                    : null,
              ),
            ),
          ),

          const SizedBox(height: 48),

          // Title + track info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(children: [
              Text(widget.book.title,
                style: TextStyle(color: t.textPrimary, fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(widget.book.author,
                style: TextStyle(color: t.primary, fontSize: 14, fontWeight: FontWeight.w500),
              ),
              if (track != null) ...[
                const SizedBox(height: 4),
                Text('Track ${_currentIndex + 1}/${widget.book.audioTracks.length}: ${track.title}',
                  style: TextStyle(color: t.textTertiary, fontSize: 12),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ]),
          ),

          const SizedBox(height: 32),

          // Progress slider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: t.primary,
                  inactiveTrackColor: t.borderSubtle,
                  thumbColor: t.primary,
                  overlayColor: t.primary.withValues(alpha: 0.15),
                  trackHeight: 3,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                ),
                child: Slider(
                  value: _duration.inSeconds > 0
                      ? _position.inSeconds.clamp(0, _duration.inSeconds).toDouble()
                      : 0,
                  min: 0,
                  max: _duration.inSeconds > 0 ? _duration.inSeconds.toDouble() : 1,
                  onChanged: (v) => _player.seek(Duration(seconds: v.toInt())),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(_fmt(_position), style: TextStyle(color: t.textTertiary, fontSize: 12)),
                  Text(_fmt(_duration), style: TextStyle(color: t.textTertiary, fontSize: 12)),
                ]),
              ),
            ]),
          ),

          const SizedBox(height: 24),

          // Controls
          if (_isLoading)
            CircularProgressIndicator(color: t.primary)
          else
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              // Speed
              GestureDetector(
                onTap: _cycleSpeed,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: t.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('${_speed}x',
                    style: TextStyle(color: t.primary, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(width: 20),

              // Prev track
              IconButton(
                onPressed: () => _player.seekToPrevious(),
                icon: Icon(Icons.skip_previous_rounded, color: t.textPrimary, size: 36),
              ),

              // Skip -10s
              IconButton(
                onPressed: () => _player.seek(_position - const Duration(seconds: 10)),
                icon: Icon(Icons.replay_10, color: t.textPrimary, size: 30),
              ),

              // Play/Pause
              GestureDetector(
                onTap: _isPlaying ? _player.pause : _player.play,
                child: Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: t.primary,
                    boxShadow: [
                      BoxShadow(color: t.primary.withValues(alpha: 0.4), blurRadius: 20, spreadRadius: 2),
                    ],
                  ),
                  child: Icon(_isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: Colors.white, size: 36,
                  ),
                ),
              ),

              // Skip +30s
              IconButton(
                onPressed: () => _player.seek(_position + const Duration(seconds: 30)),
                icon: Icon(Icons.forward_30_rounded, color: t.textPrimary, size: 30),
              ),

              // Next track
              IconButton(
                onPressed: () => _player.seekToNext(),
                icon: Icon(Icons.skip_next_rounded, color: t.textPrimary, size: 36),
              ),

              const SizedBox(width: 20),
              // Placeholder to mirror speed button width
              const SizedBox(width: 46),
            ]),

          const Spacer(),
        ]),
      ),
    );
  }

  void _cycleSpeed() {
    const speeds = [0.75, 1.0, 1.25, 1.5, 1.75, 2.0];
    final idx = speeds.indexOf(_speed);
    final next = speeds[(idx + 1) % speeds.length];
    setState(() => _speed = next);
    _player.setSpeed(next);
  }

  void _showTrackList(BuildContext context, TibebThemeExtension t) {
    showModalBottomSheet(
      context: context,
      backgroundColor: t.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Center(child: Container(
            width: 36, height: 4,
            decoration: BoxDecoration(color: t.borderSubtle, borderRadius: BorderRadius.circular(2)),
          )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text('Track List',
              style: TextStyle(color: t.textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.book.audioTracks.length,
              itemBuilder: (_, i) {
                final track = widget.book.audioTracks[i];
                final isActive = i == _currentIndex;
                return ListTile(
                  leading: Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color: isActive ? t.primary : t.primary.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: isActive
                        ? Icon(Icons.volume_up_rounded, color: Colors.white, size: 16)
                        : Center(child: Text('${i + 1}',
                            style: TextStyle(color: t.primary, fontSize: 12, fontWeight: FontWeight.bold))),
                  ),
                  title: Text(track.title,
                    style: TextStyle(
                      color: isActive ? t.primary : t.textPrimary,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                  onTap: () {
                    _player.seek(Duration.zero, index: i);
                    _player.play();
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/// Helper to check if a Book is an audio-only book.
extension AudioOnlyBook on Book {
  bool get isAudioOnly => filePath.startsWith('audioonly://');
}
