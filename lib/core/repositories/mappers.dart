import 'package:drift/drift.dart';
import '../database/database.dart';
import '../../models/book_model.dart';
import '../../models/bookmark_model.dart';
import '../../models/highlight_model.dart';
import '../../models/quest_model.dart';
import '../../models/vocabulary_model.dart';

extension BookMapper on BookEntity {
  Book toDomain() {
    return Book(
      id: id,
      title: title,
      author: author,
      coverPath: coverPath,
      filePath: filePath,
      progress: progress,
      addedAt: addedAt,
      lastReadAt: lastReadAt,
      isFavorite: isFavorite,
      series: series,
      tags: tags,
      folderPath: folderPath,
      genre: genre,
      currentPage: currentPage,
      totalPages: totalPages,
      estimatedReadingMinutes: estimatedReadingMinutes,
      lastPosition: lastPosition,
      audioPath: audioPath,
      audioLastPosition: audioLastPosition,
      audioLastIndex: audioLastIndex,
      audioTracks: audioTracks,
      contentHash: contentHash,
      isDeleted: isDeleted,
    );
  }
}

extension BookDomainMapper on Book {
  BooksCompanion toCompanion() {
    return BooksCompanion(
      id: id != null ? Value(id!) : const Value.absent(),
      title: Value(title),
      author: Value(author),
      coverPath: Value(coverPath),
      filePath: Value(filePath),
      progress: Value(progress),
      addedAt: Value(addedAt),
      lastReadAt: Value(lastReadAt),
      isFavorite: Value(isFavorite),
      series: Value(series),
      tags: Value(tags),
      folderPath: Value(folderPath),
      genre: Value(genre ?? 'Unknown'),
      currentPage: Value(currentPage),
      totalPages: Value(totalPages),
      estimatedReadingMinutes: Value(estimatedReadingMinutes),
      lastPosition: Value(lastPosition),
      audioPath: Value(audioPath),
      audioLastPosition: Value(audioLastPosition),
      audioLastIndex: Value(audioLastIndex),
      audioTracks: Value(audioTracks),
      contentHash: Value(contentHash),
      isDeleted: Value(isDeleted),
    );
  }

  BookEntity toEntity() {
    return BookEntity(
      id: id ?? 0,
      title: title,
      author: author,
      coverPath: coverPath,
      filePath: filePath,
      progress: progress,
      addedAt: addedAt,
      lastReadAt: lastReadAt,
      isFavorite: isFavorite,
      series: series,
      tags: tags,
      folderPath: folderPath,
      genre: genre ?? 'Unknown',
      currentPage: currentPage,
      totalPages: totalPages,
      estimatedReadingMinutes: estimatedReadingMinutes,
      lastPosition: lastPosition,
      audioPath: audioPath,
      audioLastPosition: audioLastPosition,
      audioLastIndex: audioLastIndex,
      audioTracks: audioTracks,
      contentHash: contentHash,
      isDeleted: isDeleted,
    );
  }
}

extension BookmarkMapper on BookmarkEntity {
  Bookmark toDomain() {
    return Bookmark(
      id: id,
      bookId: bookId,
      title: title,
      progress: progress,
      createdAt: createdAt,
      position: position,
    );
  }
}

extension BookmarkDomainMapper on Bookmark {
  BookmarksCompanion toCompanion() {
    return BookmarksCompanion(
      id: id != null ? Value(id!) : const Value.absent(),
      bookId: Value(bookId),
      title: Value(title),
      progress: Value(progress),
      createdAt: Value(createdAt),
      position: Value(position),
    );
  }
}

extension HighlightMapper on HighlightEntity {
  Highlight toDomain() {
    return Highlight(
      id: id,
      bookId: bookId,
      chapterIndex: chapterIndex,
      text: textValue,
      note: note,
      color: color,
      createdAt: createdAt,
      position: position,
    );
  }
}

extension HighlightDomainMapper on Highlight {
  HighlightsCompanion toCompanion() {
    return HighlightsCompanion(
      id: id != null ? Value(id!) : const Value.absent(),
      bookId: Value(bookId),
      chapterIndex: Value(chapterIndex),
      textValue: Value(text),
      note: Value(note),
      color: Value(color),
      createdAt: Value(createdAt),
      position: Value(position),
    );
  }

  HighlightEntity toEntity() {
    return HighlightEntity(
      id: id ?? 0,
      bookId: bookId,
      chapterIndex: chapterIndex,
      textValue: text,
      note: note,
      color: color,
      createdAt: createdAt,
      position: position,
    );
  }
}

extension QuestMapper on QuestEntity {
  DailyQuest toDomain() {
    return DailyQuest(
      id: id,
      title: title,
      description: description,
      type: type,
      targetValue: targetValue,
      currentValue: currentValue,
      xpReward: xpReward,
      isCompleted: isCompleted,
      date: DateTime.parse(date),
    );
  }
}

extension QuestDomainMapper on DailyQuest {
  QuestsCompanion toCompanion() {
    return QuestsCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      type: Value(type),
      targetValue: Value(targetValue),
      currentValue: Value(currentValue),
      xpReward: Value(xpReward),
      isCompleted: Value(isCompleted),
      date: Value(date.toIso8601String().split('T')[0]),
    );
  }
}

extension DictionaryLookupMapper on DictionaryLookupEntity {
  VocabularyLookup toDomain() {
    return VocabularyLookup(
      id: id,
      bookId: bookId,
      word: word,
      timestamp: timestamp,
    );
  }
}

extension DictionaryLookupDomainMapper on VocabularyLookup {
  DictionaryLookupsCompanion toCompanion() {
    return DictionaryLookupsCompanion(
      id: id != null ? Value(id!) : const Value.absent(),
      bookId: Value(bookId),
      word: Value(word),
      timestamp: Value(timestamp),
    );
  }
}
