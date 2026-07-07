import 'package:flutter_riverpod/flutter_riverpod.dart';


class NavigationState {
  final int current;
  final int previous;

  const NavigationState({
    required this.current,
    required this.previous,
  });
}


class NavigationNotifier extends Notifier<NavigationState> {

  @override
  NavigationState build() {
    return const NavigationState(
      current: 0,
      previous: 0,
    );
  }


  void changeTab(int index) {

    state = NavigationState(
      current: index,
      previous: state.current,
    );

  }
}


final navigationStateProvider =
    NotifierProvider<
      NavigationNotifier,
      NavigationState
    >(
      NavigationNotifier.new,
    );





enum NavigationEventType {
  openReader,
}



class NavigationEvent {

  final NavigationEventType type;
  final dynamic data;


  const NavigationEvent({
    required this.type,
    this.data,
  });

}



class NavigationEventNotifier
    extends Notifier<NavigationEvent?> {


  @override
  NavigationEvent? build() {
    return null;
  }



  void send(NavigationEvent event) {
    state = event;
  }



  void clear() {
    state = null;
  }

}



final navigationEventProvider =
    NotifierProvider<
      NavigationEventNotifier,
      NavigationEvent?
    >(
      NavigationEventNotifier.new,
    );