// providers/navigation_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationState {
  final int current;
  final int previous;
  
  NavigationState({required this.current, required this.previous});
}

final navigationStateProvider = StateProvider<NavigationState>(
  (ref) => NavigationState(current: 0, previous: 0),
);