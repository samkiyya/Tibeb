import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show rootBundle, Clipboard, ClipboardData, TextInputType;
import 'package:path/path.dart' as p;
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/theme/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../models/book_model.dart';
import '../../models/reader_settings_model.dart';

/// A unified, context-aware reader and editor layer for TXT and Markdown files.
///
/// **Key Highlights**:
/// 1. **100% Offline Capability**: Loads syntax highlighters (Highlight.js), markdown
///    parsers (Marked.js), and diagram engines (Mermaid.js) directly from local assets.
/// 2. **Theme Synchronization**: Converts reader settings (typeface, line-height, text size,
///    colors) onto HTML/CSS injection rules so the Markdown content matches selected themes (Black, Cream, Blue, White).
/// 3. **Save-to-Disk Integrity**: Allows modifying and saving Markdown or TXT documents,
///    with live notifications of success/error using localized strings.
class TextMdReaderLayer extends StatefulWidget {
  final Book book;
  final ReaderSettings settings;
  final ValueNotifier<double> scrollProgressNotifier;
  final VoidCallback onToggleControls;
  final VoidCallback onInteraction;

  const TextMdReaderLayer({
    super.key,
    required this.book,
    required this.settings,
    required this.scrollProgressNotifier,
    required this.onToggleControls,
    required this.onInteraction,
  });

  @override
  State<TextMdReaderLayer> createState() => _TextMdReaderLayerState();
}

enum _ReaderMode { preview, source }

