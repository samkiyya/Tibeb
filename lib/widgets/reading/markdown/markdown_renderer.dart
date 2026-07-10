import 'dart:convert' show utf8;
import 'package:crypto/crypto.dart' show md5;
import 'package:markdown/markdown.dart' as md;

// ── Emoji table (top-120 frequently used) ──────────────────────────────────
const Map<String, String> _kEmojiMap = {
  'smile': '😄',
  'laughing': '😆',
  'blush': '😊',
  'heart_eyes': '😍',
  'kissing_heart': '😘',
  'flushed': '😳',
  'relieved': '😌',
  'satisfied': '😆',
  'grin': '😁',
  'wink': '😉',
  'stuck_out_tongue': '😛',
  'sleepy': '😪',
  'rage': '😡',
  'cry': '😢',
  'sob': '😭',
  'anxious': '😟',
  'heart': '❤️',
  'broken_heart': '💔',
  'fire': '🔥',
  'star': '⭐',
  'sparkles': '✨',
  'tada': '🎉',
  'rocket': '🚀',
  'zap': '⚡',
  'boom': '💥',
  'muscle': '💪',
  'point_up': '☝️',
  'thumbsup': '+1',
  '+1': '👍',
  '-1': '👎',
  'clap': '👏',
  'pray': '🙏',
  'wave': '👋',
  'ok_hand': '👌',
  'raised_hands': '🙌',
  'eyes': '👀',
  'bulb': '💡',
  'warning': '⚠️',
  'white_check_mark': '✅',
  'x': '❌',
  'no_entry': '🚫',
  'lock': '🔒',
  'key': '🔑',
  'link': '🔗',
  'paperclip': '📎',
  'pushpin': '📌',
  'bookmark': '🔖',
  'calendar': '📅',
  'clipboard': '📋',
  'pencil': '✏️',
  'memo': '📝',
  'books': '📚',
  'book': '📖',
  'scroll': '📜',
  'file_folder': '📁',
  'email': '📧',
  'bell': '🔔',
  'speech_balloon': '💬',
  'question': '❓',
  'exclamation': '❗',
  'construction': '🚧',
  'checkered_flag': '🏁',
  'globe_with_meridians': '🌐',
  'computer': '💻',
  'iphone': '📱',
  'trophy': '🏆',
  'medal': '🥇',
  'dart': '🎯',
  'game_die': '🎲',
  'art': '🎨',
  'musical_note': '🎵',
  'headphones': '🎧',
  'microphone': '🎤',
  'camera': '📷',
  'movie_camera': '🎥',
  'tv': '📺',
  'radio': '📻',
  'bar_chart': '📊',
  'chart_with_upwards_trend': '📈',
  'chart_with_downwards_trend': '📉',
  'moneybag': '💰',
  'credit_card': '💳',
  'gift': '🎁',
  'shopping_cart': '🛒',
  'package': '📦',
  'mailbox': '📫',
  'hammer': '🔨',
  'wrench': '🔧',
  'gear': '⚙️',
  'electric_plug': '🔌',
  'bulb_cfl': '💡',
  'battery': '🔋',
  'satellite': '📡',
  'shield': '🛡️',
  'thumbs_up': '👍',
  'thumbs_down': '👎',
  'hand': '✋',
  'snowflake': '❄️',
  'sun': '☀️',
  'cloud': '☁️',
  'umbrella': '☂️',
  'rainbow': '🌈',
  'leaf': '🍃',
  'tree': '🌲',
  'rose': '🌹',
  'pizza': '🍕',
  'hamburger': '🍔',
  'coffee': '☕',
  'tada2': '🎊',
  'thinking': '🤔',
  'nerd': '🤓',
  'sunglasses': '😎',
  'robot': '🤖',
  'ghost': '👻',
  'skull': '💀',
  'alien': '👽',
  'cat': '🐱',
  'dog': '🐶',
  'fox': '🦊',
  'wolf': '🐺',
  'horse': '🐴',
  'elephant': '🐘',
  'fish': '🐟',
  'bird': '🐦',
  'eagle': '🦅',
  'butterfly': '🦋',
  'bee': '🐝',
  'ant': '🐜',
  'microbe': '🦠',
  'apple': '🍎',
  'lemon': '🍋',
  'grapes': '🍇',
  'strawberry': '🍓',
};

// ── Emoji InlineSyntax ─────────────────────────────────────────────────────

class _EmojiSyntax extends md.InlineSyntax {
  _EmojiSyntax() : super(r':([a-z0-9_+\-]+):');

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final name = match.group(1)!;
    final emoji = _kEmojiMap[name];
    if (emoji == null) {
      parser.addNode(md.Text(match.group(0)!));
      return true;
    }
    parser.addNode(md.Text(emoji));
    return true;
  }
}

// ── Admonition BlockSyntax ─────────────────────────────────────────────────
// Transforms > [!NOTE] / > [!WARNING] etc. into styled callout HTML

final _admonitionPattern = RegExp(
  r'^> \[!(NOTE|TIP|WARNING|IMPORTANT|CAUTION)\]\s*(.*)',
  caseSensitive: false,
);

