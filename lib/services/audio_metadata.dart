import 'package:flutter/foundation.dart';

/// Holds the extracted metadata fields from an audio file.
/// All fields are nullable — a parser may not find every field.
class AudioMetadata {
  const AudioMetadata({
    this.title,
    this.author,
    this.coverBytes,
    this.coverMime,
  });

  /// Constant representing "nothing was found" — avoids allocating new objects
  /// in the common failure path.
  static const AudioMetadata empty = AudioMetadata();

  final String? title;
  final String? author;

  /// Raw image bytes of the embedded cover art.
  final Uint8List? coverBytes;

  /// MIME type of [coverBytes], e.g. `"image/jpeg"` or `"image/png"`.
  final String? coverMime;

  bool get hasContent =>
      title != null || author != null || coverBytes != null;

  @override
  String toString() =>
      'AudioMetadata(title: $title, author: $author, hasCover: ${coverBytes != null})';
}
