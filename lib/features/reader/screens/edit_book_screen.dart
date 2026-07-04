// features/reader/screens/edit_book_screen.dart
// Clean replacement — uses go_router for navigation instead of Navigator.push.

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:tibeb/shared/services/book_service.dart';

import '../../../app/router.dart';
import '../../../core/theme/theme.dart';
import '../../../features/library/providers/library_provider.dart';
import '../../../shared/models/book_model.dart';

class EditBookScreen extends ConsumerStatefulWidget {
  final Book book;
  const EditBookScreen({super.key, required this.book});

  @override
  ConsumerState<EditBookScreen> createState() => _EditBookScreenState();
}

class _EditBookScreenState extends ConsumerState<EditBookScreen> {
  late final TextEditingController _title;
  late final TextEditingController _author;
  late final TextEditingController _series;
  late final TextEditingController _tags;
  String? _coverPath;
  late List<AudioTrack> _tracks;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.book.title);
    _author = TextEditingController(text: widget.book.author);
    _series = TextEditingController(text: widget.book.series ?? '');
    _tags = TextEditingController(text: widget.book.tags ?? '');
    _coverPath = widget.book.coverPath;
    _tracks = List.from(widget.book.audioTracks);
    if (widget.book.audioPath != null &&
        widget.book.audioPath!.isNotEmpty &&
        _tracks.isEmpty) {
      _tracks.add(AudioTrack(
          path: widget.book.audioPath!,
          title: p.basename(widget.book.audioPath!)));
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _author.dispose();
    _series.dispose();
    _tags.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final updated = widget.book.copyWith(
      title: _title.text.trim(),
      author: _author.text.trim(),
      series: _series.text.trim().isEmpty ? null : _series.text.trim(),
      tags: _tags.text.trim().isEmpty ? null : _tags.text.trim(),
      coverPath: _coverPath ?? widget.book.coverPath,
      audioTracks: _tracks,
      audioPath: _tracks.isNotEmpty ? _tracks.first.path : null,
    );
    await ref.read(libraryNotifierProvider.notifier).updateBook(updated);
    if (mounted) {
      context.pop();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Book updated')));
    }
  }

  Future<void> _pickCover() async {
    final result =
        await FilePicker.pickFiles(type: FileType.image, allowMultiple: false);
    if (result?.files.single.path != null) {
      final newPath =
          await BookService().saveLocalCover(File(result!.files.single.path!));
      if (newPath.isNotEmpty) setState(() => _coverPath = newPath);
    }
  }

  Future<void> _pickAudio() async {
    final result =
        await FilePicker.pickFiles(type: FileType.audio, allowMultiple: true);
    if (result == null) return;
    int dups = 0;
    setState(() {
      for (final path in result.paths) {
        if (path == null) continue;
        if (_tracks.any((t) => t.path == path)) {
          dups++;
        } else {
          _tracks.add(AudioTrack(path: path, title: p.basename(path)));
        }
      }
    });
    if (dups > 0 && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Skipped $dups duplicate files')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;
    return Scaffold(
      backgroundColor: t.background,
      appBar: AppBar(
        backgroundColor: t.background,
        elevation: 0,
        title: Text('Edit Book',
            style: TextStyle(
                color: t.textPrimary, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
              icon: Icon(Icons.check, color: t.primary), onPressed: _save),
        ],
      ),
      body: ReorderableListView.builder(
        padding: const EdgeInsets.all(20),
        onReorderItem: (old, newIdx) {
          setState(() {
            if (old < newIdx) newIdx--;
            final tr = _tracks.removeAt(old);
            _tracks.insert(newIdx, tr);
          });
        },
        header: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _TextField(t: t, label: 'Title', controller: _title),
          const SizedBox(height: 20),
          _TextField(t: t, label: 'Author', controller: _author),
          const SizedBox(height: 20),
          _TextField(t: t, label: 'Series', controller: _series),
          const SizedBox(height: 20),
          _TextField(
              t: t, label: 'Tags (comma separated)', controller: _tags),
          const SizedBox(height: 30),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Audiobook Parts',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: t.textPrimary)),
            if (_tracks.isNotEmpty)
              Text('${_tracks.length} items',
                  style: TextStyle(color: t.textSecondary, fontSize: 12)),
          ]),
          const SizedBox(height: 10),
          if (_tracks.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text('No audio parts attached.',
                  style: TextStyle(color: t.textSecondary)),
            ),
        ]),
        footer: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: _pickAudio,
            icon: const Icon(Icons.add),
            label: const Text('Add Audio Parts'),
            style: OutlinedButton.styleFrom(
              foregroundColor: t.primary,
              side: BorderSide(color: t.primary.withValues(alpha: 0.5)),
              shape: RoundedRectangleBorder(
                  borderRadius: TibebRadius.borderMd),
            ),
          ),
          const SizedBox(height: 40),
          Text('Book Cover',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: t.textPrimary)),
          const SizedBox(height: 10),
          if (_coverPath != null && _coverPath!.isNotEmpty)
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _coverPath!.startsWith('http')
                    ? Image.network(_coverPath!,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            Image.asset('assets/icon.png', height: 200))
                    : Image.file(File(_coverPath!),
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            Image.asset('assets/icon.png', height: 200)),
              ),
            ),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _pickCover,
                icon: const Icon(Icons.file_upload_outlined),
                label: const Text('Pick from file'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: t.primary,
                  side: BorderSide(
                      color: t.primary.withValues(alpha: 0.5)),
                  shape: RoundedRectangleBorder(
                      borderRadius: TibebRadius.borderMd),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  final query =
                      '${_title.text} ${_author.text}';
                  final url = await context.push<String>(
                      AppRoutes.imageSearch, extra: query);
                  if (url != null && mounted) {
                    final newPath =
                        await BookService().downloadCover(url);
                    if (newPath.isNotEmpty) {
                      setState(() => _coverPath = newPath);
                    }
                  }
                },
                icon: const Icon(Icons.image_search),
                label: const Text('Search online'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: t.primary,
                  side: BorderSide(
                      color: t.primary.withValues(alpha: 0.5)),
                  shape: RoundedRectangleBorder(
                      borderRadius: TibebRadius.borderMd),
                ),
              ),
            ),
          ]),
          const SizedBox(height: 40),
        ]),
        itemCount: _tracks.length,
        itemBuilder: (_, index) {
          final track = _tracks[index];
          return Card(
            key: ValueKey(track.path + index.toString()),
            color: t.surface,
            shape: RoundedRectangleBorder(
                borderRadius: TibebRadius.borderMd),
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              dense: true,
              title: Text(track.title,
                  style: TextStyle(color: t.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              subtitle: Text(p.basename(track.path),
                  style:
                      TextStyle(color: t.textSecondary, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(
                    icon: Icon(Icons.delete, color: t.error),
                    onPressed: () =>
                        setState(() => _tracks.removeAt(index))),
                Icon(Icons.drag_handle, color: t.textSecondary),
              ]),
            ),
          );
        },
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  final TibebThemeExtension t;
  final String label;
  final TextEditingController controller;
  const _TextField(
      {required this.t, required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(color: t.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: t.textSecondary),
        enabledBorder: OutlineInputBorder(
            borderRadius: TibebRadius.borderMd,
            borderSide: BorderSide(color: t.borderSubtle)),
        focusedBorder: OutlineInputBorder(
            borderRadius: TibebRadius.borderMd,
            borderSide: BorderSide(color: t.primary)),
      ),
    );
  }
}
