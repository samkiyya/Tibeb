import 'package:flutter/material.dart';
import '../../../models/reader_settings_model.dart';

// ── Dart-raw-string JS for search (avoids Dart interpolation issues
// with the `${` in the regex character class) ──────────────────────────────
const String _kSearchJs = r'''
    // ── Search Engine ────────────────────────────────────────────────────────────
    let _searchMatches = [];
    let _searchCurrentIdx = -1;

    function clearSearch() {
      document.querySelectorAll('mark.search-hit').forEach(function(mark) {
        const parent = mark.parentNode;
        parent.replaceChild(document.createTextNode(mark.textContent), mark);
        parent.normalize();
      });
      _searchMatches = [];
      _searchCurrentIdx = -1;
    }

    function searchInDocument(query, flags) {
      clearSearch();
      if (!query) { TibebBridge.postMessage('searchResult:0:0'); return; }
      const caseSensitive = flags && flags.includes('i');
      const regexMode = flags && flags.includes('r');
      let pattern;
      try {
        pattern = regexMode
          ? new RegExp(query, caseSensitive ? 'g' : 'gi')
          : new RegExp(query.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'), caseSensitive ? 'g' : 'gi');
      } catch(e) { TibebBridge.postMessage('searchResult:0:0'); return; }

      const content = document.getElementById('content');
      const walker = document.createTreeWalker(content, NodeFilter.SHOW_TEXT, {
        acceptNode: function(node) {
          const p = node.parentNode;
          if (p && (p.nodeName === 'SCRIPT' || p.nodeName === 'STYLE' ||
              p.nodeName === 'CODE' || p.nodeName === 'PRE' ||
              p.classList && p.classList.contains('math-block'))) {
            return NodeFilter.FILTER_REJECT;
          }
          return NodeFilter.FILTER_ACCEPT;
        }
      });

      const nodesToProcess = [];
      let n;
      while ((n = walker.nextNode())) nodesToProcess.push(n);

      nodesToProcess.forEach(function(textNode) {
        const text = textNode.nodeValue;
        if (!pattern.test(text)) return;
        pattern.lastIndex = 0;
        const frag = document.createDocumentFragment();
        let last = 0, m;
        while ((m = pattern.exec(text)) !== null) {
          if (m.index > last) {
            frag.appendChild(document.createTextNode(text.slice(last, m.index)));
          }
          const mark = document.createElement('mark');
          mark.className = 'search-hit';
          mark.textContent = m[0];
          _searchMatches.push(mark);
          frag.appendChild(mark);
          last = m.index + m[0].length;
        }
        if (last < text.length) frag.appendChild(document.createTextNode(text.slice(last)));
        textNode.parentNode.replaceChild(frag, textNode);
      });

      const total = _searchMatches.length;
      if (total > 0) {
        _searchCurrentIdx = 0;
        _searchMatches[0].classList.add('search-hit-current');
        _searchMatches[0].scrollIntoView({ behavior: 'smooth', block: 'center' });
      }
      TibebBridge.postMessage('searchResult:' + total + ':' + (_searchCurrentIdx + 1));
    }

    function navigateSearch(direction) {
      if (_searchMatches.length === 0) return;
      _searchMatches[_searchCurrentIdx].classList.remove('search-hit-current');
      if (direction > 0) {
        _searchCurrentIdx = (_searchCurrentIdx + 1) % _searchMatches.length;
      } else {
        _searchCurrentIdx = (_searchCurrentIdx - 1 + _searchMatches.length) % _searchMatches.length;
      }
      const cur = _searchMatches[_searchCurrentIdx];
      cur.classList.add('search-hit-current');
      cur.scrollIntoView({ behavior: 'smooth', block: 'center' });
      TibebBridge.postMessage('searchResult:' + _searchMatches.length + ':' + (_searchCurrentIdx + 1));
    }
''';

