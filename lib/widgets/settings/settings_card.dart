import 'package:flutter/material.dart';
import '../glass_container.dart';

class SettingsCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const SettingsCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: padding ?? const EdgeInsets.all(16),
      onTap: onTap,
      child: child,
    );
  }
}