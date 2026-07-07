import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import '../providers/library_provider.dart';
import '../providers/navigation_provider.dart';



/// Handles external file share intents.
///
/// Responsibilities:
/// - Listen for shared files
/// - Import books
/// - Update application state
///
/// It does NOT handle UI navigation.
class NavigationService {

  StreamSubscription? _intentDataStreamSubscription;



  void initialize({
    required WidgetRef ref,
  }) {

    _intentDataStreamSubscription =
        ReceiveSharingIntent.instance
            .getMediaStream()
            .listen(
      (files) {

        _handleSharedFiles(
          files: files,
          ref: ref,
        );

      },
      onError: (error) {

        debugPrint(
          'Share intent error: $error',
        );

      },
    );



    ReceiveSharingIntent.instance
        .getInitialMedia()
        .then(
      (files) {

        _handleSharedFiles(
          files: files,
          ref: ref,
        );

      },
      onError: (error) {

        debugPrint(
          'Initial share intent error: $error',
        );

      },
    );
  }





  Future<void> _handleSharedFiles({
    required List<SharedMediaFile> files,
    required WidgetRef ref,
  }) async {


    if (files.isEmpty) {
      return;
    }



    final paths =
        files
            .map(
              (file) => file.path,
            )
            .toList();



    final books =
        await ref
            .read(
              libraryProvider.notifier,
            )
            .importFiles(
              paths,
            );



    if (books.isEmpty) {
      return;
    }



    final book = books.first;



    ref
        .read(
          currentlyReadingProvider.notifier,
        )
        .state = book;



    ref
        .read(
          libraryProvider.notifier,
        )
        .markBookAsOpened(
          book,
        );



    // Notify UI layer
    ref
        .read(
          navigationEventProvider.notifier,
        )
        .send(
      const NavigationEvent(
        type: NavigationEventType.openReader,
      ),
    );
  }





  void dispose() {

    _intentDataStreamSubscription?.cancel();

  }
}