// Raw-string JS for the in-document search engine.
// Uses a raw string to avoid Dart interpolation issues with `${` in regex.
const String kMdJsSearch = r'''
  // ── Search Engine ──────────────────────────────────────────────────────────
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
