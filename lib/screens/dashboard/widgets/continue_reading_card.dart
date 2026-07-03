import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/semantics/color_scheme.dart';
import '../../../core/theme/tokens/radius.dart';
import '../../../core/theme/tokens/spacing.dart';
import '../../../components/glass_container.dart';
import '../../../models/book_model.dart';
import '../../../providers/library_provider.dart';
import '../../reading_screen.dart';

class ContinueReadingCard extends ConsumerStatefulWidget {
  final Book book;
  final Function(Offset)? onLongPress;
  final Function(Offset)? onMenuPressed;

  const ContinueReadingCard({
    super.key,
    required this.book,
    this.onLongPress,
    this.onMenuPressed,
  });

  @override
  ConsumerState<ContinueReadingCard> createState() =>
      _ContinueReadingCardState();
}

class _ContinueReadingCardState extends ConsumerState<ContinueReadingCard> {
  Offset _tapPosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          _tapPosition = details.globalPosition;
        });
      },
      onTap: () {
        ref.read(currentlyReadingProvider.notifier).state = widget.book;
        ref.read(libraryProvider.notifier).markBookAsOpened(widget.book);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ReadingScreen()),
        );
      },
      onLongPress: () {
        if (widget.onLongPress != null) widget.onLongPress!(_tapPosition);
      },
      onSecondaryTapDown: (details) {
        setState(() {
          _tapPosition = details.globalPosition;
        });
      },
      onSecondaryTap: () {
        if (widget.onLongPress != null) widget.onLongPress!(_tapPosition);
      },
      child: GlassContainer(
        padding: const EdgeInsets.all(TibebSpacing.base),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: TibebRadius.borderSm,
                color: t.surfaceOverlay,
                boxShadow: t.card.shadow,
              ),
              child: ClipRRect(
                borderRadius: TibebRadius.borderSm,
                child: widget.book.coverPath.startsWith('assets')
                    ? Image.asset(
                        widget.book.coverPath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Image.asset(
                            'assets/icon.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
                    : Image.file(
                        File(widget.book.coverPath),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Image.asset(
                            'assets/icon.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.book.title,
                          style: context.textTheme.headlineSmall?.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: t.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (widget.onMenuPressed != null)
                        InkWell(
                          onTapDown: (details) {
                            setState(() {
                              _tapPosition = details.globalPosition;
                            });
                          },
                          onTap: () => widget.onMenuPressed!(_tapPosition),
                          borderRadius: TibebRadius.borderPill,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.more_vert,
                              color: t.textSecondary,
                            ),
                          ),
                        ),
                    ],
                  ),
                  Text(
                    widget.book.author,
                    style: TextStyle(color: t.textSecondary, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: widget.book.progress,
                          backgroundColor: t.borderSubtle,
                          valueColor: AlwaysStoppedAnimation<Color>(t.primary),
                          minHeight: 4,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${(widget.book.progress * 100).toInt()}%',
                        style: TextStyle(
                          color: t.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
