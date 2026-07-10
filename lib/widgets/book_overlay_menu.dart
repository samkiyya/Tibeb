import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/book_model.dart';
import '../core/theme/theme.dart';
import '../l10n/app_localizations.dart';
import 'glass_container.dart';

class BookOverlayMenu extends ConsumerStatefulWidget {
  final Book book;
  final Offset position;
  final VoidCallback onDismiss;
  final Function(String) onAction;

  const BookOverlayMenu({
    super.key,
    required this.book,
    required this.position,
    required this.onDismiss,
    required this.onAction,
  });

  static void show({
    required BuildContext context,
    required Book book,
    required Offset position,
    required Function(String) onAction,
  }) {
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => BookOverlayMenu(
        book: book,
        position: position,
        onDismiss: () => overlayEntry.remove(),
        onAction: (action) {
          overlayEntry.remove();
          onAction(action);
        },
      ),
    );
    Overlay.of(context).insert(overlayEntry);
  }

  @override
  ConsumerState<BookOverlayMenu> createState() => _BookOverlayMenuState();
}

class _BookOverlayMenuState extends ConsumerState<BookOverlayMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final t = context.tibpiColors;
    final l10n = AppLocalizations.of(context)!;

    // Adjust position to avoid going off screen
    double left = widget.position.dx;
    double top = widget.position.dy;
    const menuWidth = 200.0;
    const menuHeight = 180.0;

    if (left + menuWidth > size.width - 16) {
      left = size.width - menuWidth - 16;
    }
    if (top + menuHeight > size.height - 16) {
      top = size.height - menuHeight - 16;
    }

    return GestureDetector(
      onTap: widget.onDismiss,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          Positioned(
            left: left,
            top: top,
            child: FadeTransition(
              opacity: _animation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Material(
                  color: Colors.transparent,
                  child: GlassContainer(
                    width: menuWidth,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    borderRadius: 16,
                    color: t.surface,
                    opacity: 0.8,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildMenuItem(
                          t: t,
                          icon: widget.book.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          label: widget.book.isFavorite
                              ? l10n.unfavorite
                              : l10n.favorite,
                          color: widget.book.isFavorite ? t.error : null,
                          onTap: () => widget.onAction('favorite'),
                        ),
                        _buildMenuItem(
                          t: t,
                          icon: Icons.edit_outlined,
                          label: l10n.editInfo,
                          onTap: () => widget.onAction('edit'),
                        ),
                        Divider(
                          color: t.borderSubtle,
                          height: 1,
                          indent: 12,
                          endIndent: 12,
                        ),
                        _buildMenuItem(
                          t: t,
                          icon: Icons.delete_outline,
                          label: l10n.remove,
                          color: t.error,
                          onTap: () => widget.onAction('delete'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required TibebThemeExtension t,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color ?? t.textSecondary),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: color ?? t.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