class _AdmonitionSyntax extends md.BlockSyntax {
  static const Map<String, Map<String, String>> _meta = {
    'NOTE': {'icon': 'ℹ️', 'cssClass': 'admonition-note', 'label': 'Note'},
    'TIP': {'icon': '💡', 'cssClass': 'admonition-tip', 'label': 'Tip'},
    'WARNING': {
      'icon': '⚠️',
      'cssClass': 'admonition-warning',
      'label': 'Warning',
    },
    'IMPORTANT': {
      'icon': '❗',
      'cssClass': 'admonition-important',
      'label': 'Important',
    },
    'CAUTION': {
      'icon': '🔥',
      'cssClass': 'admonition-caution',
      'label': 'Caution',
    },
  };

  @override
  RegExp get pattern => RegExp(r'^> \[!(NOTE|TIP|WARNING|IMPORTANT|CAUTION)');

  @override
  md.Node? parse(md.BlockParser parser) {
    final lines = <String>[];
    String type = 'NOTE';
    String? firstLineRemainder;

    while (!parser.isDone) {
      final line = parser.current.content;
      final admonitionMatch = _admonitionPattern.firstMatch(line);
      if (admonitionMatch != null) {
        type = admonitionMatch.group(1)!.toUpperCase();
        firstLineRemainder = admonitionMatch.group(2);
        parser.advance();
        continue;
      }
      if (line.startsWith('> ')) {
        lines.add(line.substring(2));
        parser.advance();
        continue;
      }
      if (line.startsWith('>')) {
        lines.add(line.substring(1));
        parser.advance();
        continue;
      }
      break;
    }

    final meta = _meta[type] ?? _meta['NOTE']!;
    final content = [
      if (firstLineRemainder != null && firstLineRemainder.isNotEmpty)
        firstLineRemainder,
      ...lines,
    ].join('\n');

    return md.UnparsedContent(
      '<div class="admonition ${meta['cssClass']}">'
      '<div class="admonition-title">'
      '<span class="admonition-icon">${meta['icon']}</span>'
      ' ${meta['label']}'
      '</div>'
      '<div class="admonition-body">${_escapeHtml(content)}</div>'
      '</div>',
    );
  }
}

String _escapeHtml(String text) {
  return text
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;');
}

// ── Math InlineSyntax ─────────────────────────────────────────────────────

class _InlineMathSyntax extends md.InlineSyntax {
  _InlineMathSyntax() : super(r'\$([^$\n]+?)\$');

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final math = match.group(1)!;
    final escaped = _htmlAttrEscape(math);
    final body = _escapeHtml(math);
    parser.addNode(
      md.UnparsedContent(
        '<span class="math-inline" data-math="$escaped"><code class="math-src">\$$body\$</code></span>',
      ),
    );
    return true;
  }
}

// ── Math BlockSyntax ($$...$$) ─────────────────────────────────────────────

class _BlockMathSyntax extends md.BlockSyntax {
  @override
  RegExp get pattern => RegExp(r'^\$\$');

  @override
  md.Node? parse(md.BlockParser parser) {
    parser.advance(); // skip $$
    final buffer = StringBuffer();
    while (!parser.isDone) {
      final line = parser.current.content;
      if (line.trim() == r'$$') {
        parser.advance();
        break;
      }
      buffer.writeln(line);
      parser.advance();
    }
    final math = buffer.toString().trim();
    final escaped = _htmlAttrEscape(math);
    final body = _escapeHtml(math);
    return md.UnparsedContent(
      '<div class="math-block" data-math="$escaped">'
      '<pre class="math-src">\$\$$body\$\$</pre>'
      '</div>',
    );
  }
}

String _htmlAttrEscape(String s) => s
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#39;');

// ── GitHub Task List (postprocess HTML) ───────────────────────────────────

String _postProcessTaskLists(String html) {
  return html
      .replaceAllMapped(RegExp(r'<li>\s*\[x\]\s*'), (m) {
        return '<li class="task-list-item checked"><input type="checkbox" disabled checked> ';
      })
      .replaceAllMapped(RegExp(r'<li>\s*\[ \]\s*'), (m) {
        return '<li class="task-list-item"><input type="checkbox" disabled> ';
      });
}

// ── Slug generator ────────────────────────────────────────────────────────

String _toSlug(String text, Map<String, int> seen) {
  final slug = text
      .toLowerCase()
      .replaceAll(RegExp(r'[^\w\s-]'), '')
      .trim()
      .replaceAll(RegExp(r'[\s_-]+'), '-');
  final count = seen[slug] ?? 0;
  seen[slug] = count + 1;
  return count == 0 ? slug : '$slug-$count';
}

// (Heading ID injection done via post-processing in render())

// ── MarkdownOutlineEntry ──────────────────────────────────────────────────

class MarkdownHeadingEntry {
  final String id;
  final String slug;
  final String text;
  final int level;
  final int lineNumber;

  const MarkdownHeadingEntry({
    required this.id,
    required this.slug,
    required this.text,
    required this.level,
    required this.lineNumber,
  });
}