/// Builds the full WebView HTML document shell that receives pre-rendered
/// HTML from [MarkdownRenderer] and injects all feature JS/CSS systems:
/// CSS variables, KaTeX, Highlight.js, Mermaid, IntersectionObserver,
/// code-copy buttons, fullscreen image viewer, search highlighting,
/// admonition styles, table enhancements, and collapsible sections.
class MarkdownHtmlBuilder {
  static String buildHtml({
    /// Pre-rendered HTML body from MarkdownRenderer
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

    // CSS variable values from current ReaderSettings
    final bg = _toHex(settings.backgroundColor);
    final fg = _toHex(settings.textColor);
    final secFg = _toHex(settings.secondaryTextColor);
    final accent = isDark ? '#7fa9ff' : '#2563eb';
    final codeBg = isDark ? '#131320' : '#f4f4f8';
    final codeBorder = isDark ? '#2a2a3e' : '#dde1f0';
    final blockquoteBg = isDark
        ? 'rgba(255,255,255,0.03)'
        : 'rgba(0,0,0,0.025)';
    final admonitionNoteBg = isDark ? '#1a2433' : '#eff6ff';
    final admonitionTipBg = isDark ? '#121f1a' : '#f0fdf4';
    final admonitionWarnBg = isDark ? '#221d0e' : '#fffbeb';
    final admonitionImpBg = isDark ? '#1c1228' : '#faf5ff';
    final admonitionCautBg = isDark ? '#221315' : '#fff1f2';

    final hasKatex = katexJs.isNotEmpty && katexCss.isNotEmpty;

    return '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5.0">
  <style>
    /* ── CSS Variables for instant theme switching ─────────────── */
    :root {
      --bg:          $bg;
      --fg:          $fg;
      --sec-fg:      $secFg;
      --accent:      $accent;
      --code-bg:     $codeBg;
      --code-border: $codeBorder;
      --bq-bg:       $blockquoteBg;
      --font:        $fontFamilyStr;
      --font-size:   ${settings.textSize}px;
      --line-height: ${settings.lineHeight};
      --text-align:  ${settings.alignment == ReaderAlignment.justified ? 'justify' : 'left'};
    }
    /* ── Highlight.js theme ───────────────────────────────────── */
    $hlCss
    /* ── Base Reset ────────────────────────────────────────────── */
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    html { scroll-behavior: smooth; }
    body {
      background: var(--bg);
      color: var(--fg);
      font-family: var(--font);
      font-size: var(--font-size);
      line-height: var(--line-height);
      padding: 24px 20px 100px;
      word-wrap: break-word;
      overflow-wrap: break-word;
      -webkit-user-select: text;
      user-select: text;
      transition: background 0.25s, color 0.25s;
    }
    /* ── Typography ────────────────────────────────────────────── */
    h1, h2, h3, h4, h5, h6 {
      color: var(--fg);
      line-height: 1.3;
      font-weight: 700;
      margin-top: 1.8em;
      margin-bottom: 0.6em;
      scroll-margin-top: 12px;
    }
    h1 { font-size: 1.65em; border-bottom: 2px solid var(--accent); padding-bottom: 6px; }
    h2 { font-size: 1.35em; border-bottom: 1px solid var(--code-border); padding-bottom: 4px; }
    h3 { font-size: 1.15em; }
    h4 { font-size: 1.05em; }
    h5, h6 { font-size: 0.95em; color: var(--sec-fg); }

    p { margin: 1em 0; text-align: var(--text-align); }
    strong { font-weight: 700; }
    em { font-style: italic; }
    del { opacity: 0.7; text-decoration: line-through; }

    a { color: var(--accent); text-decoration: none; }
    a:hover { text-decoration: underline; }

    /* ── Lists ─────────────────────────────────────────────────── */
    ul, ol { margin: 0.8em 0 0.8em 1.6em; }
    li { margin: 0.35em 0; }
    /* Task list items */
    .task-list-item { list-style: none; margin-left: -1.2em; }
    .task-list-item input[type=checkbox] {
      margin-right: 0.5em;
      cursor: default;
      vertical-align: middle;
      accent-color: var(--accent);
    }
    .task-list-item.checked > *:not(input) { opacity: 0.65; }

    /* ── Blockquote ────────────────────────────────────────────── */
    blockquote {
      margin: 1.4em 0;
      padding: 10px 16px;
      border-left: 4px solid var(--accent);
      background: var(--bq-bg);
      color: var(--sec-fg);
      font-style: italic;
      border-radius: 0 8px 8px 0;
    }

    /* ── Horizontal Rule ───────────────────────────────────────── */
    hr { border: 0; height: 1px; background: var(--code-border); margin: 2em 0; }

    /* ── Images ────────────────────────────────────────────────── */
    img.md-img {
      max-width: 100%;
      border-radius: 8px;
      margin: 1em 0;
      display: block;
      cursor: zoom-in;
      transition: opacity 0.2s;
    }
    img.md-img:hover { opacity: 0.92; }

    /* ── Code (inline) ─────────────────────────────────────────── */
    code {
      font-family: "Fira Code", "Courier New", Courier, monospace;
      font-size: 0.87em;
    }
    p code, li code, td code {
      background: var(--code-bg);
      border: 1px solid var(--code-border);
      padding: 1px 5px;
      border-radius: 4px;
    }

    /* ── Code Blocks ───────────────────────────────────────────── */
    .code-block {
      position: relative;
      margin: 1.4em 0;
    }
    .code-block pre {
      background: var(--code-bg);
      border: 1px solid var(--code-border);
      border-radius: 10px;
      padding: 14px 14px 14px 14px;
      overflow-x: auto;
      white-space: pre;
    }
    .code-block pre code {
      display: block;
      line-height: 1.55;
    }
    .code-lang-badge {
      position: absolute;
      top: 8px;
      left: 14px;
      font-family: "Fira Code", monospace;
      font-size: 10px;
      font-weight: 600;
      color: var(--sec-fg);
      background: var(--code-border);
      padding: 2px 7px;
      border-radius: 4px;
      z-index: 1;
      pointer-events: none;
      text-transform: uppercase;
      letter-spacing: 0.06em;
    }
    .copy-btn {
      position: absolute;
      top: 8px;
      right: 10px;
      background: var(--code-border);
      color: var(--sec-fg);
      border: none;
      border-radius: 5px;
      padding: 3px 10px;
      font-size: 11px;
      cursor: pointer;
      font-family: system-ui, sans-serif;
      transition: background 0.15s, color 0.15s;
      z-index: 2;
    }
    .copy-btn:hover { background: var(--accent); color: #fff; }
    .copy-btn.copied { background: #22c55e; color: #fff; }

    /* ── Tables ────────────────────────────────────────────────── */
    .table-wrapper {
      overflow-x: auto;
      margin: 1.4em 0;
      border-radius: 8px;
      border: 1px solid var(--code-border);
    }
    table {
      width: 100%;
      border-collapse: collapse;
      font-size: 0.93em;
    }
    thead {
      position: sticky;
      top: 0;
      z-index: 10;
    }
    th {
      background: var(--code-bg);
      font-weight: 600;
      padding: 9px 14px;
      text-align: left;
      border-bottom: 2px solid var(--code-border);
    }
    td { padding: 8px 14px; border-top: 1px solid var(--code-border); }
    tr:nth-child(even) td { background: rgba(128,128,128,0.04); }
    tr:hover td { background: rgba(128,128,128,0.07); }

    /* ── Footnotes ──────────────────────────────────────────────── */
    .footnotes { margin-top: 3em; border-top: 1px solid var(--code-border); padding-top: 1em; font-size: 0.88em; color: var(--sec-fg); }
    .footnotes ol { padding-left: 1.4em; }
    a.footnote { vertical-align: super; font-size: 0.75em; color: var(--accent); }

    /* ── Admonitions ────────────────────────────────────────────── */
    .admonition {
      border-radius: 8px;
      padding: 12px 16px;
      margin: 1.4em 0;
      border-left: 4px solid;
    }
    .admonition-title {
      font-weight: 700;
      font-size: 0.95em;
      margin-bottom: 6px;
      display: flex;
      align-items: center;
      gap: 6px;
    }
    .admonition-icon { font-size: 1.1em; }
    .admonition-body { font-size: 0.93em; line-height: 1.6; }
    .admonition-note   { background: $admonitionNoteBg; border-color: #3b82f6; }
    .admonition-note .admonition-title   { color: #3b82f6; }
    .admonition-tip    { background: $admonitionTipBg;  border-color: #22c55e; }
    .admonition-tip .admonition-title    { color: #22c55e; }
    .admonition-warning{ background: $admonitionWarnBg; border-color: #f59e0b; }
    .admonition-warning .admonition-title{ color: #f59e0b; }
    .admonition-important{ background: $admonitionImpBg; border-color: #a855f7; }
    .admonition-important .admonition-title{ color: #a855f7; }
    .admonition-caution{ background: $admonitionCautBg; border-color: #ef4444; }
    .admonition-caution .admonition-title{ color: #ef4444; }

    /* ── Math ────────────────────────────────────────────────────── */
    .math-block {
      background: var(--code-bg);
      border: 1px solid var(--code-border);
      border-radius: 8px;
      padding: 14px;
      margin: 1.4em 0;
      text-align: center;
      overflow-x: auto;
    }
    .math-inline { display: inline; }
    .math-src { display: none; }
    .katex-display { overflow-x: auto; }

    /* ── Mermaid ─────────────────────────────────────────────────── */
    .mermaid {
      text-align: center;
      background: var(--code-bg);
      border: 1px solid var(--code-border);
      border-radius: 10px;
      padding: 16px;
      margin: 1.4em 0;
      overflow-x: auto;
      cursor: zoom-in;
    }

    /* ── Search Highlights ─────────────────────────────────────── */
    mark.search-hit {
      background: rgba(250, 200, 50, 0.55);
      color: inherit;
      border-radius: 2px;
      padding: 0 1px;
    }
    mark.search-hit-current {
      background: rgba(250, 130, 30, 0.7);
      outline: 1px solid rgba(250, 130, 30, 0.9);
    }

    /* ── Fullscreen Image Modal ──────────────────────────────────── */
    #img-modal {
      display: none;
      position: fixed;
      z-index: 99999;
      inset: 0;
      background: rgba(0,0,0,0.96);
      backdrop-filter: blur(12px);
      justify-content: center;
      align-items: center;
      flex-direction: column;
    }
    #img-modal.open { display: flex; }
    #img-modal-close {
      position: absolute;
      top: 18px; right: 22px;
      color: #fff;
      font-size: 36px;
      cursor: pointer;
      z-index: 100001;
      background: none; border: none;
      line-height: 1;
    }
    #img-modal-img {
      max-width: 90vw;
      max-height: 90vh;
      border-radius: 8px;
      transform-origin: center center;
      cursor: grab;
      user-select: none;
      will-change: transform;
    }
    #img-modal-hint {
      position: absolute;
      bottom: 16px;
      color: rgba(255,255,255,0.4);
      font-size: 12px;
      font-family: system-ui, sans-serif;
      pointer-events: none;
    }

    /* ── Mermaid Fullscreen Modal ────────────────────────────────── */
    #mermaid-modal {
      display: none;
      position: fixed; z-index: 9998; inset: 0;
      background: rgba(10,10,18,0.96);
      backdrop-filter: blur(10px);
      justify-content: center; align-items: center;
    }
    .close-modal {
      position: absolute; top:20px; right:25px;
      color:#fff; font-size:40px; font-weight:bold;
      cursor:pointer; z-index:10000; background:none; border:none;
    }
    .modal-content-wrapper {
      width:90%; height:90%;
      display:flex; justify-content:center; align-items:center;
      overflow:hidden; position:relative;
    }
    #modal-svg-container {
      width:100%; height:100%;
      display:flex; justify-content:center; align-items:center;
      transform-origin:0 0; cursor:grab; user-select:none;
    }
    #modal-svg-container svg {
      width:auto!important; height:auto!important;
      max-width:100%!important; max-height:100%!important;
    }

    /* ── Details/Summary (collapsible) ──────────────────────────── */
    details {
      border: 1px solid var(--code-border);
      border-radius: 8px;
      padding: 10px 14px;
      margin: 1em 0;
    }
    summary {
      font-weight: 600;
      cursor: pointer;
      user-select: none;
      list-style: none;
    }
    summary::before { content: "▶ "; font-size: 0.75em; }
    details[open] > summary::before { content: "▼ "; }
    details > *:not(summary) { margin-top: 10px; }
  </style>

  ${hasKatex ? '<style>$katexCss</style>' : ''}

  <script>$hlJs</script>
  <script>$mermaidJs</script>
  ${hasKatex ? '<script>$katexJs</script>' : ''}
</head>
<body>
  <div id="content">$renderedHtml</div>

  <!-- Image Fullscreen Modal -->
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
    // ── Theme CSS variable updater ──────────────────────────────────
    function updateTheme(vars) {
      const root = document.documentElement;
      for (const [k, v] of Object.entries(vars)) {
        root.style.setProperty(k, v);
      }
    }

    // ── Mermaid ─────────────────────────────────────────────────────
    try {
      mermaid.initialize({
        startOnLoad: false,
        theme: '$mermaidTheme',
        securityLevel: 'loose',
        flowchart: { useMaxWidth: true, htmlLabels: true }
      });
      mermaid.run({ nodes: document.querySelectorAll('.mermaid') });
    } catch(e) { console.warn('Mermaid:', e); }

    // ── Highlight.js ─────────────────────────────────────────────────
    document.querySelectorAll('pre code').forEach(function(el) {
      try { hljs.highlightElement(el); } catch(e) {}
    });

    // ── KaTeX Math Rendering ─────────────────────────────────────────
    ${hasKatex ? '''
    function renderMath() {
      // Block math
      document.querySelectorAll('.math-block').forEach(function(el) {
        const src = el.getAttribute('data-math');
        if (!src) return;
        try {
          const rendered = katex.renderToString(src, {
            displayMode: true, throwOnError: false, output: 'html'
          });
          el.innerHTML = rendered;
        } catch(e) {
          const pre = el.querySelector('.math-src');
          if (pre) pre.style.display = 'block';
        }
      });
      // Inline math
      document.querySelectorAll('.math-inline').forEach(function(el) {
        const src = el.getAttribute('data-math');
        if (!src) return;
        try {
          const rendered = katex.renderToString(src, {
            displayMode: false, throwOnError: false, output: 'html'
          });
          el.innerHTML = rendered;
        } catch(e) {
          const code = el.querySelector('.math-src');
          if (code) code.style.display = 'inline';
        }
      });
    }
    renderMath();
    ''' : '// KaTeX not bundled — math shown as raw text'}

    // ── Code block: Copy button ──────────────────────────────────────
    function copyCode(btn, codeId) {
      const el = document.getElementById(codeId);
      if (!el) return;
      const text = el.innerText || el.textContent;
      navigator.clipboard.writeText(text).then(function() {
        btn.textContent = '✓ Copied';
        btn.classList.add('copied');
        setTimeout(function() {
          btn.textContent = '⎘ Copy';
          btn.classList.remove('copied');
        }, 1800);
      }).catch(function() {
        btn.textContent = '✗ Failed';
        setTimeout(function() { btn.textContent = '⎘ Copy'; }, 1800);
      });
    }

    // ── Image Fullscreen Viewer ──────────────────────────────────────
    const imgModal = document.getElementById('img-modal');
    const imgModalImg = document.getElementById('img-modal-img');
    let imgScale = 1, imgX = 0, imgY = 0;
    let imgDragStart = null;

    function openImageModal(src) {
      imgModal.classList.add('open');
      imgModalImg.src = src;
      imgScale = 1; imgX = 0; imgY = 0;
      applyImgTransform();
      document.body.style.overflow = 'hidden';
    }

    function closeImageModal() {
      imgModal.classList.remove('open');
      imgModalImg.src = '';
      document.body.style.overflow = '';
    }

    function applyImgTransform() {
      imgModalImg.style.transform =
        'translate(' + imgX + 'px,' + imgY + 'px) scale(' + imgScale + ')';
    }

    imgModal.addEventListener('click', function(e) {
      if (e.target === imgModal) closeImageModal();
    });

    // Mouse drag
    imgModalImg.addEventListener('mousedown', function(e) {
      imgDragStart = { x: e.clientX - imgX, y: e.clientY - imgY };
      imgModalImg.style.cursor = 'grabbing';
    });
    window.addEventListener('mousemove', function(e) {
      if (!imgDragStart) return;
      imgX = e.clientX - imgDragStart.x;
      imgY = e.clientY - imgDragStart.y;
      applyImgTransform();
    });
    window.addEventListener('mouseup', function() {
      imgDragStart = null;
      imgModalImg.style.cursor = 'grab';
    });

    // Wheel zoom
    imgModal.addEventListener('wheel', function(e) {
      e.preventDefault();
      const factor = e.deltaY < 0 ? 1.12 : 0.88;
      imgScale = Math.max(0.25, Math.min(10, imgScale * factor));
      applyImgTransform();
    }, { passive: false });

    // Double-click zoom
    imgModalImg.addEventListener('dblclick', function() {
      if (imgScale > 1.5) { imgScale = 1; imgX = 0; imgY = 0; }
      else { imgScale = 2.5; }
      applyImgTransform();
    });

    // Touch pinch
    let imgTouchDist = 0, imgInitialScale = 1;
    imgModal.addEventListener('touchstart', function(e) {
      if (e.touches.length === 2) {
        imgTouchDist = Math.hypot(
          e.touches[0].clientX - e.touches[1].clientX,
          e.touches[0].clientY - e.touches[1].clientY
        );
        imgInitialScale = imgScale;
      }
    }, { passive: true });
    imgModal.addEventListener('touchmove', function(e) {
      if (e.touches.length === 2) {
        const dist = Math.hypot(
          e.touches[0].clientX - e.touches[1].clientX,
          e.touches[0].clientY - e.touches[1].clientY
        );
        imgScale = Math.max(0.25, Math.min(10, imgInitialScale * (dist / imgTouchDist)));
        applyImgTransform();
        e.preventDefault();
      }
    }, { passive: false });

    // ── Mermaid fullscreen ────────────────────────────────────────────
    const mermaidModal = document.getElementById('mermaid-modal');
    const mermaidContainer = document.getElementById('modal-svg-container');
    let mScale = 1, mX = 0, mY = 0, mDragging = false, mStart = {x:0,y:0};
    let mTouchDist = 0, mInitScale = 1;

    document.addEventListener('dblclick', function(e) {
      const d = e.target.closest('.mermaid');
      if (!d) return;
      const svg = d.querySelector('svg');
      if (svg) { openMermaidModal(svg.outerHTML); }
    });

    function openMermaidModal(svgHtml) {
      mermaidModal.style.display = 'flex';
      mermaidContainer.innerHTML = svgHtml;
      mScale = 1; mX = 0; mY = 0;
      updateMermaidTransform();
    }

    function closeMermaidModal() {
      mermaidModal.style.display = 'none';
      mermaidContainer.innerHTML = '';
    }

    function updateMermaidTransform() {
      mermaidContainer.style.transform =
        'translate(' + mX + 'px,' + mY + 'px) scale(' + mScale + ')';
    }

    mermaidContainer.addEventListener('mousedown', function(e) {
      mDragging = true;
      mStart = { x: e.clientX - mX, y: e.clientY - mY };
      mermaidContainer.style.cursor = 'grabbing';
    });
    window.addEventListener('mousemove', function(e) {
      if (!mDragging) return;
      mX = e.clientX - mStart.x; mY = e.clientY - mStart.y;
      updateMermaidTransform();
    });
    window.addEventListener('mouseup', function() {
      mDragging = false;
      mermaidContainer.style.cursor = 'grab';
    });
    mermaidContainer.addEventListener('wheel', function(e) {
      e.preventDefault();
      const xs = (e.clientX - mX) / mScale, ys = (e.clientY - mY) / mScale;
      mScale = e.deltaY < 0 ? Math.min(8, mScale * 1.15) : Math.max(0.3, mScale / 1.15);
      mX = e.clientX - xs * mScale; mY = e.clientY - ys * mScale;
      updateMermaidTransform();
    });
    mermaidContainer.addEventListener('touchstart', function(e) {
      if (e.touches.length === 1) {
        mDragging = true;
        mStart = { x: e.touches[0].clientX - mX, y: e.touches[0].clientY - mY };
      } else if (e.touches.length === 2) {
        mDragging = false;
        mTouchDist = Math.hypot(
          e.touches[0].clientX - e.touches[1].clientX,
          e.touches[0].clientY - e.touches[1].clientY
        );
        mInitScale = mScale;
      }
    }, { passive: true });
    mermaidContainer.addEventListener('touchmove', function(e) {
      if (mDragging && e.touches.length === 1) {
        mX = e.touches[0].clientX - mStart.x;
        mY = e.touches[0].clientY - mStart.y;
        updateMermaidTransform();
      } else if (e.touches.length === 2) {
        const d = Math.hypot(
          e.touches[0].clientX - e.touches[1].clientX,
          e.touches[0].clientY - e.touches[1].clientY
        );
        mScale = Math.max(0.3, Math.min(8, mInitScale * (d / mTouchDist)));
        updateMermaidTransform();
      }
      e.preventDefault();
    }, { passive: false });

    // ── Anchor link interception (smooth scroll to slug/ID) ────────────
    document.addEventListener('click', function(e) {
      const anchor = e.target.closest('a');
      if (anchor) {
        const href = anchor.getAttribute('href');
        if (href && href.startsWith('#')) {
          e.preventDefault();
          const slug = decodeURIComponent(href.slice(1)).toLowerCase().trim();
          let target = document.getElementById(slug);
          if (!target) {
            document.querySelectorAll('[data-slug]').forEach(function(h) {
              if (h.getAttribute('data-slug') === slug) target = h;
            });
          }
          if (target) target.scrollIntoView({ behavior: 'smooth', block: 'start' });
          return;
        }
      }
      if (e.target.closest('#img-modal, #mermaid-modal, .mermaid')) return;
      if (!e.target.closest('a, button, input, textarea')) {
        TibebBridge.postMessage('toggleControls');
      }
    });

    // ── Scroll progress reporting ────────────────────────────────────
    window.addEventListener('scroll', function() {
      const maxSc = document.documentElement.scrollHeight - window.innerHeight;
      const prog = maxSc > 0 ? window.scrollY / maxSc : 0;
      TibebBridge.postMessage(String(prog));
    }, { passive: true });

    // ── Heading IntersectionObserver ─────────────────────────────────
    try {
      const headingObserver = new IntersectionObserver(function(entries) {
        for (const entry of entries) {
          if (entry.isIntersecting) {
            TibebBridge.postMessage('activeHeading:' + entry.target.id);
            break;
          }
        }
      }, { rootMargin: '0px 0px -80% 0px', threshold: 0 });

      document.querySelectorAll('h1,h2,h3,h4,h5,h6').forEach(function(h) {
        headingObserver.observe(h);
      });
    } catch(err) { console.warn('IntersectionObserver:', err); }

    // ── ESC key ──────────────────────────────────────────────────────
    document.addEventListener('keydown', function(e) {
      if (e.key === 'Escape') {
        closeImageModal();
        closeMermaidModal();
      }
    });

    $_kSearchJs
  </script>
</body>
</html>
''';
  }

  static String _toHex(Color c) {
    final argb = c.toARGB32();
    final rgb = argb & 0xFFFFFF;
    return '#${rgb.toRadixString(16).padLeft(6, '0')}';
  }
}
