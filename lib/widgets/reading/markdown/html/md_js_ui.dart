/// UI interaction JavaScript:
/// - Theme CSS variable updater
/// - Image fullscreen viewer (drag, wheel-zoom, pinch, dbl-click)
/// - Mermaid fullscreen viewer (drag, wheel-zoom, pinch)
/// - Anchor link interception → smooth scroll
/// - Scroll progress reporting to Flutter via TibebBridge
/// - IntersectionObserver for active heading tracking
/// - ESC key handler for all modals
const String kMdJsUi = r'''
    // ── Theme CSS Variable Updater ─────────────────────────────────────────
    function updateTheme(vars) {
      const root = document.documentElement;
      for (const [k, v] of Object.entries(vars)) {
        root.style.setProperty(k, v);
      }
    }

    // ── Image Fullscreen Viewer ────────────────────────────────────────────
    const imgModal   = document.getElementById('img-modal');
    const imgModalImg = document.getElementById('img-modal-img');
    let imgScale = 1, imgX = 0, imgY = 0, imgDragStart = null;

    function openImageModal(src) {
      imgModal.classList.add('open');
      imgModalImg.src = src;
      imgScale = 1; imgX = 0; imgY = 0;
      _applyImgTx();
      document.body.style.overflow = 'hidden';
    }
    function closeImageModal() {
      imgModal.classList.remove('open');
      imgModalImg.src = '';
      document.body.style.overflow = '';
    }
    function _applyImgTx() {
      imgModalImg.style.transform = 'translate('+imgX+'px,'+imgY+'px) scale('+imgScale+')';
    }
    imgModal.addEventListener('click', function(e) {
      if (e.target === imgModal) closeImageModal();
    });
    imgModalImg.addEventListener('mousedown', function(e) {
      imgDragStart = { x: e.clientX - imgX, y: e.clientY - imgY };
      imgModalImg.style.cursor = 'grabbing';
    });
    window.addEventListener('mousemove', function(e) {
      if (!imgDragStart) return;
      imgX = e.clientX - imgDragStart.x;
      imgY = e.clientY - imgDragStart.y;
      _applyImgTx();
    });
    window.addEventListener('mouseup', function() {
      imgDragStart = null; imgModalImg.style.cursor = 'grab';
    });
    imgModal.addEventListener('wheel', function(e) {
      e.preventDefault();
      imgScale = Math.max(0.25, Math.min(10, imgScale * (e.deltaY < 0 ? 1.12 : 0.88)));
      _applyImgTx();
    }, { passive: false });
    imgModalImg.addEventListener('dblclick', function() {
      if (imgScale > 1.5) { imgScale = 1; imgX = 0; imgY = 0; }
      else imgScale = 2.5;
      _applyImgTx();
    });
    let _imgTouchDist = 0, _imgInitScale = 1;
    imgModal.addEventListener('touchstart', function(e) {
      if (e.touches.length === 2) {
        _imgTouchDist = Math.hypot(e.touches[0].clientX - e.touches[1].clientX, e.touches[0].clientY - e.touches[1].clientY);
        _imgInitScale = imgScale;
      }
    }, { passive: true });
    imgModal.addEventListener('touchmove', function(e) {
      if (e.touches.length === 2) {
        const d = Math.hypot(e.touches[0].clientX - e.touches[1].clientX, e.touches[0].clientY - e.touches[1].clientY);
        imgScale = Math.max(0.25, Math.min(10, _imgInitScale * (d / _imgTouchDist)));
        _applyImgTx();
        e.preventDefault();
      }
    }, { passive: false });

    // ── Mermaid Fullscreen Viewer ──────────────────────────────────────────
    const mermaidModal    = document.getElementById('mermaid-modal');
    const mermaidContainer = document.getElementById('modal-svg-container');
    let mScale=1, mX=0, mY=0, mDragging=false, mStart={x:0,y:0};
    let mTouchDist=0, mInitScale=1;

    document.addEventListener('dblclick', function(e) {
      const d = e.target.closest('.mermaid');
      if (!d) return;
      const svg = d.querySelector('svg');
      if (svg) openMermaidModal(svg.outerHTML);
    });
    function openMermaidModal(svgHtml) {
      mermaidModal.style.display = 'flex';
      mermaidContainer.innerHTML = svgHtml;
      mScale=1; mX=0; mY=0; _applyMermaidTx();
    }
    function closeMermaidModal() {
      mermaidModal.style.display = 'none';
      mermaidContainer.innerHTML = '';
    }
    function _applyMermaidTx() {
      mermaidContainer.style.transform = 'translate('+mX+'px,'+mY+'px) scale('+mScale+')';
    }
    mermaidContainer.addEventListener('mousedown', function(e) {
      mDragging=true; mStart={x:e.clientX-mX, y:e.clientY-mY};
      mermaidContainer.style.cursor='grabbing';
    });
    window.addEventListener('mousemove', function(e) {
      if (!mDragging) return; mX=e.clientX-mStart.x; mY=e.clientY-mStart.y; _applyMermaidTx();
    });
    window.addEventListener('mouseup', function() { mDragging=false; mermaidContainer.style.cursor='grab'; });
    mermaidContainer.addEventListener('wheel', function(e) {
      e.preventDefault();
      const xs=(e.clientX-mX)/mScale, ys=(e.clientY-mY)/mScale;
      mScale=e.deltaY<0?Math.min(8,mScale*1.15):Math.max(0.3,mScale/1.15);
      mX=e.clientX-xs*mScale; mY=e.clientY-ys*mScale; _applyMermaidTx();
    }, { passive: false });
    mermaidContainer.addEventListener('touchstart', function(e) {
      if (e.touches.length===1) { mDragging=true; mStart={x:e.touches[0].clientX-mX, y:e.touches[0].clientY-mY}; }
      else if (e.touches.length===2) { mDragging=false; mTouchDist=Math.hypot(e.touches[0].clientX-e.touches[1].clientX, e.touches[0].clientY-e.touches[1].clientY); mInitScale=mScale; }
    }, { passive: true });
    mermaidContainer.addEventListener('touchmove', function(e) {
      if (mDragging && e.touches.length===1) { mX=e.touches[0].clientX-mStart.x; mY=e.touches[0].clientY-mStart.y; _applyMermaidTx(); }
      else if (e.touches.length===2) {
        const d=Math.hypot(e.touches[0].clientX-e.touches[1].clientX, e.touches[0].clientY-e.touches[1].clientY);
        mScale=Math.max(0.3,Math.min(8,mInitScale*(d/mTouchDist))); _applyMermaidTx();
      }
      e.preventDefault();
    }, { passive: false });

    // ── Anchor: intercept #hash links → smooth scroll ─────────────────────
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
      if (e.target.closest('#img-modal,#mermaid-modal,.mermaid')) return;
      if (!e.target.closest('a,button,input,textarea')) {
        try { TibebBridge.postMessage('toggleControls'); } catch(_) {}
      }
    });

    // ── Scroll progress bridge ─────────────────────────────────────────────
    window.addEventListener('scroll', function() {
      const maxSc = document.documentElement.scrollHeight - window.innerHeight;
      const prog  = maxSc > 0 ? window.scrollY / maxSc : 0;
      try { TibebBridge.postMessage(String(prog)); } catch(_) {}
    }, { passive: true });

    // ── IntersectionObserver — active heading tracking ─────────────────────
    try {
      const _headingObserver = new IntersectionObserver(function(entries) {
        for (const entry of entries) {
          if (entry.isIntersecting) {
            try { TibebBridge.postMessage('activeHeading:' + entry.target.id); } catch(_) {}
            break;
          }
        }
      }, { rootMargin: '0px 0px -80% 0px', threshold: 0 });
      document.querySelectorAll('h1,h2,h3,h4,h5,h6').forEach(function(h) {
        _headingObserver.observe(h);
      });
    } catch(err) { console.warn('[IntersectionObserver]', err); }

    // ── ESC key closes all modals ──────────────────────────────────────────
    document.addEventListener('keydown', function(e) {
      if (e.key === 'Escape') { closeImageModal(); closeMermaidModal(); }
    });
''';
