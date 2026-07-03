import 'package:flutter/material.dart';
import '../../../foundation/foundation.dart';

/// Sync feature design tokens.
class TibebSyncThemeTokens {
  final Color syncing;
  final Color success;
  final Color conflict;
  final Color offline;
  final Color cloud;
  final Color backup;

  const TibebSyncThemeTokens({
    required this.syncing,
    required this.success,
    required this.conflict,
    required this.offline,
    required this.cloud,
    required this.backup,
  });

  factory TibebSyncThemeTokens.light(TibebColorSystem colors) {
    return TibebSyncThemeTokens(
      syncing: colors.info,
      success: colors.success,
      conflict: colors.warning,
      offline: colors.disabled,
      cloud: colors.primary,
      backup: colors.secondary,
    );
  }

  factory TibebSyncThemeTokens.dark(TibebColorSystem colors) {
    return TibebSyncThemeTokens(
      syncing: colors.info,
      success: colors.success,
      conflict: colors.warning,
      offline: colors.disabled,
      cloud: colors.primary,
      backup: colors.secondary,
    );
  }
}
