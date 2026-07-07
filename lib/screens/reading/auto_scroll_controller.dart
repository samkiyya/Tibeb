import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Owns the PDF auto-scroll ticker and speed-change handling.
/// The widget creates the [Ticker] via [TickerProvider] and passes it here.
class AutoScrollController {
  Ticker? _ticker;
  Duration _lastElapsed = Duration.zero;

  bool isScrolling = false;

  /// The notifier whose value drives scroll speed (pixels/s factor).
  /// Set by the screen and shared with child widgets.
  final ValueNotifier<double> speedNotifier = ValueNotifier(0.0);

  /// Called by the ticker on every frame.
  void Function(Duration elapsed)? _onTick;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  /// Call from [State.initState] with the widget's [TickerProvider].
  void init(TickerProvider vsync, PdfControllerGetter getPdfController) {
    _ticker = vsync.createTicker((elapsed) {
      final pdfCtl = getPdfController();
      if (isScrolling && pdfCtl != null) {
        final speed = speedNotifier.value;
        if (speed <= 0) return;
        final delta = (elapsed - _lastElapsed).inMilliseconds / 1000.0;
        _lastElapsed = elapsed;
        if (delta <= 0) return;
        final matrix = pdfCtl.value;
        final dy = speed * 30.0 * delta;
        pdfCtl.value = matrix.clone()..translateByDouble(0.0, -dy, 0.0, 1.0);
      } else {
        _lastElapsed = elapsed;
      }
      _onTick?.call(elapsed);
    });
    speedNotifier.addListener(_onSpeedChanged);
  }

  void dispose() {
    speedNotifier.removeListener(_onSpeedChanged);
    _ticker?.dispose();
    speedNotifier.dispose();
  }

  // ── Controls ──────────────────────────────────────────────────────────────

  /// Toggle auto-scroll on/off. [settingsSpeed] is the user's saved speed.
  /// Returns the active speed value applied to [speedNotifier].
  double toggle(double settingsSpeed) {
    isScrolling = !isScrolling;
    final active = settingsSpeed < 0.5 ? 2.0 : settingsSpeed;
    speedNotifier.value = isScrolling ? active : 0.0;
    return speedNotifier.value;
  }

  /// Sync notifier value with settings when auto-scroll is active.
  void syncSpeed(double settingsSpeed) {
    if (isScrolling && speedNotifier.value != settingsSpeed) {
      speedNotifier.value = settingsSpeed;
    }
  }

  // ── Internal ──────────────────────────────────────────────────────────────

  void _onSpeedChanged() {
    final isEpub = _isEpubGetter?.call() ?? false;
    if (isEpub) return;
    if (speedNotifier.value > 0) {
      if (!(_ticker?.isActive ?? false)) _ticker?.start();
    } else {
      _ticker?.stop();
    }
  }

  /// Inject to let the speed listener know the current format.
  bool Function()? _isEpubGetter;
  set isEpubGetter(bool Function() fn) => _isEpubGetter = fn;
}

/// Typedef for the callback that retrieves the live PdfViewerController matrix.
typedef PdfControllerGetter = dynamic Function();
