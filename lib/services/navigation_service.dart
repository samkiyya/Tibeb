import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import 'package:tibeb/models/book_model.dart';
import 'package:tibeb/screens/reading_screen.dart';
import 'package:tibeb/screens/audiobook_player_screen.dart';
import 'package:tibeb/providers/library_provider.dart';
import 'package:tibeb/providers/navigation_provider.dart';



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

class BookRouter {
  static void openBook(BuildContext context, WidgetRef ref, Book book) {
    ref.read(currentlyReadingProvider.notifier).state = book;
    ref.read(libraryProvider.notifier).markBookAsOpened(book);
    
    if (book.isAudioOnly) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AudioOnlyPlayerScreen(book: book),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ReadingScreen(),
        ),
      );
    }
  }
}