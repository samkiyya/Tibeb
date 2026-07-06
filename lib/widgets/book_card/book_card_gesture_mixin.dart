import 'package:flutter/material.dart';

mixin BookCardGestureMixin<T extends StatefulWidget> on State<T> {
  Offset tapPosition = Offset.zero;

  void updateTapPosition(TapDownDetails details) {
    tapPosition = details.globalPosition;
  }
}