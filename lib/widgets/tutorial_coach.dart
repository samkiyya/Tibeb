import 'dart:async';
import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class TutorialHelper {
  /// Shows a TutorialCoachMark with a beautiful, fully transparent frosted blur backdrop.
  static void showTutorial({
    required BuildContext context,
    required List<TargetFocus> targets,
    required VoidCallback onFinish,
    required bool Function() onSkip,
    Color colorShadow = Colors.black,
    FutureOr<void> Function(TargetFocus)? onClickTarget,
  }) {
    TutorialCoachMark(
      targets: targets,
      colorShadow: Colors
          .black, // Force premium dark transparent shadow rather than custom raw colors
      opacityShadow: 0.2, // Fully transparent backdrop feel
      imageFilter: ImageFilter.blur(
        sigmaX: 5.0,
        sigmaY: 5.0,
      ), // Gorgeous frosted glass blur effect
      paddingFocus: 8,
      skipWidget: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Skip Tour",
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 4),
            Icon(Icons.close_rounded, color: Colors.white, size: 14),
          ],
        ),
      ),
      onClickTarget: onClickTarget,
      onFinish: onFinish,
      onSkip: onSkip,
    ).show(context: context);
  }

  /// Creates a standard TargetFocus with a styled card content bubble.
  static TargetFocus createTarget({
    required String identify,
    required GlobalKey keyTarget,
    required String title,
    required String description,
    AlignmentGeometry alignSkip = Alignment.topRight,
    ContentAlign contentAlign = ContentAlign.bottom,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    TextAlign textAlign = TextAlign.left,
  }) {
    return TargetFocus(
      identify: identify,
      keyTarget: keyTarget,
      alignSkip: alignSkip,
      paddingFocus: 8,
      contents: [
        TargetContent(
          align: contentAlign,
          builder: (context, controller) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            final primaryColor = Theme.of(context).primaryColor;

            return Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 320),
                padding: const EdgeInsets.all(18),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E1E2E).withValues(alpha: 0.85)
                      : Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.12)
                        : Colors.black.withValues(alpha: 0.08),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: crossAxisAlignment,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(
                              alpha: isDark ? 0.2 : 0.1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "GUIDE",
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: isDark ? primaryColor : primaryColor,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 18,
                      ),
                      textAlign: textAlign,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black87,
                        fontSize: 13,
                        height: 1.4,
                      ),
                      textAlign: textAlign,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
