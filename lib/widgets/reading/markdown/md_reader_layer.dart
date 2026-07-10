import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show Ticker;
import 'package:flutter/services.dart'
    show rootBundle, Clipboard, ClipboardData;
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/theme/theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/book_model.dart';
import '../../../models/markdown_outline_node.dart';
import '../../../models/reader_settings_model.dart';
import 'markdown_html_builder.dart';
import 'markdown_renderer.dart';
import 'md_editor_view.dart';

enum _MdMode { preview, edit }

/// Production-grade Markdown reader/editor layer.
/// Fully isolated from the TxtReaderLayer — no shared state or rendering code.
class MdReaderLayer extends StatefulWidget {
  final Book book;
  final ReaderSettings settings;
  final ValueNotifier<double> scrollProgressNotifier;
  final ValueNotifier<double> autoScrollSpeedNotifier;
  final VoidCallback onToggleControls;
  final VoidCallback onInteraction;
  final Function(
    List<MarkdownOutlineNode> flat,
    List<MarkdownOutlineNode> tree,
  )?
  onLoaded;
  final Function(MarkdownOutlineNode node)? onActiveHeadingChanged;

  const MdReaderLayer({
    super.key,
    required this.book,
    required this.settings,
    required this.scrollProgressNotifier,
    required this.autoScrollSpeedNotifier,
    required this.onToggleControls,
    required this.onInteraction,
    this.onLoaded,
    this.onActiveHeadingChanged,
  });

  @override
  State<MdReaderLayer> createState() => MdReaderLayerState();
}

