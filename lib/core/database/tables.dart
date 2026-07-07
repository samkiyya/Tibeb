import 'package:drift/drift.dart';
import '../../models/quest_model.dart';
import 'audio_track_converter.dart';

@DataClassName('BookEntity')
class Books extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get author => text()();
  TextColumn get coverPath => text()();
  TextColumn get filePath => text()();
  RealColumn get progress => real().withDefault(const Constant(0.0))();
  DateTimeColumn get addedAt => dateTime()();
  DateTimeColumn get lastReadAt => dateTime().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  TextColumn get series => text().nullable()();
  TextColumn get tags => text().nullable()();
  TextColumn get folderPath => text().nullable()();
  TextColumn get genre => text().withDefault(const Constant('Unknown'))();
  IntColumn get currentPage => integer().withDefault(const Constant(0))();
  IntColumn get totalPages => integer().withDefault(const Constant(0))();
  IntColumn get estimatedReadingMinutes =>
      integer().withDefault(const Constant(0))();
  TextColumn get lastPosition => text().nullable()();
  TextColumn get audioPath => text().nullable()();
  IntColumn get audioLastPosition => integer().nullable()();
  IntColumn get audioLastIndex => integer().nullable()();
  TextColumn get audioTracks => text()
      .withDefault(const Constant('[]'))
      .map(const AudioTrackListConverter())();
  TextColumn get contentHash => text().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
}

@DataClassName('ReadingSessionEntity')
class ReadingSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get bookId =>
      integer().references(Books, #id, onDelete: KeyAction.cascade)();
  TextColumn get date => text()(); // yyyy-MM-dd
  IntColumn get pagesRead => integer()();
  IntColumn get durationMinutes => integer()();
  DateTimeColumn get timestamp => dateTime()();
}

@DataClassName('BookmarkEntity')
class Bookmarks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get bookId =>
      integer().references(Books, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  RealColumn get progress => real()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get position => text()();
}

@DataClassName('QuestEntity')
class Quests extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  IntColumn get type => intEnum<QuestType>()();
  IntColumn get targetValue => integer()();
  IntColumn get currentValue => integer().withDefault(const Constant(0))();
  IntColumn get wpReward => integer()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  TextColumn get date => text()(); // yyyy-MM-dd

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('HighlightEntity')
class Highlights extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get bookId =>
      integer().references(Books, #id, onDelete: KeyAction.cascade)();
  IntColumn get chapterIndex => integer()();
  TextColumn get textValue => text().named('text')();
  TextColumn get note => text().nullable()();
  TextColumn get color => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get position => text()();
}

@DataClassName('DictionaryLookupEntity')
class DictionaryLookups extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get bookId =>
      integer().references(Books, #id, onDelete: KeyAction.cascade)();
  TextColumn get word => text()();
  DateTimeColumn get timestamp => dateTime()();
}
