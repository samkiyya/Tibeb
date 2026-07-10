import '../../../../models/reader_settings_model.dart';
import 'html/md_css_styles.dart';
import 'html/md_js_highlight.dart';
import 'html/md_js_katex.dart';
import 'html/md_js_mermaid.dart';
import 'html/md_js_search.dart';
import 'html/md_js_ui.dart';

/// Builds the full WebView HTML document shell that receives pre-rendered
/// HTML from [MarkdownRenderer] and injects all feature JS/CSS systems via
/// modularized style/script files.
class MarkdownHtmlBuilder {
  static String buildHtml({
    required String renderedHtml,
    required ReaderSettings settings,
    required String hlJs,
    required String mermaidJs,
    required String hlDarkCss,
    required String hlLightCss,
    String katexJs = '',
    String katexCss = '',
  }) {
    final isDark =
        settings.theme == ReaderTheme.darkBlue ||
        settings.theme == ReaderTheme.black;
    final hlCss = isDark ? hlDarkCss : hlLightCss;
    final mermaidTheme = isDark ? 'dark' : 'default';

    String fontFamilyStr =
        '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif';
    switch (settings.typeface) {
      case 'Merriweather':
        fontFamilyStr = '"Merriweather", Georgia, serif';
        break;
      case 'Georgia':
        fontFamilyStr = 'Georgia, serif';
        break;
      case 'Lexend':
        fontFamilyStr = '"Lexend", sans-serif';
        break;
      default:
        break;
    }

    final hasKatex = katexJs.isNotEmpty && katexCss.isNotEmpty;

    // Build the stylesheet list and JS scripts in modular chunks
    final cssStyles = buildMdCss(
      settings: settings,
      hlCss: hlCss,
      fontFamilyStr: fontFamilyStr,
    );
    final jsKatex = buildMdJsKatex(hasKatex: hasKatex);
    final jsMermaid = buildMdJsMermaid(mermaidTheme: mermaidTheme);

    return '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5.0">
  <style>
    $cssStyles
  </style>
  ${hasKatex ? '<style>/* KaTeX styles loaded with CDN font resolving */\n$katexCss</style>' : ''}
  <script>$hlJs</script>
  <script>$mermaidJs</script>
  ${hasKatex ? '<script>$katexJs</script>' : ''}
</head>
<body>
  <div id="content">$renderedHtml</div>

  <!-- Image Viewer Modal -->
  <div id="img-modal" role="dialog" aria-modal="true" aria-label="Image viewer">
    <button id="img-modal-close" aria-label="Close" onclick="closeImageModal()">×</button>
    <img id="img-modal-img" src="" alt="Expanded image" draggable="false">
    <span id="img-modal-hint">Pinch / scroll to zoom · Drag to pan · ESC to close</span>
  </div>

  <!-- Mermaid Fullscreen Modal -->
  <div id="mermaid-modal">
    <button class="close-modal" onclick="closeMermaidModal()">×</button>
    <div class="modal-content-wrapper">
      <div id="modal-svg-container"></div>
    </div>
  </div>

  <script>
    $kMdJsUi
    $jsMermaid
    $kMdJsHighlight
    $jsKatex
    $kMdJsSearch
  </script>
</body>
</html>
''';
  }
}
