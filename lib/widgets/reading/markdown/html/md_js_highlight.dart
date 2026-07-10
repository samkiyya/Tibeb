/// Highlight.js code syntax initialization and copy-button logic.
/// Skips any element inside a .mermaid or .math-block container.
const String kMdJsHighlight = r'''
    // ── Highlight.js (skip mermaid/math elements) ──────────────────────────
    (function() {
      document.querySelectorAll('pre code').forEach(function(el) {
        if (el.closest('.mermaid, .math-block')) return;
        try { hljs.highlightElement(el); } catch(e) {}
      });
    })();

    // ── Code Copy Button ───────────────────────────────────────────────────
    function copyCode(btn, codeId) {
      const el = document.getElementById(codeId);
      if (!el) return;
      try {
        navigator.clipboard.writeText(el.innerText).then(function() {
          btn.textContent = '✓';
          btn.classList.add('copied');
          setTimeout(function() {
            btn.textContent = 'Copy';
            btn.classList.remove('copied');
          }, 1800);
        }).catch(function() { _fallbackCopy(btn, el.innerText); });
      } catch(_) { _fallbackCopy(btn, el.innerText); }
    }
    function _fallbackCopy(btn, text) {
      const ta = document.createElement('textarea');
      ta.value = text;
      ta.style.cssText = 'position:fixed;opacity:0';
      document.body.appendChild(ta);
      ta.select();
      try { document.execCommand('copy'); } catch(e) {}
      document.body.removeChild(ta);
      btn.textContent = '✓';
      btn.classList.add('copied');
      setTimeout(function() {
        btn.textContent = 'Copy';
        btn.classList.remove('copied');
      }, 1800);
    }
''';
