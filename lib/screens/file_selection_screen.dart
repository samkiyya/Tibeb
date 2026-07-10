import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import '../core/theme/theme.dart';
import '../l10n/app_localizations.dart';

class FileSelectionScreen extends StatefulWidget {
  final String directoryPath;
  final List<File> files;

  const FileSelectionScreen({
    super.key,
    required this.directoryPath,
    required this.files,
  });

  @override
  State<FileSelectionScreen> createState() => _FileSelectionScreenState();
}

class _FileSelectionScreenState extends State<FileSelectionScreen> {
  late List<bool> _selected;
  bool _selectAll = false;

  @override
  void initState() {
    super.initState();
    _selected = List.filled(widget.files.length, false);
  }

  void _toggleSelectAll(bool? value) {
    if (value == null) return;
    setState(() {
      _selectAll = value;
      for (int i = 0; i < _selected.length; i++) {
        _selected[i] = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selectedCount = _selected.where((s) => s).length;
    final theme = context.tibpiColors;

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.selectFilesTitle,
              style: TextStyle(color: theme.textPrimary),
            ),
            Text(
              p.basename(widget.directoryPath),
              style: TextStyle(fontSize: 12, color: theme.textSecondary),
            ),
          ],
        ),
        actions: [
          if (selectedCount > 0)
            TextButton(
              onPressed: () {
                final result = <String>[];
                for (int i = 0; i < widget.files.length; i++) {
                  if (_selected[i]) {
                    result.add(widget.files[i].path);
                  }
                }
                Navigator.pop(context, result);
              },
              child: Text(l10n.importCount(selectedCount)),
            ),
        ],
      ),
      body: Column(
        children: [
          CheckboxListTile(
            title: Text(
              l10n.selectAll,
              style: TextStyle(color: theme.textPrimary),
            ),
            value: _selectAll,
            onChanged: _toggleSelectAll,
            activeColor: theme.accent,
          ),
          Divider(color: theme.borderSubtle, height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: widget.files.length,
              itemBuilder: (context, index) {
                final file = widget.files[index];
                final fileName = p.basename(file.path);
                final relativePath = p.relative(
                  file.path,
                  from: widget.directoryPath,
                );
                final extension = p.extension(file.path).toLowerCase();

                IconData icon;
                Color iconColor;
                if (extension == '.epub') {
                  icon = Icons.book_outlined;
                  iconColor = theme.primary;
                } else if (extension == '.pdf') {
                  icon = Icons.picture_as_pdf_outlined;
                  iconColor = theme.error;
                } else if (extension == '.md') {
                  icon = Icons.code_rounded;
                  iconColor = theme.accent;
                } else if (extension == '.txt') {
                  icon = Icons.text_snippet_outlined;
                  iconColor = theme.textSecondary;
                } else {
                  icon = Icons.insert_drive_file_outlined;
                  iconColor = theme.textTertiary;
                }

                return CheckboxListTile(
                  title: Text(
                    fileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: theme.textPrimary),
                  ),
                  subtitle: Text(
                    relativePath,
                    style: TextStyle(fontSize: 10, color: theme.textSecondary),
                  ),
                  secondary: Icon(icon, color: iconColor),
                  value: _selected[index],
                  onChanged: (bool? value) {
                    setState(() {
                      _selected[index] = value ?? false;
                      _selectAll = _selected.every((s) => s);
                    });
                  },
                  activeColor: theme.accent,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
