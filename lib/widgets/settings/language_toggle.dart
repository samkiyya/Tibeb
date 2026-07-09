import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tibeb/providers/settings_provider.dart';
import '../../core/theme/theme.dart';
import '../../core/constants/app_constants.dart';
import '../../services/localization_service.dart';

class LanguageToggle extends ConsumerWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tibpiColors;
    final currentLanguage = ref.watch(settingsProvider).selectedLanguage ?? 'en';

    return Column(
      children: [
        ...AppConstants.supportedLanguages.map((languageCode) {
          final isSelected = currentLanguage == languageCode;
          final languageName = AppConstants.languageNames[languageCode] ?? languageCode;
          
          return _buildLanguageTile(
            t: t,
            languageCode: languageCode,
            languageName: languageName,
            isSelected: isSelected,
            onTap: () async {
              await ref.read(settingsProvider.notifier).setLanguage(languageCode);
              await LocalizationService.saveLanguage(languageCode);
            },
          );
        }),
      ],
    );
  }

  Widget _buildLanguageTile({
    required TibebThemeExtension t,
    required String languageCode,
    required String languageName,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected 
                  ? t.primary.withValues(alpha: 0.1)
                  : t.surface.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.language_rounded,
              color: isSelected ? t.primary : t.textSecondary,
              size: 20,
            ),
          ),
          title: Text(
            languageName,
            style: TextStyle(
              color: isSelected ? t.textPrimary : t.textSecondary,
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          trailing: isSelected
              ? Icon(Icons.check_circle_rounded, color: t.primary, size: 20)
              : null,
          onTap: onTap,
        ),
        if (languageCode != AppConstants.supportedLanguages.last)
          Divider(color: t.borderSubtle, height: 1),
      ],
    );
  }
}