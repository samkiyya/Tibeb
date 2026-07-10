import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../core/theme/theme.dart';
import '../l10n/app_localizations.dart';

class GoogleImageSearchScreen extends StatefulWidget {
  final String query;

  const GoogleImageSearchScreen({super.key, required this.query});

  @override
  State<GoogleImageSearchScreen> createState() =>
      _GoogleImageSearchScreenState();
}

class _GoogleImageSearchScreenState extends State<GoogleImageSearchScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    final String searchUrl =
        'https://www.google.com/search?tbm=isch&q=${Uri.encodeComponent("${widget.query} book cover")}';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (progress == 100) {
              _injectSelectionScript();
            }
          },
          onPageStarted: (String url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
            _injectSelectionScript();
            // Inject again after a short delay to handle potential hydration/SPA updates
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) _injectSelectionScript();
            });
          },
          onUrlChange: (UrlChange change) {
            _injectSelectionScript();
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView error: ${error.description}');
          },
        ),
      )
      ..addJavaScriptChannel(
        'ImageSelectionChannel',
        onMessageReceived: (JavaScriptMessage message) {
          final String imageUrl = message.message;
          if (imageUrl.isNotEmpty) {
            _showConfirmationDialog(imageUrl);
          }
        },
      )
      ..loadRequest(Uri.parse(searchUrl));
  }

  void _injectSelectionScript() {
    const String script = """
      (function() {
        if (window.tibebInjected) return;
        window.tibebInjected = true;

        document.addEventListener('click', function(e) {
          var target = e.target;

          while (target && target.tagName !== 'IMG' && target !== document.body) {
            target = target.parentElement;
          }

          if (target && target.tagName === 'IMG') {
            var src = target.src;
            if (src && src.startsWith('http')) {
               ImageSelectionChannel.postMessage(src);
               e.preventDefault();
               e.stopPropagation();
            }
          }
        }, true);
      })();
    """;
    _controller.runJavaScript(script);
  }

  void _showConfirmationDialog(String url) {
    final l10n = AppLocalizations.of(context)!;
    final t = context.tibpiColors;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: t.surface,
        title: Text(l10n.useThisImage, style: TextStyle(color: t.textPrimary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                url,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 50),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.useThisImageMessage,
              style: TextStyle(color: t.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel, style: TextStyle(color: t.textTertiary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context, url); // Return URL to previous screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.tibpiColors.accent,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.selectImage2),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.webSearch(widget.query)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.reload(),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
