import 'package:flutter/material.dart';

/// Reader feature design tokens.
///
/// Covers all typographic, chromatic, and layout values for the
/// in-app book reader — supporting both light (paper) and dark (night) modes.
class TibebReaderThemeTokens {
  final Color background;
  final TextStyle text;
  final TextStyle heading;
  final TextStyle quote;
  final Color link;
  final TextStyle code;
  final TextStyle footnote;
  final TextStyle annotation;
  final Color highlightYellow;
  final Color highlightGreen;
  final Color highlightBlue;
  final Color highlightPink;
  final Color highlightOrange;
  final Color bookmark;
  final Color selection;
  final Color caret;
  final TextStyle pageNumber;
  final TextStyle chapter;
  final double paragraphSpacing;
  final double lineHeight;
  final double margin;
  final String font;
  final TextStyle dropCap;
  final BoxDecoration images;
  final BoxDecoration tables;
  final TextStyle lists;
  final TextStyle blockquote;
  final TextStyle inlineCode;

  const TibebReaderThemeTokens({
    required this.background,
    required this.text,
    required this.heading,
    required this.quote,
    required this.link,
    required this.code,
    required this.footnote,
    required this.annotation,
    required this.highlightYellow,
    required this.highlightGreen,
    required this.highlightBlue,
    required this.highlightPink,
    required this.highlightOrange,
    required this.bookmark,
    required this.selection,
    required this.caret,
    required this.pageNumber,
    required this.chapter,
    required this.paragraphSpacing,
    required this.lineHeight,
    required this.margin,
    required this.font,
    required this.dropCap,
    required this.images,
    required this.tables,
    required this.lists,
    required this.blockquote,
    required this.inlineCode,
  });

  factory TibebReaderThemeTokens.dark() {
    return TibebReaderThemeTokens(
      background: Colors.black,
      text: const TextStyle(color: Colors.white, fontSize: 18),
      heading: const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      quote: const TextStyle(
        color: Colors.white70,
        fontSize: 18,
        fontStyle: FontStyle.italic,
      ),
      link: Colors.amber,
      code: const TextStyle(
        color: Colors.white54,
        fontFamily: 'Courier',
        fontSize: 14,
      ),
      footnote: const TextStyle(color: Colors.white60, fontSize: 12),
      annotation: const TextStyle(color: Colors.white60, fontSize: 13),
      highlightYellow: Colors.yellow.withValues(alpha: 0.3),
      highlightGreen: Colors.green.withValues(alpha: 0.3),
      highlightBlue: Colors.blue.withValues(alpha: 0.3),
      highlightPink: Colors.pink.withValues(alpha: 0.3),
      highlightOrange: Colors.orange.withValues(alpha: 0.3),
      bookmark: Colors.amber,
      selection: Colors.amber.withValues(alpha: 0.4),
      caret: Colors.amber,
      pageNumber: const TextStyle(color: Colors.white38, fontSize: 11),
      chapter: const TextStyle(color: Colors.white60, fontSize: 14),
      paragraphSpacing: 16.0,
      lineHeight: 1.6,
      margin: 20.0,
      font: 'System',
      dropCap: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
      images: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      tables: BoxDecoration(border: Border.all(color: Colors.white24)),
      lists: const TextStyle(),
      blockquote: const TextStyle(
        color: Colors.white60,
        fontStyle: FontStyle.italic,
      ),
      inlineCode: const TextStyle(fontFamily: 'Courier', fontSize: 14),
    );
  }

  factory TibebReaderThemeTokens.light() {
    return TibebReaderThemeTokens(
      background: const Color(0xFFFDFBF7),
      text: const TextStyle(color: Color(0xFF1A1A1A), fontSize: 18),
      heading: const TextStyle(
        color: Color(0xFF1A1A1A),
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      quote: const TextStyle(
        color: Color(0xFF333333),
        fontSize: 18,
        fontStyle: FontStyle.italic,
      ),
      link: Colors.brown,
      code: const TextStyle(
        color: Colors.black54,
        fontFamily: 'Courier',
        fontSize: 14,
      ),
      footnote: const TextStyle(color: Colors.black54, fontSize: 12),
      annotation: const TextStyle(color: Colors.black54, fontSize: 13),
      highlightYellow: Colors.yellow.withValues(alpha: 0.4),
      highlightGreen: Colors.green.withValues(alpha: 0.4),
      highlightBlue: Colors.blue.withValues(alpha: 0.4),
      highlightPink: Colors.pink.withValues(alpha: 0.4),
      highlightOrange: Colors.orange.withValues(alpha: 0.4),
      bookmark: Colors.brown,
      selection: Colors.brown.withValues(alpha: 0.2),
      caret: Colors.brown,
      pageNumber: const TextStyle(color: Colors.black38, fontSize: 11),
      chapter: const TextStyle(color: Colors.black54, fontSize: 14),
      paragraphSpacing: 16.0,
      lineHeight: 1.6,
      margin: 20.0,
      font: 'System',
      dropCap: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
      images: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      tables: BoxDecoration(border: Border.all(color: Colors.black26)),
      lists: const TextStyle(),
      blockquote: const TextStyle(
        color: Colors.black54,
        fontStyle: FontStyle.italic,
      ),
      inlineCode: const TextStyle(fontFamily: 'Courier', fontSize: 14),
    );
  }
}
