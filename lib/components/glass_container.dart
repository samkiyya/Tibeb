import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/theme/semantics/color_scheme.dart';
import '../core/theme/tokens/radius.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double blur;
  final double opacity;
  final Color? color;
  final double borderRadius;
  final VoidCallback? onTap;
  final bool enabled;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.blur = 12.0,
    this.opacity = 0.08,
    this.color,
    this.borderRadius = TibebRadius.lg,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;
    final content = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: enabled
            ? ImageFilter.blur(sigmaX: blur, sigmaY: blur)
            : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: (color ?? t.glass).withValues(alpha: opacity),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              width: 1.5,
              color: t.glassBorder.withValues(alpha: 0.05),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                t.glass.withValues(alpha: 0.1),
                t.glass.withValues(alpha: 0.01),
              ],
            ),
          ),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: content);
    }
    return content;
  }
}
