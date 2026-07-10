import 'package:flutter/material.dart';
import '../../../../models/reader_settings_model.dart';

/// Returns the complete CSS stylesheet for the Markdown WebView.
/// Accepts pre-computed CSS variable values for instant theme-switching.
String buildMdCss({
  required ReaderSettings settings,
  required String hlCss,
  required String fontFamilyStr,
}) {
  final isDark =
      settings.theme == ReaderTheme.darkBlue ||
      settings.theme == ReaderTheme.black;

  final bg = _hex(settings.backgroundColor);
  final fg = _hex(settings.textColor);
  final secFg = _hex(settings.secondaryTextColor);
  final accent = isDark ? '#7fa9ff' : '#2563eb';
  final codeBg = isDark ? '#131320' : '#f4f4f8';
  final codeBorder = isDark ? '#2a2a3e' : '#dde1f0';
  final blockquoteBg = isDark ? 'rgba(255,255,255,0.03)' : 'rgba(0,0,0,0.025)';
  final admonitionNoteBg = isDark ? '#1a2433' : '#eff6ff';
  final admonitionTipBg = isDark ? '#121f1a' : '#f0fdf4';
  final admonitionWarnBg = isDark ? '#221d0e' : '#fffbeb';
  final admonitionImpBg = isDark ? '#1c1228' : '#faf5ff';
  final admonitionCautBg = isDark ? '#221315' : '#fff1f2';
  final textAlign = settings.alignment == ReaderAlignment.justified
      ? 'justify'
      : 'left';

  return '''
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
  --text-align:  $textAlign;
}
/* ── Highlight.js theme ──────────────────────────────────────── */
$hlCss
/* ── Base Reset ──────────────────────────────────────────────── */
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
/* ── Typography ───────────────────────────────────────────────── */
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
/* ── Lists ────────────────────────────────────────────────────── */
ul, ol { margin: 0.8em 0 0.8em 1.6em; }
li { margin: 0.35em 0; }
.task-list-item { list-style: none; margin-left: -1.2em; }
.task-list-item input[type=checkbox] {
  margin-right: 0.5em;
  cursor: default;
  vertical-align: middle;
  accent-color: var(--accent);
}
.task-list-item.checked > *:not(input) { opacity: 0.65; }
/* ── Blockquote ────────────────────────────────────────────────── */
blockquote {
  margin: 1.4em 0; padding: 10px 16px;
  border-left: 4px solid var(--accent);
  background: var(--bq-bg);
  color: var(--sec-fg);
  font-style: italic;
  border-radius: 0 8px 8px 0;
}
/* ── HR ───────────────────────────────────────────────────────── */
hr { border: 0; height: 1px; background: var(--code-border); margin: 2em 0; }
/* ── Images ───────────────────────────────────────────────────── */
img.md-img {
  max-width: 100%; border-radius: 8px; margin: 1em 0;
  display: block; cursor: zoom-in; transition: opacity 0.2s;
}
img.md-img:hover { opacity: 0.92; }
/* ── Inline code ──────────────────────────────────────────────── */
code { font-family: "Fira Code","Courier New",Courier,monospace; font-size: 0.87em; }
p code, li code, td code {
  background: var(--code-bg);
  border: 1px solid var(--code-border);
  padding: 1px 5px; border-radius: 4px;
}
/* ── Code Blocks ──────────────────────────────────────────────── */
.code-block { position: relative; margin: 1.4em 0; }
.code-block pre {
  background: var(--code-bg);
  border: 1px solid var(--code-border);
  border-radius: 10px;
  padding: 36px 14px 14px;
  overflow-x: auto;
  white-space: pre;
}
.code-block pre code { display: block; line-height: 1.55; }
.code-lang-badge {
  position: absolute; top: 8px; left: 14px;
  font-family: "Fira Code",monospace; font-size: 10px; font-weight: 600;
  color: var(--sec-fg); background: var(--code-border);
  padding: 2px 7px; border-radius: 4px; z-index: 1;
  pointer-events: none; text-transform: uppercase; letter-spacing: 0.06em;
}
.copy-btn {
  position: absolute; top: 8px; right: 10px;
  background: var(--code-border); color: var(--sec-fg);
  border: none; border-radius: 5px; padding: 3px 10px;
  font-size: 11px; cursor: pointer; font-family: system-ui,sans-serif;
  transition: background 0.15s,color 0.15s; z-index: 2;
}
.copy-btn:hover { background: var(--accent); color:#fff; }
.copy-btn.copied { background:#22c55e; color:#fff; }
/* ── Tables ───────────────────────────────────────────────────── */
.table-wrapper { overflow-x:auto; margin:1.4em 0; border-radius:8px; border:1px solid var(--code-border); }
table { width:100%; border-collapse:collapse; font-size:0.93em; }
thead { position:sticky; top:0; z-index:10; }
th { background:var(--code-bg); font-weight:600; padding:9px 14px; text-align:left; border-bottom:2px solid var(--code-border); }
td { padding:8px 14px; border-top:1px solid var(--code-border); }
tr:nth-child(even) td { background:rgba(128,128,128,0.04); }
tr:hover td { background:rgba(128,128,128,0.07); }
/* ── Footnotes ────────────────────────────────────────────────── */
.footnotes { margin-top:3em; border-top:1px solid var(--code-border); padding-top:1em; font-size:0.88em; color:var(--sec-fg); }
.footnotes ol { padding-left:1.4em; }
a.footnote { vertical-align:super; font-size:0.75em; color:var(--accent); }
/* ── Admonitions ──────────────────────────────────────────────── */
.admonition { border-radius:8px; padding:12px 16px; margin:1.4em 0; border-left:4px solid; }
.admonition-title { font-weight:700; font-size:0.95em; margin-bottom:6px; display:flex; align-items:center; gap:6px; }
.admonition-icon { font-size:1.1em; }
.admonition-body { font-size:0.93em; line-height:1.6; }
.admonition-note   { background:$admonitionNoteBg; border-color:#3b82f6; }
.admonition-note .admonition-title   { color:#3b82f6; }
.admonition-tip    { background:$admonitionTipBg;  border-color:#22c55e; }
.admonition-tip .admonition-title    { color:#22c55e; }
.admonition-warning{ background:$admonitionWarnBg; border-color:#f59e0b; }
.admonition-warning .admonition-title{ color:#f59e0b; }
.admonition-important{ background:$admonitionImpBg; border-color:#a855f7; }
.admonition-important .admonition-title{ color:#a855f7; }
.admonition-caution{ background:$admonitionCautBg; border-color:#ef4444; }
.admonition-caution .admonition-title{ color:#ef4444; }
/* ── Math ─────────────────────────────────────────────────────── */
.math-block {
  background:var(--code-bg); border:1px solid var(--code-border);
  border-radius:8px; padding:14px; margin:1.4em 0;
  text-align:center; overflow-x:auto;
}
.math-inline { display:inline; }
.math-src { display:none; font-family:monospace; font-size:0.88em; white-space:pre-wrap; }
/* KaTeX HTML output tuning */
.katex-display { overflow-x:auto; overflow-y:hidden; padding:4px 0; }
.katex { font-size:1.1em; }
/* ── Mermaid ──────────────────────────────────────────────────── */
.mermaid {
  text-align:center; background:var(--code-bg);
  border:1px solid var(--code-border); border-radius:10px;
  padding:16px; margin:1.4em 0; overflow-x:auto; cursor:zoom-in;
}
/* ── Search Highlights ────────────────────────────────────────── */
mark.search-hit { background:rgba(250,200,50,0.55); color:inherit; border-radius:2px; padding:0 1px; }
mark.search-hit-current { background:rgba(250,130,30,0.7); outline:1px solid rgba(250,130,30,0.9); }
/* ── Image Fullscreen Modal ───────────────────────────────────── */
#img-modal {
  display:none; position:fixed; z-index:99999; inset:0;
  background:rgba(0,0,0,0.96); backdrop-filter:blur(12px);
  justify-content:center; align-items:center; flex-direction:column;
}
#img-modal.open { display:flex; }
#img-modal-close { position:absolute; top:18px; right:22px; color:#fff; font-size:36px; cursor:pointer; z-index:100001; background:none; border:none; line-height:1; }
#img-modal-img { max-width:90vw; max-height:90vh; border-radius:8px; transform-origin:center center; cursor:grab; user-select:none; will-change:transform; }
#img-modal-hint { position:absolute; bottom:16px; color:rgba(255,255,255,0.4); font-size:12px; font-family:system-ui,sans-serif; pointer-events:none; }
/* ── Mermaid Fullscreen Modal ─────────────────────────────────── */
#mermaid-modal { display:none; position:fixed; z-index:9998; inset:0; background:rgba(10,10,18,0.96); backdrop-filter:blur(10px); justify-content:center; align-items:center; }
.close-modal { position:absolute; top:20px; right:25px; color:#fff; font-size:40px; font-weight:bold; cursor:pointer; z-index:10000; background:none; border:none; }
.modal-content-wrapper { width:90%; height:90%; display:flex; justify-content:center; align-items:center; overflow:hidden; position:relative; }
#modal-svg-container { width:100%; height:100%; display:flex; justify-content:center; align-items:center; transform-origin:0 0; cursor:grab; user-select:none; }
#modal-svg-container svg { width:auto!important; height:auto!important; max-width:100%!important; max-height:100%!important; }
/* ── Collapsible sections ─────────────────────────────────────── */
details { border:1px solid var(--code-border); border-radius:8px; padding:10px 14px; margin:1em 0; }
summary { font-weight:600; cursor:pointer; user-select:none; list-style:none; }
summary::before { content:"▶ "; font-size:0.75em; }
details[open] > summary::before { content:"▼ "; }
details > *:not(summary) { margin-top:10px; }
''';
}

String _hex(Color c) {
  final rgb = c.toARGB32() & 0xFFFFFF;
  return '#${rgb.toRadixString(16).padLeft(6, '0')}';
}
