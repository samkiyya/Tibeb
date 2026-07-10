import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../models/reader_settings_model.dart';
import '../../../core/theme/theme.dart';

/// The Markdown source editor with a premium interactive formatting toolbar,
/// inline math live WebView previewer, table generator, Mermaid diagram templates,
/// and shortcut bindings for professional writing.
class MdEditorView extends StatefulWidget {
  final ReaderSettings settings;
  final ScrollController scrollController;
  final TextEditingController textController;
  final VoidCallback onInteraction;
  final ValueChanged<String> onChanged;
  final String katexJs;
  final String katexCss;

  const MdEditorView({
    super.key,
    required this.settings,
    required this.scrollController,
    required this.textController,
    required this.onInteraction,
    required this.onChanged,
    this.katexJs = '',
    this.katexCss = '',
  });

  @override
  State<MdEditorView> createState() => _MdEditorViewState();
}

class _MdEditorViewState extends State<MdEditorView> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  // ── Toolbar & Shortcut Actions ─────────────────────────────────────────────

  void _wrapSelection(String prefix, String suffix) {
    widget.onInteraction();
    final ctrl = widget.textController;
    final text = ctrl.text;
    var sel = ctrl.selection;

    final start = sel.start.clamp(0, text.length);
    final end = sel.end.clamp(0, text.length);

    final selected = text.substring(start, end);
    final newText = text.replaceRange(start, end, '$prefix$selected$suffix');

    final cursorPos = start == end
        ? start + prefix.length
        : start + prefix.length + selected.length + suffix.length;

    ctrl.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: cursorPos),
    );
    widget.onChanged(newText);
    _focusNode.requestFocus();
  }

  void _insertAtLineStart(String prefix) {
    widget.onInteraction();
    final ctrl = widget.textController;
    final text = ctrl.text;
    final sel = ctrl.selection;
    final pos = sel.baseOffset.clamp(0, text.length);

    int lineStart = text.lastIndexOf('\n', pos - 1);
    lineStart = lineStart < 0 ? 0 : lineStart + 1;

    final before = text.substring(0, lineStart);
    final after = text.substring(lineStart);

    final newText = '$before$prefix$after';
    ctrl.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: pos + prefix.length),
    );
    widget.onChanged(newText);
    _focusNode.requestFocus();
  }

  void _insertText(String snippet) {
    widget.onInteraction();
    final ctrl = widget.textController;
    final text = ctrl.text;
    final sel = ctrl.selection;
    final start = sel.start.clamp(0, text.length);
    final end = sel.end.clamp(0, text.length);

    final newText = text.replaceRange(start, end, snippet);
    ctrl.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: start + snippet.length),
    );
    widget.onChanged(newText);
    _focusNode.requestFocus();
  }

  // ── Dialog Windows ────────────────────────────────────────────────────────

  void _showLinkImageDialog(bool isImage) {
    widget.onInteraction();
    final title = isImage ? 'Insert Image' : 'Insert Link';
    final labelText = isImage ? 'Image Alt Text' : 'Link Text';
    final urlText = isImage ? 'Image URL (or filepath)' : 'Link URL';

    final textCtrl = TextEditingController();
    final urlCtrl = TextEditingController();

    // Autofill text selection if any
    final text = widget.textController.text;
    final sel = widget.textController.selection;
    if (sel.isValid && sel.start != sel.end) {
      textCtrl.text = text.substring(sel.start, sel.end);
    }

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        final t = context.tibpiColors;
        return AlertDialog(
          backgroundColor: Theme.of(ctx).colorScheme.surface,
          title: Text(title, style: TextStyle(color: t.accent)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textCtrl,
                decoration: InputDecoration(labelText: labelText),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: urlCtrl,
                decoration: InputDecoration(
                  labelText: urlText,
                  hintText: isImage
                      ? 'images/cover.jpg'
                      : 'https://example.com',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final label = textCtrl.text.isNotEmpty ? textCtrl.text : 'text';
                final url = urlCtrl.text.isNotEmpty ? urlCtrl.text : 'url';
                Navigator.pop(ctx);
                if (isImage) {
                  _insertText('![$label]($url)');
                } else {
                  _insertText('[$label]($url)');
                }
              },
              child: const Text('Insert'),
            ),
          ],
        );
      },
    );
  }

  void _showTableDialog() {
    widget.onInteraction();
    int rows = 3;
    int cols = 3;

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        final t = context.tibpiColors;
        return StatefulBuilder(
          builder: (BuildContext innerCtx, StateSetter setModalState) {
            return AlertDialog(
              backgroundColor: Theme.of(innerCtx).colorScheme.surface,
              title: Text('Insert Table', style: TextStyle(color: t.accent)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Rows: $rows'),
                  Slider(
                    value: rows.toDouble(),
                    min: 2,
                    max: 10,
                    divisions: 8,
                    onChanged: (val) => setModalState(() => rows = val.toInt()),
                  ),
                  const SizedBox(height: 12),
                  Text('Columns: $cols'),
                  Slider(
                    value: cols.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    onChanged: (val) => setModalState(() => cols = val.toInt()),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    // Generate GFM Table template
                    final buffer = StringBuffer();
                    // Header row
                    buffer.write('\n');
                    for (int c = 1; c <= cols; c++) {
                      buffer.write('| Header $c ');
                    }
                    buffer.write('|\n');
                    // Separator row
                    for (int c = 1; c <= cols; c++) {
                      buffer.write('|---');
                    }
                    buffer.write('|\n');
                    // Data rows
                    for (int r = 1; r <= rows - 1; r++) {
                      for (int c = 1; c <= cols; c++) {
                        buffer.write('| Cell ');
                      }
                      buffer.write('|\n');
                    }
                    buffer.write('\n');
                    _insertText(buffer.toString());
                  },
                  child: const Text('Generate Table'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showMermaidDialog() {
    widget.onInteraction();
    final templates = {
      'Flowchart':
          'graph TD\n  A[Start] --> B(Process)\n  B --> C{Decision}\n  C -->|Yes| D[Result 1]\n  C -->|No| E[Result 2]',
      'Sequence Chart':
          'sequenceDiagram\n  Alice->>Bob: Hello Bob, how are you?\n  Bob-->>Alice: Jolly good!',
      'Class Diagram':
          'classDiagram\n  Animal <|-- Duck\n  Animal <|-- Fish\n  Animal : +int age\n  Animal: +isMammal()\n  class Duck{\n    +String beakColor\n    +swim()\n  }',
      'Entity Relationship':
          'erDiagram\n  CUSTOMER ||--o{ ORDER : places\n  ORDER ||--|{ LINE-ITEM : contains\n  CUSTOMER { \n    string name\n    string email\n  }',
      'Gantt Chart':
          'gantt\n  title A Gantt Diagram\n  dateFormat YYYY-MM-DD\n  section Section\n  A task :a1, 2026-07-10, 30d\n  Another task :after a1, 20d',
    };

    String selectedType = 'Flowchart';

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        final t = context.tibpiColors;
        return StatefulBuilder(
          builder: (BuildContext innerCtx, StateSetter setModalState) {
            return AlertDialog(
              backgroundColor: Theme.of(innerCtx).colorScheme.surface,
              title: Text(
                'Insert Mermaid Diagram',
                style: TextStyle(color: t.accent),
              ),
              content: DropdownButton<String>(
                value: selectedType,
                isExpanded: true,
                onChanged: (val) {
                  if (val != null) {
                    setModalState(() => selectedType = val);
                  }
                },
                items: templates.keys.map((String key) {
                  return DropdownMenuItem<String>(value: key, child: Text(key));
                }).toList(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    final template = templates[selectedType];
                    _insertText('\n```mermaid\n$template\n```\n');
                  },
                  child: const Text('Insert Template'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showMathDialog() {
    widget.onInteraction();
    final mathCtrl = TextEditingController();
    bool isBlock = false;

    // Prefill with current selected text if any
    final text = widget.textController.text;
    final sel = widget.textController.selection;
    if (sel.isValid && sel.start != sel.end) {
      mathCtrl.text = text.substring(sel.start, sel.end);
    }

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        final t = context.tibpiColors;
        return StatefulBuilder(
          builder: (BuildContext innerCtx, StateSetter setModalState) {
            return _MathDialogContent(
              title: 'Insert Math (KaTeX)',
              mathCtrl: mathCtrl,
              isBlock: isBlock,
              katexJs: widget.katexJs,
              katexCss: widget.katexCss,
              settings: widget.settings,
              accentColor: t.accent,
              onToggleBlock: (val) => setModalState(() => isBlock = val),
              onInsert: (formula) {
                Navigator.pop(ctx);
                if (isBlock) {
                  _insertText('\n\$\$\n$formula\n\$\$\n');
                } else {
                  _insertText('\$$formula\$');
                }
              },
            );
          },
        );
      },
    );
  }

  // ── Build UI Layout ────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;

    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.keyB, control: true): () =>
            _wrapSelection('**', '**'),
        const SingleActivator(LogicalKeyboardKey.keyI, control: true): () =>
            _wrapSelection('*', '*'),
        const SingleActivator(LogicalKeyboardKey.keyK, control: true): () =>
            _showLinkImageDialog(false),
        const SingleActivator(LogicalKeyboardKey.keyM, control: true): () =>
            _showMathDialog(),
      },
      child: Container(
        color: widget.settings.backgroundColor,
        child: Column(
          children: [
            _buildToolbar(context, t),
            Expanded(
              child: SingleChildScrollView(
                controller: widget.scrollController,
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 80),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    textSelectionTheme: TextSelectionThemeData(
                      cursorColor: widget.settings.textColor,
                      selectionColor: widget.settings.textColor.withValues(
                        alpha: 0.22,
                      ),
                      selectionHandleColor: widget.settings.textColor,
                    ),
                    scaffoldBackgroundColor: widget.settings.backgroundColor,
                  ),
                  child: TextField(
                    controller: widget.textController,
                    focusNode: _focusNode,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    cursorColor: widget.settings.textColor,
                    style: TextStyle(
                      color: widget.settings.textColor,
                      fontSize: widget.settings.textSize - 2,
                      fontFamily: 'monospace',
                      height: widget.settings.lineHeight,
                      letterSpacing: 0.2,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      fillColor: widget.settings.backgroundColor,
                      filled: true,
                    ),
                    onChanged: (val) {
                      widget.onInteraction();
                      widget.onChanged(val);
                    },
                    onTap: widget.onInteraction,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbar(BuildContext context, dynamic t) {
    final color = widget.settings.textColor;
    final borderColor = widget.settings.textColor.withValues(alpha: 0.08);
    final divColor = widget.settings.textColor.withValues(alpha: 0.12);

    return Container(
      decoration: BoxDecoration(
        color: widget.settings.backgroundColor,
        border: Border(bottom: BorderSide(color: borderColor, width: 1)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Formatting
            _ToolBtn(
              icon: Icons.format_bold_rounded,
              tooltip: 'Bold (Ctrl+B / ** **)',
              color: color,
              onTap: () => _wrapSelection('**', '**'),
            ),
            _ToolBtn(
              icon: Icons.format_italic_rounded,
              tooltip: 'Italic (Ctrl+I / * *)',
              color: color,
              onTap: () => _wrapSelection('*', '*'),
            ),
            _ToolBtn(
              icon: Icons.strikethrough_s_rounded,
              tooltip: 'Strikethrough (~~ ~~)',
              color: color,
              onTap: () => _wrapSelection('~~', '~~'),
            ),

            _Divider(color: divColor),

            // Headings
            _ToolBtn(
              icon: Icons.looks_one_rounded,
              tooltip: 'Heading 1',
              color: color,
              onTap: () => _insertAtLineStart('# '),
            ),
            _ToolBtn(
              icon: Icons.looks_two_rounded,
              tooltip: 'Heading 2',
              color: color,
              onTap: () => _insertAtLineStart('## '),
            ),
            _ToolBtn(
              icon: Icons.looks_3_rounded,
              tooltip: 'Heading 3',
              color: color,
              onTap: () => _insertAtLineStart('### '),
            ),

            _Divider(color: divColor),

            // Lists & Structures
            _ToolBtn(
              icon: Icons.format_list_bulleted_rounded,
              tooltip: 'Bullet List',
              color: color,
              onTap: () => _insertAtLineStart('- '),
            ),
            _ToolBtn(
              icon: Icons.format_list_numbered_rounded,
              tooltip: 'Numbered List',
              color: color,
              onTap: () => _insertAtLineStart('1. '),
            ),
            _ToolBtn(
              icon: Icons.check_box_outline_blank_rounded,
              tooltip: 'Task List',
              color: color,
              onTap: () => _insertAtLineStart('- [ ] '),
            ),
            _ToolBtn(
              icon: Icons.format_quote_rounded,
              tooltip: 'Blockquote',
              color: color,
              onTap: () => _insertAtLineStart('> '),
            ),

            _Divider(color: divColor),

            // Links / Images / Tables / Mermaid Dialogs
            _ToolBtn(
              icon: Icons.link_rounded,
              tooltip: 'Insert Link (Ctrl+K)',
              color: color,
              onTap: () => _showLinkImageDialog(false),
            ),
            _ToolBtn(
              icon: Icons.image_outlined,
              tooltip: 'Insert Image',
              color: color,
              onTap: () => _showLinkImageDialog(true),
            ),
            _ToolBtn(
              icon: Icons.table_chart_outlined,
              tooltip: 'Insert Markdown Table',
              color: color,
              onTap: _showTableDialog,
            ),
            _ToolBtn(
              icon: Icons.bubble_chart_outlined,
              tooltip: 'Insert Mermaid Diagram Template',
              color: color,
              onTap: _showMermaidDialog,
            ),

            _Divider(color: divColor),

            // Inline Code / Blocks / HR / Math
            _ToolBtn(
              icon: Icons.code_rounded,
              tooltip: 'Fenced Code Block',
              color: color,
              onTap: () => _wrapSelection('```\n', '\n```'),
            ),
            _ToolBtn(
              icon: Icons.data_object_rounded,
              tooltip: 'Inline Code',
              color: color,
              onTap: () => _wrapSelection('`', '`'),
            ),
            _ToolBtn(
              icon: Icons.horizontal_rule_rounded,
              tooltip: 'Horizontal Rule (---)',
              color: color,
              onTap: () => _insertAtLineStart('---'),
            ),
            _ToolBtn(
              icon: Icons.functions_rounded,
              tooltip: 'KaTeX Formula Dialog (Ctrl+M)',
              color: color,
              onTap: _showMathDialog,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Inside-Dialog Live Math Previewer Widget ────────────────────────────────

class _MathDialogContent extends StatefulWidget {
  final String title;
  final TextEditingController mathCtrl;
  final bool isBlock;
  final String katexJs;
  final String katexCss;
  final ReaderSettings settings;
  final Color accentColor;
  final ValueChanged<bool> onToggleBlock;
  final ValueChanged<String> onInsert;

  const _MathDialogContent({
    required this.title,
    required this.mathCtrl,
    required this.isBlock,
    required this.katexJs,
    required this.katexCss,
    required this.settings,
    required this.accentColor,
    required this.onToggleBlock,
    required this.onInsert,
  });

  @override
  State<_MathDialogContent> createState() => _MathDialogContentState();
}

class _MathDialogContentState extends State<_MathDialogContent> {
  late final WebViewController _previewWebCtrl;
  bool _webReady = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    // Patch relative font paths to CDN inside dialog previewer too
    final cdnCss = widget.katexCss;
    // .replaceAll(
    //   'url(fonts/',
    //   'url(https://cdn.jsdelivr.net/npm/katex@0.16.11/dist/fonts/',
    // );

    _previewWebCtrl = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (!mounted) return;
            setState(() => _webReady = true);
            _updatePreview();
          },
        ),
      );

    // Initial HTML setup with empty math container, KaTeX styles & scripts
    final isDark =
        widget.settings.theme == ReaderTheme.darkBlue ||
        widget.settings.theme == ReaderTheme.black;
    final bg = isDark ? '#1a1a24' : '#fafafa';
    final fg = isDark ? '#eaeaea' : '#111111';

    final htmlShell =
        '''
<!DOCTYPE html>
<html>
<head>
  <style>
    body {
      background: $bg;
      color: $fg;
      font-family: sans-serif;
      padding: 12px;
      margin: 0;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      overflow: hidden;
      font-size: 1.1em;
    }
    .preview-box { text-align: center; width: 100%; word-wrap: break-word; overflow-x: auto; }
    .katex-display { margin: 0; padding: 4px 0; }
  </style>
  <style>$cdnCss</style>
  <script>${widget.katexJs}</script>
</head>
<body>
  <div class="preview-box" id="preview">Enter KaTeX LaTeX syntax to preview</div>
  <script>
    function renderMath(latexString, isBlockMode) {
      const el = document.getElementById('preview');
      if (!latexString.trim()) {
        el.innerText = 'Enter KaTeX LaTeX syntax to preview';
        return;
      }
      try {
        el.innerHTML = katex.renderToString(latexString, {
          displayMode: isBlockMode,
          throwOnError: false,
          output: 'html',
          trust: true,
          strict: false
        });
      } catch (err) {
        el.innerText = 'Error: ' + err.message;
      }
    }
  </script>
</body>
</html>
''';

    _previewWebCtrl.loadHtmlString(htmlShell, baseUrl: 'about:blank');
    widget.mathCtrl.addListener(_onMathInputChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    widget.mathCtrl.removeListener(_onMathInputChanged);
    super.dispose();
  }

  void _onMathInputChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 250), () {
      _updatePreview();
    });
  }

  void _updatePreview() {
    if (!_webReady || !mounted) return;
    final escaped = widget.mathCtrl.text
        .replaceAll('\\', '\\\\')
        .replaceAll('\'', '\\\'')
        .replaceAll('\n', '\\n');
    _previewWebCtrl.runJavaScript(
      'renderMath(\'$escaped\', ${widget.isBlock});',
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Text(widget.title, style: TextStyle(color: widget.accentColor)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: widget.mathCtrl,
              maxLines: 3,
              autofocus: true,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
              decoration: const InputDecoration(
                labelText: 'LaTeX Command',
                hintText:
                    '\\mathbf{A} = \\begin{pmatrix} a & b \\\\ c & d \\end{pmatrix}',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              onChanged: (_) => _updatePreview(),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Display Mode (Block Math)'),
                Switch(
                  value: widget.isBlock,
                  onChanged: (val) {
                    widget.onToggleBlock(val);
                    // Force rebuild/update preview with new mode
                    Future.delayed(Duration.zero, _updatePreview);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Live Preview:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 6),
            Container(
              height: 110,
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(6),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: WebViewWidget(controller: _previewWebCtrl),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => widget.onInsert(widget.mathCtrl.text),
          child: const Text('Insert Math'),
        ),
      ],
    );
  }
}

// ── Toolbar Atom Widgets ────────────────────────────────────────────────────

class _ToolBtn extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback onTap;

  const _ToolBtn({
    required this.icon,
    required this.tooltip,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
            child: Icon(icon, size: 20, color: color.withValues(alpha: 0.8)),
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  final Color color;
  const _Divider({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 18,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: color,
    );
  }
}