// ── Render Result ─────────────────────────────────────────────────────────

class MarkdownRenderResult {
  final String html;
  final List<MarkdownHeadingEntry> headings;
  final String contentHash;

  const MarkdownRenderResult({
    required this.html,
    required this.headings,
    required this.contentHash,
  });
}

// ── Main MarkdownRenderer ─────────────────────────────────────────────────

class MarkdownRenderer {
  static MarkdownRenderResult? _cache;
  static String? _cachedHash;

  /// Renders Markdown content to HTML. Caches the result and re-renders only
  /// when the content hash changes.
  static MarkdownRenderResult render(String markdown) {
    final hash = md5.convert(utf8.encode(markdown)).toString();
    if (_cachedHash == hash && _cache != null) {
      return _cache!;
    }

    final headings = <MarkdownHeadingEntry>[];
    final slugSeen = <String, int>{};
    int headingIdx = 0;

    // Preprocess: strip YAML frontmatter before rendering
    String source = markdown;
    if (source.startsWith('---')) {
      final end = source.indexOf('\n---', 3);
      if (end != -1) {
        source = source.substring(end + 4).trimLeft();
      }
    }

    // Collect heading metadata from original source lines
    final lines = source.split('\n');
    for (int i = 0; i < lines.length; i++) {
      final m = RegExp(r'^(#{1,6})\s+(.+)$').firstMatch(lines[i]);
      if (m != null) {
        final level = m.group(1)!.length;
        final text = m.group(2)!.trim();
        final slug = _toSlug(text, slugSeen);
        final id = 'md-heading-${headingIdx++}';
        headings.add(
          MarkdownHeadingEntry(
            id: id,
            slug: slug,
            text: text,
            level: level,
            lineNumber: i,
          ),
        );
      }
    }

    // Render HTML via dart:markdown with GFM extensions
    String html = md.markdownToHtml(
      source,
      extensionSet: md.ExtensionSet.gitHubWeb,
      blockSyntaxes: [
        _AdmonitionSyntax(),
        _BlockMathSyntax(),
        const md.TableSyntax(),
        const md.FencedCodeBlockSyntax(),
        const md.FootnoteDefSyntax(),
      ],
      inlineSyntaxes: [
        _EmojiSyntax(),
        _InlineMathSyntax(),
        md.InlineHtmlSyntax(),
        md.AutolinkExtensionSyntax(),
      ],
      inlineOnly: false,
    );

    // Post-process: task lists
    html = _postProcessTaskLists(html);

    // Post-process: inject heading IDs
    int idxR = 0;
    html = html.replaceAllMapped(RegExp(r'<h([1-6])>(.+?)</h\1>', dotAll: true), (
      match,
    ) {
      if (idxR >= headings.length) return match.group(0)!;
      final h = headings[idxR++];
      return '<h${match.group(1)} id="${h.id}" data-slug="${h.slug}">${match.group(2)}</h${match.group(1)}>';
    });

    // Post-process: code blocks — add copy button + language badge, also parse Mermaid blocks
    html = html.replaceAllMapped(
      RegExp(
        r'<pre><code(?: class="language-([^"]*)")?>(.*?)</code></pre>',
        dotAll: true,
      ),
      (match) {
        final lang = match.group(1) ?? '';
        final code = match.group(2) ?? '';

        // If it's a Mermaid-formatted block, output a wrapper without copy button and syntax highlighting
        if (lang.trim().toLowerCase() == 'mermaid') {
          final rawCode = code
              .replaceAll('&amp;', '&')
              .replaceAll('&lt;', '<')
              .replaceAll('&gt;', '>')
              .replaceAll('&quot;', '"')
              .replaceAll('&#39;', "'");
          return '<div class="mermaid">$rawCode</div>';
        }

        final langBadge = lang.isNotEmpty
            ? '<span class="code-lang-badge">$lang</span>'
            : '';
        final copyId =
            'copy-${DateTime.now().microsecondsSinceEpoch}-${match.group(0).hashCode.abs()}';
        return '''<div class="code-block">
$langBadge
<button class="copy-btn" onclick="copyCode(this,'$copyId')" aria-label="Copy code">⎘ Copy</button>
<pre><code id="$copyId"${lang.isNotEmpty ? ' class="language-$lang"' : ''}>$code</code></pre>
</div>''';
      },
    );

    // Post-process: image fullscreen data attr
    html = html.replaceAllMapped(
      RegExp(r'<img '),
      (match) => '<img class="md-img" onclick="openImageModal(this.src)" ',
    );

    // Post-process: table wrapper (horizontal scroll + sticky header)
    html = html.replaceAll('<table>', '<div class="table-wrapper"><table>');
    html = html.replaceAll('</table>', '</table></div>');

    final result = MarkdownRenderResult(
      html: html,
      headings: headings,
      contentHash: hash,
    );
    _cache = result;
    _cachedHash = hash;
    return result;
  }

  /// Clears the cache — call when the user switches files.
  static void clearCache() {
    _cache = null;
    _cachedHash = null;
  }
}