class _TextMdReaderLayerState extends State<TextMdReaderLayer>
    with TickerProviderStateMixin {
  // ── State variables ────────────────────────────────────────────────────────
  String _source = '';
  String _originalSource = '';
  bool _isLoading = true;
  String? _error;
  _ReaderMode _mode = _ReaderMode.preview;

  late final TextEditingController _editCtrl;
  late final ScrollController _scrollCtrl;
  late final WebViewController _webCtrl;
  late final TabController _tabCtrl;

  // Cached assets for offline rendering
  String _markedJs = '';
  String _hlJs = '';
  String _mermaidJs = '';
  String _hlDarkCss = '';
  String _hlLightCss = '';

  bool get _isMarkdown =>
      p.extension(widget.book.filePath).toLowerCase() == '.md';
  bool get _hasUnsavedChanges => _source != _originalSource;

  // ── Lifecycles ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _editCtrl = TextEditingController();
    _scrollCtrl = ScrollController();
    _tabCtrl = TabController(length: 2, vsync: this);
    _tabCtrl.addListener(_onTabChanged);

    _initWebView();
    _loadAssetsAndFile();
  }

  @override
  void dispose() {
    _editCtrl.dispose();
    _scrollCtrl.dispose();
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TextMdReaderLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.settings.theme != widget.settings.theme ||
        oldWidget.settings.textSize != widget.settings.textSize ||
        oldWidget.settings.lineHeight != widget.settings.lineHeight ||
        oldWidget.settings.typeface != widget.settings.typeface) {
      if (!_isLoading && _error == null) {
        _renderContent();
      }
    }
  }

  // ── Initializers ───────────────────────────────────────────────────────────

  void _initWebView() {
    _webCtrl = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..addJavaScriptChannel(
        'TibebBridge',
        onMessageReceived: (msg) {
          final val = double.tryParse(msg.message);
          if (val != null) {
            widget.scrollProgressNotifier.value = val;
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            // Restore scroll progress if needed
          },
        ),
      );
  }

  Future<void> _loadAssetsAndFile() async {
    try {
      // 1. Core library assets
      _markedJs = await rootBundle.loadString('assets/marked.min.js');
      _hlJs = await rootBundle.loadString('assets/highlight.min.js');
      _mermaidJs = await rootBundle.loadString('assets/mermaid.min.js');
      _hlDarkCss = await rootBundle.loadString('assets/highlight-dark.min.css');
      _hlLightCss = await rootBundle.loadString(
        'assets/highlight-light.min.css',
      );

      // 2. Load file content
      final file = File(widget.book.filePath);
      if (!await file.exists()) {
        throw Exception('File not found: ${widget.book.filePath}');
      }
      final content = await file.readAsString();

      if (mounted) {
        setState(() {
          _source = content;
          _originalSource = content;
          _editCtrl.text = content;
          _isLoading = false;
        });
        _renderContent();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  // ── Tab / Mode Sync ────────────────────────────────────────────────────────

  void _onTabChanged() {
    if (!_tabCtrl.indexIsChanging) return;
    final targetMode = _tabCtrl.index == 0
        ? _ReaderMode.preview
        : _ReaderMode.source;

    // Save changes to draft string when switching from editor back to preview
    if (targetMode == _ReaderMode.preview && _editCtrl.text != _source) {
      setState(() {
        _source = _editCtrl.text;
      });
      _renderContent();
    }

    if (mounted) {
      setState(() {
        _mode = targetMode;
      });
    }
  }

  // ── Main Content Renderers ──────────────────────────────────────────────────

  void _renderContent() {
    if (_isMarkdown) {
      final html = _buildHtml(_source);
      _webCtrl.loadHtmlString(html);
    } else {
      // Plain text gets reloaded simply by updating the view tree
      setState(() {});
    }
  }

  String _buildHtml(String markdown) {
    // Escape markdown for JS string interpolation
    final escaped = markdown
        .replaceAll('\\', '\\\\')
        .replaceAll('`', '\\`')
        .replaceAll('\$', '\\\$');

    final bgStr = _toHex(widget.settings.backgroundColor);
    final fgStr = _toHex(widget.settings.textColor);
    final secFgStr = _toHex(widget.settings.secondaryTextColor);

    // Dynamic styles matching the app theme palette
    final isDark =
        widget.settings.theme == ReaderTheme.darkBlue ||
        widget.settings.theme == ReaderTheme.black;
    final hlCss = isDark ? _hlDarkCss : _hlLightCss;
    final codeBg = isDark ? '#141421' : '#f5f5fa';
    final codeBorder = isDark ? '#2e2e44' : '#e0e0eb';
    final linkColor = isDark ? '#7fa9ff' : '#2f66df';
    final blockquoteBg = isDark ? 'rgba(255,255,255,0.03)' : 'rgba(0,0,0,0.02)';
    final mermaidTheme = isDark ? 'dark' : 'default';

    // Map typeface
    String fontFamilyStr =
        '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif';
    if (widget.settings.typeface == 'Merriweather') {
      fontFamilyStr = '"Merriweather", serif';
    } else if (widget.settings.typeface == 'Georgia') {
      fontFamilyStr = 'Georgia, serif';
    } else if (widget.settings.typeface == 'Lexend') {
      fontFamilyStr = '"Lexend", sans-serif';
    }

    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <style>
    $hlCss
  </style>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      background-color: $bgStr;
      color: $fgStr;
      font-family: $fontFamilyStr;
      font-size: ${widget.settings.textSize}px;
      line-height: ${widget.settings.lineHeight};
      padding: 24px 20px 80px;
      word-wrap: break-word;
      -webkit-user-select: text;
      user-select: text;
    }
    
    h1, h2, h3, h4, h5, h6 {
      color: $fgStr;
      margin-top: 1.6em;
      margin-bottom: 0.6em;
      line-height: 1.35;
      font-weight: 700;
    }
    h1 { font-size: 1.6em; border-bottom: 2px solid $linkColor; padding-bottom: 6px; }
    h2 { font-size: 1.35em; border-bottom: 1px solid $codeBorder; padding-bottom: 4px; }
    h3 { font-size: 1.15em; }

    p {
      margin: 1.1em 0;
      text-align: ${widget.settings.alignment == ReaderAlignment.justified ? 'justify' : 'left'};
    }

    a {
      color: $linkColor;
      text-decoration: none;
    }
    a:hover { text-decoration: underline; }

    blockquote {
      margin: 1.5em 0;
      padding: 10px 16px;
      border-left: 4px solid $linkColor;
      background-color: $blockquoteBg;
      color: $secFgStr;
      font-style: italic;
      border-radius: 0 8px 8px 0;
    }

    pre {
      background-color: $codeBg;
      border: 1px solid $codeBorder;
      border-radius: 8px;
      padding: 14px;
      overflow-x: auto;
      margin: 1.4em 0;
    }

    code {
      font-family: "Courier New", Courier, monospace;
      font-size: 0.88em;
    }

    p code, li code {
      background-color: $codeBg;
      border: 1px solid $codeBorder;
      padding: 2px 6px;
      border-radius: 4px;
    }

    ul, ol {
      margin: 1em 0 1em 1.6em;
    }
    li {
      margin: 0.4em 0;
    }

    table {
      width: 100%;
      border-collapse: collapse;
      margin: 1.5em 0;
      overflow: hidden;
      border-radius: 8px;
      border: 1px solid $codeBorder;
    }
    th {
      background-color: $codeBg;
      font-weight: 600;
      padding: 10px 12px;
      text-align: left;
    }
    td {
      padding: 10px 12px;
      border-top: 1px solid $codeBorder;
    }

    hr {
      border: 0;
      height: 1px;
      background-color: $codeBorder;
      margin: 2.2em 0;
    }

    img {
      max-width: 100%;
      border-radius: 8px;
      margin: 1em 0;
    }

    /* Mermaid diagrams container */
    .mermaid {
      text-align: center;
      background-color: $codeBg;
      border: 1px solid $codeBorder;
      border-radius: 8px;
      padding: 16px;
      margin: 1.5em 0;
      overflow-x: auto;
    }
  </style>
  <script>
    $_markedJs
  </script>
  <script>
    $_hlJs
  </script>
  <script>
    $_mermaidJs
  </script>
</head>
<body>
  <div id="content"></div>
  <script>
    // Config Mermaid
    mermaid.initialize({
      startOnLoad: false,
      theme: '$mermaidTheme',
      securityLevel: 'loose',
      flowchart: { useMaxWidth: true, htmlLabels: true }
    });

    // Custom marked renderer for mermaid intercept
    const renderer = new marked.Renderer();
    renderer.code = function(code, lang) {
      if (lang && lang.toLowerCase() === 'mermaid') {
        return '<div class="mermaid">' + code + '</div>';
      }
      return '<pre><code class="language-' + (lang || '') + '">' + code + '</code></pre>';
    };

    marked.setOptions({
      renderer: renderer,
      gfm: true,
      breaks: true,
      headerIds: true
    });

    const raw = `$escaped`;
    document.getElementById('content').innerHTML = marked.parse(raw);

    // Color code syntax
    document.querySelectorAll('pre code').forEach(function(el) {
      hljs.highlightElement(el);
    });

    // Draw Mermaid Flowcharts
    try {
      mermaid.run({ nodes: document.querySelectorAll('.mermaid') });
    } catch(e) {
      console.error(e);
    }

    // Scroll reporting
    window.addEventListener('scroll', function() {
      const scrollHeight = document.documentElement.scrollHeight - window.innerHeight;
      const progress = scrollHeight > 0 ? (window.scrollY / scrollHeight) : 0.0;
      TibebBridge.postMessage(String(progress));
    });
  </script>
</body>
</html>
''';
  }

  String _toHex(Color c) {
    final rgb = c.toARGB32() & 0xFFFFFF;
    return '#${rgb.toRadixString(16).padLeft(6, '0')}';
  }

  // ── Disk Operations ────────────────────────────────────────────────────────

  Future<void> _save() async {
    widget.onInteraction();
    final l10n = AppLocalizations.of(context)!;
    final textToSave = _editCtrl.text;
    try {
      final file = File(widget.book.filePath);
      await file.writeAsString(textToSave);
      setState(() {
        _source = textToSave;
        _originalSource = textToSave;
      });
      _renderContent();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.savedSuccessfully),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: context.tibpiColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.saveFailed}: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: context.tibpiColors.error,
          ),
        );
      }
    }
  }

  void _copyAll() {
    widget.onInteraction();
    Clipboard.setData(ClipboardData(text: _source));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Saved to clipboard'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // ── Builds ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    widget.onInteraction();
    final t = context.tibpiColors;
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return Container(
        color: widget.settings.backgroundColor,
        child: Center(child: CircularProgressIndicator(color: t.primary)),
      );
    }

    if (_error != null) {
      return Container(
        color: widget.settings.backgroundColor,
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded, size: 48, color: t.error),
              const SizedBox(height: 16),
              Text(
                _error!,
                style: TextStyle(
                  color: widget.settings.textColor,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: widget.settings.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Floating control tab header
            if (_isMarkdown)
              _buildMarkdownHeader(t, l10n)
            else
              _buildTxtHeader(t, l10n),

            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (notif) {
                  widget.onInteraction();
                  if (!_isMarkdown && notif is ScrollUpdateNotification) {
                    final max = _scrollCtrl.position.maxScrollExtent;
                    final current = _scrollCtrl.position.pixels;
                    final progress = max > 0 ? (current / max) : 0.0;
                    widget.scrollProgressNotifier.value = progress;
                  }
                  return false;
                },
                child: _isMarkdown
                    ? _buildMarkdownWidget()
                    : _buildTxtWidget(t, l10n),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header builders ────────────────────────────────────────────────────────

  Widget _buildMarkdownHeader(TibebThemeExtension t, AppLocalizations l10n) {
    return Container(
      color: widget.settings.backgroundColor,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TabBar(
                  controller: _tabCtrl,
                  labelColor: t.primary,
                  unselectedLabelColor: widget.settings.secondaryTextColor,
                  indicatorColor: t.primary,
                  indicatorWeight: 2,
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.visibility_outlined, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            l10n.preview,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.edit_note_rounded, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            l10n.editSource,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (_hasUnsavedChanges && _mode == _ReaderMode.source)
                _controlButton(
                  icon: Icons.save_rounded,
                  label: l10n.saveChanges,
                  color: t.primary,
                  onTap: _save,
                ),
              _controlButton(
                icon: Icons.copy_all_rounded,
                label: '',
                color: widget.settings.secondaryTextColor,
                onTap: _copyAll,
              ),
            ],
          ),
          Divider(height: 1, color: t.borderSubtle),
        ],
      ),
    );
  }

  Widget _buildTxtHeader(TibebThemeExtension t, AppLocalizations l10n) {
    return Container(
      color: widget.settings.backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.text_fields_outlined,
                size: 18,
                color: widget.settings.secondaryTextColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  p.basename(widget.book.filePath),
                  style: TextStyle(
                    color: widget.settings.secondaryTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (_hasUnsavedChanges)
                _controlButton(
                  icon: Icons.save_rounded,
                  label: l10n.saveChanges,
                  color: t.primary,
                  onTap: _save,
                ),
              _controlButton(
                icon: Icons.copy_all_rounded,
                label: '',
                color: widget.settings.secondaryTextColor,
                onTap: _copyAll,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(height: 1, color: t.borderSubtle),
        ],
      ),
    );
  }

  // ── Content area builders ──────────────────────────────────────────────────

  Widget _buildMarkdownWidget() {
    return TabBarView(
      controller: _tabCtrl,
      physics:
          const NeverScrollableScrollPhysics(), // tab change only via header clicks
      children: [
        WebViewWidget(controller: _webCtrl),
        _buildEditorWidget(),
      ],
    );
  }

  Widget _buildTxtWidget(TibebThemeExtension t, AppLocalizations l10n) {
    return _buildEditorWidget();
  }

  Widget _buildEditorWidget() {
    return Container(
      color: widget.settings.backgroundColor,
      child: SingleChildScrollView(
        controller: _scrollCtrl,
        padding: const EdgeInsets.all(18),
        child: TextField(
          controller: _editCtrl,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          style: TextStyle(
            color: widget.settings.textColor,
            fontSize: widget.settings.textSize - 2,
            fontFamily: widget.settings.typeface == 'System' ? null : 'Courier',
            height: widget.settings.lineHeight,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            errorMaxLines: 1,
            isDense: true,
          ),
          onChanged: (val) {
            widget.onInteraction();
            setState(() {
              _source = val;
            });
          },
        ),
      ),
    );
  }

  Widget _controlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
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
