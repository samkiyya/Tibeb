import 'package:flutter_riverpod/flutter_riverpod.dart';

class RankUpEvent {
  final int level;
  final String rankName;

  const RankUpEvent({required this.level, required this.rankName});
}

class RankEventNotifier extends Notifier<RankUpEvent?> {
  @override
  RankUpEvent? build() {
    return null;
  }

  void show(RankUpEvent event) {
    state = event;
  }

  void clear() {
    state = null;
  }
}

final rankEventProvider = NotifierProvider<RankEventNotifier, RankUpEvent?>(
  RankEventNotifier.new,
);