class MdReaderLayerState extends State<MdReaderLayer>
    with TickerProviderStateMixin {
  // ── State ────────────────────────────────────────────────────────────────
  String _source = '';
  String _originalSource = '';
  bool _isLoading = true;
  String? _error;
  bool _isEmpty = false;
  _MdMode _mode = _MdMode.preview;

  late final TextEditingController _editCtrl;
  late final ScrollController _editorScrollCtrl;
  late final WebViewController _webCtrl;
  late final TabController _tabCtrl;

  // Cached JS assets
  String _hlJs = '';
  String _mermaidJs = '';
  String _hlDarkCss = '';
  String _hlLightCss = '';
  String _katexJs = '';
  String _katexCss = '';

  bool _webPageReady = false;
  bool _isUpdatingFromOutside = false;
  List<MarkdownOutlineNode> _flatOutline = [];

  Ticker? _autoScrollTicker;
  Duration _lastTick = Duration.zero;

  // ── Public API ────────────────────────────────────────────────────────────

  /// Scroll preview to a specific heading element ID.
  void jumpToHeading(String elementId) {
    if (_mode == _MdMode.preview && _webPageReady) {
      _webCtrl.runJavaScript('''
        (function() {
          const el = document.getElementById('$elementId');
          if (el) el.scrollIntoView({ behavior: 'smooth', block: 'start' });
        })();
      ''');
    } else {
      // In edit mode, jump to approximate line
      final node = _findNodeById(elementId);
      if (node != null && _editorScrollCtrl.hasClients) {
        final totalLines = _source.split('\n').length;
        if (totalLines > 0) {
          final target =
              (node.lineNumber / totalLines) *
              _editorScrollCtrl.position.maxScrollExtent;
          _editorScrollCtrl.animateTo(
            target,
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOut,
          );
        }
      }
    }
  }

  /// Trigger in-WebView search. Result comes back via TibebBridge message.
  void searchInDocument(
    String query, {
    bool caseSensitive = false,
    bool regex = false,
  }) {
    if (!_webPageReady) return;
    final flags = '${caseSensitive ? 'i' : ''}${regex ? 'r' : ''}';
    final safeQuery = query.replaceAll("'", "\\'").replaceAll(r'\', r'\\');
    _webCtrl.runJavaScript("searchInDocument('$safeQuery','$flags');");
  }

  void navigateSearchMatch(int direction) {
    if (!_webPageReady) return;
    _webCtrl.runJavaScript("navigateSearch($direction);");
  }

  void clearSearch() {
    if (!_webPageReady) return;
    _webCtrl.runJavaScript("clearSearch();");
  }

  /// Update CSS variables for instant theme change without page reload.
  void applyTheme(ReaderSettings settings) {
    if (!_webPageReady) return;
    final isDark =
        settings.theme == ReaderTheme.darkBlue ||
        settings.theme == ReaderTheme.black;
    final accent = isDark ? '#7fa9ff' : '#2563eb';
    final codeBg = isDark ? '#131320' : '#f4f4f8';
    final codeBorder = isDark ? '#2a2a3e' : '#dde1f0';
    final bqBg = isDark ? 'rgba(255,255,255,0.03)' : 'rgba(0,0,0,0.025)';
    final bg = _toHexJs(settings.backgroundColor);
    final fg = _toHexJs(settings.textColor);
    final secFg = _toHexJs(settings.secondaryTextColor);

    final vars =
        '''{
      "--bg":"$bg","--fg":"$fg","--sec-fg":"$secFg",
      "--accent":"$accent","--code-bg":"$codeBg",
      "--code-border":"$codeBorder","--bq-bg":"$bqBg",
      "--font-size":"${settings.textSize}px",
      "--line-height":"${settings.lineHeight}"
    }''';
    _webCtrl.runJavaScript('updateTheme($vars);');
  }

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _editCtrl = TextEditingController();
    _editorScrollCtrl = ScrollController()..addListener(_onEditorScroll);
    _tabCtrl = TabController(length: 2, vsync: this)
      ..addListener(_onTabChanged);

    widget.scrollProgressNotifier.addListener(_onOutsideScrollChanged);
    widget.autoScrollSpeedNotifier.addListener(_onSpeedChanged);

    _autoScrollTicker = createTicker(_onTick);

    _initWebView();
    _loadAssetsAndFile();
  }

  @override
  void didUpdateWidget(covariant MdReaderLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.book.filePath != widget.book.filePath) {
      MarkdownRenderer.clearCache();
      _loadAssetsAndFile();
      return;
    }
    // If only settings changed, apply theme without full reload
    if (oldWidget.settings.theme != widget.settings.theme ||
        oldWidget.settings.textSize != widget.settings.textSize ||
        oldWidget.settings.lineHeight != widget.settings.lineHeight ||
        oldWidget.settings.typeface != widget.settings.typeface) {
      if (_webPageReady) {
        applyTheme(widget.settings);
      }
    }
  }

  @override
  void dispose() {
    widget.scrollProgressNotifier.removeListener(_onOutsideScrollChanged);
    widget.autoScrollSpeedNotifier.removeListener(_onSpeedChanged);
    _autoScrollTicker?.dispose();
    _editorScrollCtrl
      ..removeListener(_onEditorScroll)
      ..dispose();
    _editCtrl.dispose();
    _tabCtrl.dispose();
    MarkdownRenderer.clearCache();
    super.dispose();
  }

  // ── WebView Init ──────────────────────────────────────────────────────────

  void _initWebView() {
    _webCtrl = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..addJavaScriptChannel(
        'TibebBridge',
        onMessageReceived: (msg) {
          final m = msg.message;
          if (m == 'toggleControls') {
            widget.onToggleControls();
          } else if (m.startsWith('activeHeading:')) {
            _onActiveHeadingReceived(m.substring('activeHeading:'.length));
          } else if (m.startsWith('searchResult:')) {
            // searchResult:total:current — forwarded to any search overlay
            // (no-op here; reading_screen can wire up a listener if needed)
          } else {
            final v = double.tryParse(m);
            if (v != null && !_isUpdatingFromOutside) {
              widget.scrollProgressNotifier.value = v.clamp(0.0, 1.0);
            }
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (!mounted) return;
            _webPageReady = true;
            _onOutsideScrollChanged();
            if (widget.autoScrollSpeedNotifier.value > 0) {
              _autoScrollTicker?.start();
            }
          },
        ),
      );
  }

  // ── File Loading ──────────────────────────────────────────────────────────

  Future<void> _loadAssetsAndFile() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
      _webPageReady = false;
    });

    try {
      // Load JS assets (cached by Flutter asset bundle)
      if (_hlJs.isEmpty) {
        _hlJs = await rootBundle.loadString('assets/highlight.min.js');
        try {
          final dartJs = await rootBundle.loadString(
            'assets/highlight-dart.min.js',
          );
          _hlJs = '$_hlJs\n$dartJs';
        } catch (e) {
          debugPrint('Failed to load highlight-dart.min.js: $e');
        }
        _hlDarkCss = await rootBundle.loadString(
          'assets/highlight-dark.min.css',
        );
        _hlLightCss = await rootBundle.loadString(
          'assets/highlight-light.min.css',
        );
        _mermaidJs = await rootBundle.loadString('assets/mermaid.min.js');
        // KaTeX optional
        try {
          _katexJs = await rootBundle.loadString('assets/katex.min.js');
          _katexCss = await rootBundle.loadString('assets/katex.min.css');
          // Patch relative font paths to use jsDelivr CDN
          // _katexCss = _katexCss.replaceAll(
          //   'url(fonts/',
          //   'url(https://cdn.jsdelivr.net/npm/katex@0.16.11/dist/fonts/',
          // );
        } catch (_) {
          _katexJs = '';
          _katexCss = '';
        }
      }

      final file = File(widget.book.filePath);
      if (!await file.exists()) {
        throw Exception('File not found: ${widget.book.filePath}');
      }
      final content = await file.readAsString();

      if (!mounted) return;
      final renderResult = MarkdownRenderer.render(content);
      final outline = _buildOutline(renderResult.headings);

      setState(() {
        _source = content;
        _originalSource = content;
        _editCtrl.text = content;
        _isEmpty = content.trim().isEmpty;
        _flatOutline = outline.flat;
        _isLoading = false;
      });

      if (widget.onLoaded != null) {
        widget.onLoaded!(outline.flat, outline.tree);
      }

      _renderPreview(renderResult.html);
    } catch (e, stack) {
      debugPrint('MdReaderLayer error: $e\n$stack');
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _renderPreview([String? preRenderedHtml]) {
    final html = preRenderedHtml ?? MarkdownRenderer.render(_source).html;
    final fullHtml = MarkdownHtmlBuilder.buildHtml(
      renderedHtml: html,
      settings: widget.settings,
      hlJs: _hlJs,
      mermaidJs: _mermaidJs,
      hlDarkCss: _hlDarkCss,
      hlLightCss: _hlLightCss,
      katexJs: _katexJs,
      katexCss: _katexCss,
    );

    _webPageReady = false;
    _webCtrl.loadHtmlString(fullHtml, baseUrl: 'about:blank');
  }

  // ── Tab & Mode ────────────────────────────────────────────────────────────

  void _onTabChanged() {
    if (!_tabCtrl.indexIsChanging) return;
    final newMode = _tabCtrl.index == 0 ? _MdMode.preview : _MdMode.edit;

    if (newMode == _MdMode.preview) {
      // Re-render markdown if content changed in editor
      if (_editCtrl.text != _source) {
        _source = _editCtrl.text;
        MarkdownRenderer.clearCache();
        final result = MarkdownRenderer.render(_source);
        final outline = _buildOutline(result.headings);
        setState(() {
          _flatOutline = outline.flat;
          _mode = newMode;
        });
        if (widget.onLoaded != null) {
          widget.onLoaded!(outline.flat, outline.tree);
        }
        _renderPreview(result.html);
        return;
      }
    }

    setState(() => _mode = newMode);
  }

  // ── Scroll ────────────────────────────────────────────────────────────────

  void _onEditorScroll() {
    if (_isUpdatingFromOutside || !_editorScrollCtrl.hasClients) return;
    final max = _editorScrollCtrl.position.maxScrollExtent;
    final curr = _editorScrollCtrl.offset;
    final progress = max > 0 ? (curr / max).clamp(0.0, 1.0) : 0.0;
    widget.scrollProgressNotifier.value = progress;
  }

  void _onOutsideScrollChanged() {
    if (_isUpdatingFromOutside) return;
    _isUpdatingFromOutside = true;
    try {
      final pct = widget.scrollProgressNotifier.value;
      if (_mode == _MdMode.preview && _webPageReady) {
        _webCtrl.runJavaScript('''
          (function() {
            const max = document.documentElement.scrollHeight - window.innerHeight;
            const target = $pct * max;
            if (Math.abs(window.scrollY - target) > 12) window.scrollTo(0, target);
          })();
        ''');
      } else if (_mode == _MdMode.edit && _editorScrollCtrl.hasClients) {
        final max = _editorScrollCtrl.position.maxScrollExtent;
        final target = (pct * max).clamp(0.0, max);
        if ((_editorScrollCtrl.offset - target).abs() > 12) {
          _editorScrollCtrl.jumpTo(target);
        }
      }
    } finally {
      Future.delayed(const Duration(milliseconds: 60), () {
        _isUpdatingFromOutside = false;
      });
    }
  }

  // ── Auto-scroll ───────────────────────────────────────────────────────────

  void _onSpeedChanged() {
    final speed = widget.autoScrollSpeedNotifier.value;
    if (speed > 0) {
      if (!(_autoScrollTicker?.isActive ?? false)) {
        _lastTick = Duration.zero;
        if (_webPageReady || _mode == _MdMode.edit) {
          _autoScrollTicker?.start();
        }
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
    if (_mode == _MdMode.preview) {
      if (_webPageReady) {
        _webCtrl.runJavaScript('window.scrollBy(0, $increment);');
      }
    } else if (_editorScrollCtrl.hasClients) {
      final curr = _editorScrollCtrl.offset;
      final max = _editorScrollCtrl.position.maxScrollExtent;
      if (curr < max) {
        _editorScrollCtrl.jumpTo((curr + increment).clamp(0.0, max));
      }
    }
  }

  // ── Active Heading ────────────────────────────────────────────────────────

  void _onActiveHeadingReceived(String elementId) {
    if (widget.onActiveHeadingChanged == null) return;
    final node = _findNodeById(elementId);
    if (node != null) widget.onActiveHeadingChanged!(node);
  }

  MarkdownOutlineNode? _findNodeById(String id) {
    for (final n in _flatOutline) {
      if (n.elementId == id) return n;
    }
    return null;
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  Future<void> _save() async {
    widget.onInteraction();
    final l10n = AppLocalizations.of(context)!;
    final t = context.tibpiColors;
    final text = _editCtrl.text;

    try {
      await File(widget.book.filePath).writeAsString(text);
      if (!mounted) return;
      setState(() {
        _source = text;
        _originalSource = text;
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
    Clipboard.setData(ClipboardData(text: _source));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  static String _toHexJs(Color c) {
    final rgb = c.toARGB32() & 0xFFFFFF;
    return '#${rgb.toRadixString(16).padLeft(6, '0')}';
  }

  ({List<MarkdownOutlineNode> flat, List<MarkdownOutlineNode> tree})
  _buildOutline(List<MarkdownHeadingEntry> headings) {
    final flat = headings.map((h) {
      final totalLines = _source.split('\n').length;
      final progress = totalLines > 0 ? h.lineNumber / totalLines : 0.0;
      return MarkdownOutlineNode(
        title: h.text,
        scrollProgress: progress,
        lineNumber: h.lineNumber,
        level: h.level,
        elementId: h.id,
      );
    }).toList();

    final tree = <MarkdownOutlineNode>[];
    final stack = <MarkdownOutlineNode>[];
    for (final node in flat) {
      while (stack.isNotEmpty && stack.last.level >= node.level) {
        stack.removeLast();
      }
      if (stack.isEmpty) {
        tree.add(node);
      } else {
        stack.last.children.add(node);
      }
      stack.add(node);
    }
    return (flat: flat, tree: tree);
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    widget.onInteraction();
    final t = context.tibpiColors;
    final l10n = AppLocalizations.of(context)!;
    final bg = widget.settings.backgroundColor;

    if (_isLoading) return _LoadingSkeleton(bg: bg, t: t);
    if (_error != null) {
      return _ErrorView(
        bg: bg,
        message: _error!,
        t: t,
        onRetry: _loadAssetsAndFile,
      );
    }
    if (_isEmpty) return _EmptyView(bg: bg, t: t);

    final bool hasUnsavedChanges = _editCtrl.text != _originalSource;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header with Preview/Edit tabs
            _MdHeader(
              settings: widget.settings,
              book: widget.book,
              tabController: _tabCtrl,
              hasUnsavedChanges: hasUnsavedChanges,
              isEditMode: _mode == _MdMode.edit,
              t: t,
              l10n: l10n,
              onSave: _save,
              onCopyAll: _copyAll,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabCtrl,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // Tab 0: Preview (WebView)
                  NotificationListener<ScrollNotification>(
                    onNotification: (n) {
                      widget.onInteraction();
                      return false;
                    },
                    child: WebViewWidget(controller: _webCtrl),
                  ),
                  // Tab 1: Source Editor
                  MdEditorView(
                    settings: widget.settings,
                    scrollController: _editorScrollCtrl,
                    textController: _editCtrl,
                    onInteraction: widget.onInteraction,
                    onChanged: (val) => setState(() => _source = val),
                    katexJs: _katexJs,
                    katexCss: _katexCss,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Inline Header ────────────────────────────────────────────────────────────

class _MdHeader extends StatelessWidget {
  final ReaderSettings settings;
  final Book book;
  final TabController tabController;
  final bool hasUnsavedChanges;
  final bool isEditMode;
  final dynamic t;
  final dynamic l10n;
  final VoidCallback onSave;
  final VoidCallback onCopyAll;

  const _MdHeader({
    required this.settings,
    required this.book,
    required this.tabController,
    required this.hasUnsavedChanges,
    required this.isEditMode,
    required this.t,
    required this.l10n,
    required this.onSave,
    required this.onCopyAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: settings.backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: TabBar(
                  controller: tabController,
                  labelColor: t.primary,
                  unselectedLabelColor: settings.secondaryTextColor,
                  indicatorColor: t.primary,
                  indicatorWeight: 2.5,
                  labelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.visibility_outlined, size: 15),
                          const SizedBox(width: 5),
                          Text(l10n.preview as String),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.edit_note_rounded, size: 15),
                          const SizedBox(width: 5),
                          Text(l10n.editSource as String),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (hasUnsavedChanges && isEditMode)
                _Btn(
                  icon: Icons.save_rounded,
                  label: l10n.saveChanges as String,
                  color: t.primary,
                  onTap: onSave,
                ),
              _Btn(
                icon: Icons.copy_all_rounded,
                label: '',
                color: settings.secondaryTextColor,
                onTap: onCopyAll,
              ),
            ],
          ),
          Divider(height: 1, thickness: 1, color: t.borderSubtle),
        ],
      ),
    );
  }
}

class _Btn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _Btn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: color),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Loading Skeleton ─────────────────────────────────────────────────────────

class _LoadingSkeleton extends StatelessWidget {
  final Color bg;
  final dynamic t;

  const _LoadingSkeleton({required this.bg, required this.t});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bg,
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Shimmer(
            width: 220,
            height: 22,
            color: (t.textPrimary as Color).withValues(alpha: 0.10),
          ),
          const SizedBox(height: 20),
          for (int i = 0; i < 3; i++) ...[
            _Shimmer(
              width: double.infinity,
              height: 12,
              color: (t.textPrimary as Color).withValues(alpha: 0.06),
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 20),
          for (int i = 0; i < 8; i++) ...[
            _Shimmer(
              width: double.infinity,
              height: 11,
              color: (t.textPrimary as Color).withValues(alpha: 0.05),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _Shimmer extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const _Shimmer({
    required this.width,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(4),
    ),
  );
}

// ── Error View ────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final Color bg;
  final String message;
  final dynamic t;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.bg,
    required this.message,
    required this.t,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bg,
      padding: const EdgeInsets.all(32),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.code_off_rounded, size: 52, color: t.error as Color),
          const SizedBox(height: 16),
          Text(
            'Failed to render Markdown',
            style: TextStyle(
              color: t.textPrimary as Color,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: t.textSecondary as Color, fontSize: 13),
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

// ── Empty View ────────────────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  final Color bg;
  final dynamic t;
  const _EmptyView({required this.bg, required this.t});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bg,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.article_outlined,
            size: 52,
            color: (t.textSecondary as Color).withValues(alpha: 0.4),
          ),
          const SizedBox(height: 12),
          Text(
            'This Markdown file is empty',
            style: TextStyle(color: t.textSecondary as Color, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
