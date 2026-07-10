/// Mermaid diagram initialization JavaScript.
/// Deferred into a requestAnimationFrame so the DOM is fully painted
/// before Mermaid attempts to render SVG diagrams.
String buildMdJsMermaid({required String mermaidTheme}) =>
    '''
    // ── Mermaid (deferred rAF — ensures DOM is painted first) ──────────────
    (function() {
      try {
        mermaid.initialize({
          startOnLoad: false,
          theme: '$mermaidTheme',
          securityLevel: 'loose',
          flowchart:  { useMaxWidth: true, htmlLabels: true, curve: 'basis' },
          er:         { useMaxWidth: true },
          sequence:   { useMaxWidth: true, showSequenceNumbers: false },
          gantt:      { useMaxWidth: true },
          pie:        { useMaxWidth: true },
          journey:    { useMaxWidth: true }
        });
        requestAnimationFrame(function() {
          mermaid.run({ nodes: document.querySelectorAll('.mermaid') })
            .catch(function(e) { console.warn('[Mermaid run]', e); });
        });
      } catch(e) { console.warn('[Mermaid init]', e); }
    })();
''';
