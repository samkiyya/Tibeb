import 'package:flutter/material.dart';
import '../../../models/reader_settings_model.dart';
import '../../../core/theme/theme.dart';

/// The Markdown source editor with a rich formatting toolbar.
/// Fully isolated — knows nothing about WebView, preview, or rendering.
class MdEditorView extends StatefulWidget {
  final ReaderSettings settings;
  final ScrollController scrollController;
  final TextEditingController textController;
  final VoidCallback onInteraction;
  final ValueChanged<String> onChanged;

  const MdEditorView({
    super.key,
    required this.settings,
    required this.scrollController,
    required this.textController,
    required this.onInteraction,
    required this.onChanged,
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

  // ── Toolbar Actions ─────────────────────────────────────────────────────

  void _wrapSelection(String prefix, String suffix) {
    widget.onInteraction();
    final ctrl = widget.textController;
    final text = ctrl.text;
    var sel = ctrl.selection;

    // If no valid selection, insert at end
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

    // Find start of current line
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

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;

    return Container(
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
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
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
            // Bold
            _ToolBtn(
              icon: Icons.format_bold_rounded,
              tooltip: 'Bold (** **)',
              color: color,
              onTap: () => _wrapSelection('**', '**'),
            ),
            // Italic
            _ToolBtn(
              icon: Icons.format_italic_rounded,
              tooltip: 'Italic (* *)',
              color: color,
              onTap: () => _wrapSelection('*', '*'),
            ),
            // Strikethrough
            _ToolBtn(
              icon: Icons.strikethrough_s_rounded,
              tooltip: 'Strikethrough (~~ ~~)',
              color: color,
              onTap: () => _wrapSelection('~~', '~~'),
            ),

            _Divider(color: divColor),

            // H1–H3
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

            // Lists
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

            _Divider(color: divColor),

            // Link + Image
            _ToolBtn(
              icon: Icons.link_rounded,
              tooltip: 'Insert Link',
              color: color,
              onTap: () => _wrapSelection('[', '](url)'),
            ),
            _ToolBtn(
              icon: Icons.image_outlined,
              tooltip: 'Insert Image',
              color: color,
              onTap: () => _wrapSelection('![alt](', ')'),
            ),

            _Divider(color: divColor),

            // Code
            _ToolBtn(
              icon: Icons.code_rounded,
              tooltip: 'Code Block',
              color: color,
              onTap: () => _wrapSelection('```\n', '\n```'),
            ),
            _ToolBtn(
              icon: Icons.data_object_rounded,
              tooltip: 'Inline Code',
              color: color,
              onTap: () => _wrapSelection('`', '`'),
            ),

            _Divider(color: divColor),

            // Blockquote
            _ToolBtn(
              icon: Icons.format_quote_rounded,
              tooltip: 'Blockquote',
              color: color,
              onTap: () => _insertAtLineStart('> '),
            ),
            // Math
            _ToolBtn(
              icon: Icons.functions_rounded,
              tooltip: 'Math (KaTeX)',
              color: color,
              onTap: () => _wrapSelection(r'$', r'$'),
            ),
            // HR
            _ToolBtn(
              icon: Icons.horizontal_rule_rounded,
              tooltip: 'Horizontal Rule',
              color: color,
              onTap: () => _insertAtLineStart('---'),
            ),
          ],
        ),
      ),
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
