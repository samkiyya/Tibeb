import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../core/theme/theme.dart';
import '../../l10n/app_localizations.dart';

class StorageSettingsSheet extends ConsumerStatefulWidget {
  const StorageSettingsSheet({super.key});

  @override
  ConsumerState<StorageSettingsSheet> createState() => _StorageSettingsSheetState();
}

class _StorageSettingsSheetState extends ConsumerState<StorageSettingsSheet> {
  Map<String, int> storageInfo = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStorageInfo();
  }

  Future<void> _loadStorageInfo() async {
    setState(() => isLoading = true);
    
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final cacheDir = await getTemporaryDirectory();
      
      final appDocSize = await _getFolderSize(appDocDir);
      final cacheSize = await _getFolderSize(cacheDir);
      
      setState(() {
        storageInfo = {
          'appDocuments': appDocSize,
          'cache': cacheSize,
          'total': appDocSize + cacheSize,
        };
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<int> _getFolderSize(Directory dir) async {
    int totalSize = 0;
    
    try {
      if (await dir.exists()) {
        await for (final entity in dir.list(recursive: true, followLinks: false)) {
          if (entity is File) {
            totalSize += await entity.length();
          }
        }
      }
    } catch (e) {
      // Ignore permission errors
    }
    
    return totalSize;
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  Future<void> _clearCache() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      if (await cacheDir.exists()) {
        cacheDir.deleteSync(recursive: true);
      }
      await _loadStorageInfo();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Cache cleared successfully',
              style: TextStyle(color: context.tibpiColors.textPrimary),
            ),
            backgroundColor: context.tibpiColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to clear cache',
              style: TextStyle(color: context.tibpiColors.textPrimary),
            ),
            backgroundColor: context.tibpiColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.storage,
            style: TextStyle(
              color: t.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else
            Column(
              children: [
                _buildStorageCard(
                  icon: Icons.folder_rounded,
                  title: 'App Documents',
                  subtitle: 'Books, settings, and data',
                  size: storageInfo['appDocuments'] ?? 0,
                  t: t,
                ),
                const SizedBox(height: 12),
                _buildStorageCard(
                  icon: Icons.cached_rounded,
                  title: 'Cache',
                  subtitle: 'Temporary files',
                  size: storageInfo['cache'] ?? 0,
                  t: t,
                ),
                const SizedBox(height: 12),
                _buildStorageCard(
                  icon: Icons.storage_rounded,
                  title: 'Total Storage',
                  subtitle: 'Total app storage used',
                  size: storageInfo['total'] ?? 0,
                  t: t,
                  isTotal: true,
                ),
              ],
            ),
          
          const SizedBox(height: 24),
          
          if (!isLoading)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _clearCache,
                style: ElevatedButton.styleFrom(
                  backgroundColor: t.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Clear Cache',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildStorageCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required int size,
    required TibebThemeExtension t,
    bool isTotal = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isTotal 
            ? t.primary.withValues(alpha: 0.1)
            : t.surface.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isTotal ? t.primary : t.borderSubtle,
          width: isTotal ? 2.0 : 1.0,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isTotal 
                  ? t.primary.withValues(alpha: 0.2)
                  : t.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: isTotal ? t.primary : t.primary.withValues(alpha: 0.7),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isTotal ? t.primary : t.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: t.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            _formatBytes(size),
            style: TextStyle(
              color: isTotal ? t.primary : t.textSecondary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}