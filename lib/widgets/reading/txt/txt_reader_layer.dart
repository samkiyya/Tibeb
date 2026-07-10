import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show Ticker;
import 'package:flutter/services.dart' show Clipboard, ClipboardData;

import 'package:tibeb/core/theme/theme.dart';
import 'package:tibeb/l10n/app_localizations.dart';
import 'package:tibeb/models/book_model.dart';
import 'package:tibeb/models/reader_settings_model.dart';
import 'txt_header.dart';

/// Fully isolated plain-text (.txt) reader and editor.
/// Does not import any Markdown packages or WebView.
class TxtReaderLayer extends StatefulWidget {
  final Book book;
  final ReaderSettings settings;
  final ValueNotifier<double> scrollProgressNotifier;
  final ValueNotifier<double> autoScrollSpeedNotifier;
  final VoidCallback onToggleControls;
  final VoidCallback onInteraction;

  const TxtReaderLayer({
    super.key,
    required this.book,
    required this.settings,
    required this.scrollProgressNotifier,
    required this.autoScrollSpeedNotifier,
    required this.onToggleControls,
    required this.onInteraction,
  });

  @override
  State<TxtReaderLayer> createState() => TxtReaderLayerState();
}

class TxtReaderLayerState extends State<TxtReaderLayer>
    with TickerProviderStateMixin {
  // ── State ────────────────────────────────────────────────────────────────
  String _originalSource = '';
  bool _isLoading = true;
  String? _error;
  bool _isEmpty = false;

  late final TextEditingController _editCtrl;
  late final ScrollController _scrollCtrl;
  int _wordCount = 0;
  int _lineCount = 0;

  bool _isUpdatingFromOutside = false;

  Ticker? _autoScrollTicker;
  Duration _lastTick = Duration.zero;

  // ── Computed ────────────────────────────────────────────────────────────
  bool get _hasUnsavedChanges => _editCtrl.text != _originalSource;

  // ── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _editCtrl = TextEditingController();
    _scrollCtrl = ScrollController()..addListener(_onScrollChanged);
    widget.scrollProgressNotifier.addListener(_onOutsideScrollChanged);
    widget.autoScrollSpeedNotifier.addListener(_onSpeedChanged);

    _autoScrollTicker = createTicker(_onTick);
    if (widget.autoScrollSpeedNotifier.value > 0) _autoScrollTicker?.start();

    _loadFile();
  }

  @override
  void didUpdateWidget(covariant TxtReaderLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.book.filePath != widget.book.filePath) {
      _loadFile();
    }
  }

  @override
  void dispose() {
    widget.scrollProgressNotifier.removeListener(_onOutsideScrollChanged);
    widget.autoScrollSpeedNotifier.removeListener(_onSpeedChanged);
    _autoScrollTicker?.dispose();
    _scrollCtrl.removeListener(_onScrollChanged);
    _scrollCtrl.dispose();
    _editCtrl.dispose();
    super.dispose();
  }

  // ── File Loading ─────────────────────────────────────────────────────────

  Future<void> _loadFile() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
      _isEmpty = false;
    });

    try {
      final file = File(widget.book.filePath);
      if (!await file.exists()) {
        throw Exception('File not found: ${widget.book.filePath}');
      }
      final content = await file.readAsString();

      if (!mounted) return;
      setState(() {
        _originalSource = content;
        _editCtrl.text = content;
        _isEmpty = content.trim().isEmpty;
        _isLoading = false;
        _updateStats(content);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _updateStats(String text) {
    _wordCount = text.trim().isEmpty
        ? 0
        : text.trim().split(RegExp(r'\s+')).length;
    _lineCount = text.isEmpty ? 1 : text.split('\n').length;
  }

  // ── Scroll ────────────────────────────────────────────────────────────────

  void _onScrollChanged() {
    if (_isUpdatingFromOutside) return;
    if (!_scrollCtrl.hasClients) return;
    final max = _scrollCtrl.position.maxScrollExtent;
    final current = _scrollCtrl.offset;
    final progress = max > 0 ? (current / max).clamp(0.0, 1.0) : 0.0;
    widget.scrollProgressNotifier.value = progress;
  }

  void _onOutsideScrollChanged() {
    if (_isUpdatingFromOutside) return;
    _isUpdatingFromOutside = true;
    try {
      if (!_scrollCtrl.hasClients) return;
      final pct = widget.scrollProgressNotifier.value;
      final maxScroll = _scrollCtrl.position.maxScrollExtent;
      final target = (pct * maxScroll).clamp(0.0, maxScroll);
      if ((_scrollCtrl.offset - target).abs() > 10) {
        _scrollCtrl.jumpTo(target);
      }
    } finally {
      Future.delayed(const Duration(milliseconds: 50), () {
        _isUpdatingFromOutside = false;
      });
    }
  }

  // ── Auto-scroll ticker ─────────────────────────────────────────────────

  void _onSpeedChanged() {
    final speed = widget.autoScrollSpeedNotifier.value;
    if (speed > 0) {
      if (!(_autoScrollTicker?.isActive ?? false)) {
        _lastTick = Duration.zero;
        _autoScrollTicker?.start();
      }
    } else {
      _autoScrollTicker?.stop();
    }
  }

  void _onTick(Duration elapsed) {
    final speed = widget.autoScrollSpeedNotifier.value;
    if (speed <= 0) return;
    final deltaMs = (elapsed - _lastTick).inMilliseconds;
    _lastTick = elapsed;
    if (deltaMs <= 0) return;

    final increment = speed * 30.0 * (deltaMs / 1000.0);
    if (_scrollCtrl.hasClients) {
      final current = _scrollCtrl.offset;
      final max = _scrollCtrl.position.maxScrollExtent;
      if (current < max) {
        _scrollCtrl.jumpTo((current + increment).clamp(0.0, max));
      }
    }
  }

  // ── Actions ────────────────────────────────────────────────────────────

  Future<void> _save() async {
    widget.onInteraction();
    final l10n = AppLocalizations.of(context)!;
    final t = context.tibpiColors;
    final text = _editCtrl.text;
    try {
      await File(widget.book.filePath).writeAsString(text);
      if (!mounted) return;
      setState(() {
        _originalSource = text;
        _updateStats(text);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.savedSuccessfully),
          behavior: SnackBarBehavior.floating,
          backgroundColor: t.success,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.saveFailed}: $e'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: t.error,
        ),
      );
    }
  }

  void _copyAll() {
    widget.onInteraction();
    Clipboard.setData(ClipboardData(text: _editCtrl.text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    widget.onInteraction();

    if (_isLoading) {
      return _TxtLoadingSkeleton(settings: widget.settings);
    }

    if (_error != null) {
      return _TxtErrorView(
        settings: widget.settings,
        message: _error!,
        onRetry: _loadFile,
      );
    }

    if (_isEmpty) {
      return _TxtEmptyView(settings: widget.settings);
    }

    return Scaffold(
      backgroundColor: widget.settings.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            TxtHeader(
              book: widget.book,
              settings: widget.settings,
              hasUnsavedChanges: _hasUnsavedChanges,
              wordCount: _wordCount,
              lineCount: _lineCount,
              onSave: _save,
              onCopyAll: _copyAll,
            ),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (notif) {
                  widget.onInteraction();
                  return false;
                },
                child: SingleChildScrollView(
                  controller: _scrollCtrl,
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      textSelectionTheme: TextSelectionThemeData(
                        cursorColor: widget.settings.textColor,
                        selectionColor: widget.settings.textColor.withValues(
                          alpha: 0.22,
                        ),
                        selectionHandleColor: widget.settings.textColor,
                      ),
                    ),
                    child: TextField(
                      controller: _editCtrl,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      cursorColor: widget.settings.textColor,
                      style: TextStyle(
                        color: widget.settings.textColor,
                        fontSize: widget.settings.textSize - 1,
                        fontFamily: 'Courier',
                        height: widget.settings.lineHeight,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      onChanged: (val) {
                        widget.onInteraction();
                        setState(() => _updateStats(val));
                      },
                      onTap: widget.onInteraction,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Loading Skeleton ────────────────────────────────────────────────────────

class _TxtLoadingSkeleton extends StatelessWidget {
  final ReaderSettings settings;
  const _TxtLoadingSkeleton({required this.settings});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: settings.backgroundColor,
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < 6; i++) ...[
            _ShimmerBar(
              width: i == 0 ? 200 : double.infinity,
              height: i == 0 ? 14 : 12,
              color: settings.secondaryTextColor.withValues(alpha: 0.12),
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 20),
          for (int i = 0; i < 12; i++) ...[
            _ShimmerBar(
              width: double.infinity,
              height: 12,
              color: settings.secondaryTextColor.withValues(alpha: 0.07),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _ShimmerBar extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const _ShimmerBar({
    required this.width,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

// ── Error View ──────────────────────────────────────────────────────────────

class _TxtErrorView extends StatelessWidget {
  final ReaderSettings settings;
  final String message;
  final VoidCallback onRetry;

  const _TxtErrorView({
    required this.settings,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;
    return Container(
      color: settings.backgroundColor,
      padding: const EdgeInsets.all(32),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline_rounded, size: 52, color: t.error),
          const SizedBox(height: 16),
          Text(
            'Could not open file',
            style: TextStyle(
              color: settings.textColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: settings.secondaryTextColor, fontSize: 13),
          ),
          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

// ── Empty View ──────────────────────────────────────────────────────────────

class _TxtEmptyView extends StatelessWidget {
  final ReaderSettings settings;
  const _TxtEmptyView({required this.settings});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: settings.backgroundColor,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.text_snippet_outlined,
            size: 52,
            color: settings.secondaryTextColor.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          Text(
            'This file is empty',
            style: TextStyle(color: settings.secondaryTextColor, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
