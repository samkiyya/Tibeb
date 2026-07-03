import 'package:flutter/material.dart';
import '../../../foundation/foundation.dart';

/// Knowledge Graph feature design tokens.
class TibebKnowledgeGraphThemeTokens {
  final Color node;
  final Color edge;
  final Color selectedNode;
  final Color relatedNode;
  final Color bookNode;
  final Color personNode;
  final Color conceptNode;
  final Color tagNode;

  const TibebKnowledgeGraphThemeTokens({
    required this.node,
    required this.edge,
    required this.selectedNode,
    required this.relatedNode,
    required this.bookNode,
    required this.personNode,
    required this.conceptNode,
    required this.tagNode,
  });

  factory TibebKnowledgeGraphThemeTokens.light(TibebColorSystem colors) {
    return TibebKnowledgeGraphThemeTokens(
      node: colors.primary,
      edge: colors.outline,
      selectedNode: colors.primary,
      relatedNode: colors.secondary,
      bookNode: colors.primary,
      personNode: colors.success,
      conceptNode: colors.info,
      tagNode: colors.warning,
    );
  }

  factory TibebKnowledgeGraphThemeTokens.dark(TibebColorSystem colors) {
    return TibebKnowledgeGraphThemeTokens(
      node: colors.primary,
      edge: colors.outline,
      selectedNode: colors.primary,
      relatedNode: colors.secondary,
      bookNode: colors.primary,
      personNode: colors.success,
      conceptNode: colors.info,
      tagNode: colors.warning,
    );
  }
}
