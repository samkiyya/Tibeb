/// KaTeX math rendering JavaScript module.
/// Switches to HTML output mode for maximum feature coverage
/// (cancel, boxed, color, fonts, complex matrices, etc.).
/// Font files are loaded from CDN; for offline graceful degradation the
/// WebView engine caches fonts after first use.
String buildMdJsKatex({required bool hasKatex}) {
  if (!hasKatex) return '// KaTeX not loaded — math shown as raw source';

  return r'''
    // ── KaTeX Math Rendering (HTML mode — full feature support) ────────────
    (function renderMath() {
      var opts = {
        throwOnError: false,
        strict: false,
        trust: true,
        macros: {
          "\\R":    "\\mathbb{R}",
          "\\N":    "\\mathbb{N}",
          "\\Z":    "\\mathbb{Z}",
          "\\Q":    "\\mathbb{Q}",
          "\\C":    "\\mathbb{C}",
          "\\abs":  "\\left|#1\\right|",
          "\\norm": "\\left\\|#1\\right\\|"
        }
      };

      // Display (block) math
      document.querySelectorAll('.math-block').forEach(function(el) {
        var src = el.getAttribute('data-math');
        if (src === null) return;
        var fallback = el.querySelector('.math-src');
        try {
          el.innerHTML = katex.renderToString(src, Object.assign({}, opts, { displayMode: true, output: 'html' }));
        } catch (e) {
          if (fallback) fallback.style.display = 'block';
          console.warn('[KaTeX block]', e.message, '| Source:', src.substring(0, 80));
        }
      });

      // Inline math
      document.querySelectorAll('.math-inline').forEach(function(el) {
        var src = el.getAttribute('data-math');
        if (src === null) return;
        var fallback = el.querySelector('.math-src');
        try {
          el.innerHTML = katex.renderToString(src, Object.assign({}, opts, { displayMode: false, output: 'html' }));
        } catch (e) {
          if (fallback) fallback.style.display = 'inline';
          console.warn('[KaTeX inline]', e.message, '| Source:', src.substring(0, 80));
        }
      });
    })();
''';
}
