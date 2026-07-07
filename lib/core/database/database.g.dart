// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $BooksTable extends Books with TableInfo<$BooksTable, BookEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BooksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
    'author',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _coverPathMeta = const VerificationMeta(
    'coverPath',
  );
  @override
  late final GeneratedColumn<String> coverPath = GeneratedColumn<String>(
    'cover_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _progressMeta = const VerificationMeta(
    'progress',
  );
  @override
  late final GeneratedColumn<double> progress = GeneratedColumn<double>(
    'progress',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastReadAtMeta = const VerificationMeta(
    'lastReadAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastReadAt = GeneratedColumn<DateTime>(
    'last_read_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _seriesMeta = const VerificationMeta('series');
  @override
  late final GeneratedColumn<String> series = GeneratedColumn<String>(
    'series',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _folderPathMeta = const VerificationMeta(
    'folderPath',
  );
  @override
  late final GeneratedColumn<String> folderPath = GeneratedColumn<String>(
    'folder_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genreMeta = const VerificationMeta('genre');
  @override
  late final GeneratedColumn<String> genre = GeneratedColumn<String>(
    'genre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Unknown'),
  );
  static const VerificationMeta _currentPageMeta = const VerificationMeta(
    'currentPage',
  );
  @override
  late final GeneratedColumn<int> currentPage = GeneratedColumn<int>(
    'current_page',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalPagesMeta = const VerificationMeta(
    'totalPages',
  );
  @override
  late final GeneratedColumn<int> totalPages = GeneratedColumn<int>(
    'total_pages',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _estimatedReadingMinutesMeta =
      const VerificationMeta('estimatedReadingMinutes');
  @override
  late final GeneratedColumn<int> estimatedReadingMinutes =
      GeneratedColumn<int>(
        'estimated_reading_minutes',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _lastPositionMeta = const VerificationMeta(
    'lastPosition',
  );
  @override
  late final GeneratedColumn<String> lastPosition = GeneratedColumn<String>(
    'last_position',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioPathMeta = const VerificationMeta(
    'audioPath',
  );
  @override
  late final GeneratedColumn<String> audioPath = GeneratedColumn<String>(
    'audio_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioLastPositionMeta = const VerificationMeta(
    'audioLastPosition',
  );
  @override
  late final GeneratedColumn<int> audioLastPosition = GeneratedColumn<int>(
    'audio_last_position',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioLastIndexMeta = const VerificationMeta(
    'audioLastIndex',
  );
  @override
  late final GeneratedColumn<int> audioLastIndex = GeneratedColumn<int>(
    'audio_last_index',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<AudioTrack>, String>
  audioTracks = GeneratedColumn<String>(
    'audio_tracks',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  ).withConverter<List<AudioTrack>>($BooksTable.$converteraudioTracks);
  static const VerificationMeta _contentHashMeta = const VerificationMeta(
    'contentHash',
  );
  @override
  late final GeneratedColumn<String> contentHash = GeneratedColumn<String>(
    'content_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    author,
    coverPath,
    filePath,
    progress,
    addedAt,
    lastReadAt,
    isFavorite,
    series,
    tags,
    folderPath,
    genre,
    currentPage,
    totalPages,
    estimatedReadingMinutes,
    lastPosition,
    audioPath,
    audioLastPosition,
    audioLastIndex,
    audioTracks,
    contentHash,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'books';
  @override
  VerificationContext validateIntegrity(
    Insertable<BookEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('author')) {
      context.handle(
        _authorMeta,
        author.isAcceptableOrUnknown(data['author']!, _authorMeta),
      );
    } else if (isInserting) {
      context.missing(_authorMeta);
    }
    if (data.containsKey('cover_path')) {
      context.handle(
        _coverPathMeta,
        coverPath.isAcceptableOrUnknown(data['cover_path']!, _coverPathMeta),
      );
    } else if (isInserting) {
      context.missing(_coverPathMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('progress')) {
      context.handle(
        _progressMeta,
        progress.isAcceptableOrUnknown(data['progress']!, _progressMeta),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    if (data.containsKey('last_read_at')) {
      context.handle(
        _lastReadAtMeta,
        lastReadAt.isAcceptableOrUnknown(
          data['last_read_at']!,
          _lastReadAtMeta,
        ),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('series')) {
      context.handle(
        _seriesMeta,
        series.isAcceptableOrUnknown(data['series']!, _seriesMeta),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('folder_path')) {
      context.handle(
        _folderPathMeta,
        folderPath.isAcceptableOrUnknown(data['folder_path']!, _folderPathMeta),
      );
    }
    if (data.containsKey('genre')) {
      context.handle(
        _genreMeta,
        genre.isAcceptableOrUnknown(data['genre']!, _genreMeta),
      );
    }
    if (data.containsKey('current_page')) {
      context.handle(
        _currentPageMeta,
        currentPage.isAcceptableOrUnknown(
          data['current_page']!,
          _currentPageMeta,
        ),
      );
    }
    if (data.containsKey('total_pages')) {
      context.handle(
        _totalPagesMeta,
        totalPages.isAcceptableOrUnknown(data['total_pages']!, _totalPagesMeta),
      );
    }
    if (data.containsKey('estimated_reading_minutes')) {
      context.handle(
        _estimatedReadingMinutesMeta,
        estimatedReadingMinutes.isAcceptableOrUnknown(
          data['estimated_reading_minutes']!,
          _estimatedReadingMinutesMeta,
        ),
      );
    }
    if (data.containsKey('last_position')) {
      context.handle(
        _lastPositionMeta,
        lastPosition.isAcceptableOrUnknown(
          data['last_position']!,
          _lastPositionMeta,
        ),
      );
    }
    if (data.containsKey('audio_path')) {
      context.handle(
        _audioPathMeta,
        audioPath.isAcceptableOrUnknown(data['audio_path']!, _audioPathMeta),
      );
    }
    if (data.containsKey('audio_last_position')) {
      context.handle(
        _audioLastPositionMeta,
        audioLastPosition.isAcceptableOrUnknown(
          data['audio_last_position']!,
          _audioLastPositionMeta,
        ),
      );
    }
    if (data.containsKey('audio_last_index')) {
      context.handle(
        _audioLastIndexMeta,
        audioLastIndex.isAcceptableOrUnknown(
          data['audio_last_index']!,
          _audioLastIndexMeta,
        ),
      );
    }
    if (data.containsKey('content_hash')) {
      context.handle(
        _contentHashMeta,
        contentHash.isAcceptableOrUnknown(
          data['content_hash']!,
          _contentHashMeta,
        ),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BookEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BookEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      author: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author'],
      )!,
      coverPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_path'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      progress: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}progress'],
      )!,
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
      lastReadAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_read_at'],
      ),
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      series: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}series'],
      ),
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      ),
      folderPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}folder_path'],
      ),
      genre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}genre'],
      )!,
      currentPage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_page'],
      )!,
      totalPages: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_pages'],
      )!,
      estimatedReadingMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_reading_minutes'],
      )!,
      lastPosition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_position'],
      ),
      audioPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_path'],
      ),
      audioLastPosition: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}audio_last_position'],
      ),
      audioLastIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}audio_last_index'],
      ),
      audioTracks: $BooksTable.$converteraudioTracks.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}audio_tracks'],
        )!,
      ),
      contentHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_hash'],
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $BooksTable createAlias(String alias) {
    return $BooksTable(attachedDatabase, alias);
  }

  static TypeConverter<List<AudioTrack>, String> $converteraudioTracks =
      const AudioTrackListConverter();
}

class BookEntity extends DataClass implements Insertable<BookEntity> {
  final int id;
  final String title;
  final String author;
  final String coverPath;
  final String filePath;
  final double progress;
  final DateTime addedAt;
  final DateTime? lastReadAt;
  final bool isFavorite;
  final String? series;
  final String? tags;
  final String? folderPath;
  final String genre;
  final int currentPage;
  final int totalPages;
  final int estimatedReadingMinutes;
  final String? lastPosition;
  final String? audioPath;
  final int? audioLastPosition;
  final int? audioLastIndex;
  final List<AudioTrack> audioTracks;
  final String? contentHash;
  final bool isDeleted;
  const BookEntity({
    required this.id,
    required this.title,
    required this.author,
    required this.coverPath,
    required this.filePath,
    required this.progress,
    required this.addedAt,
    this.lastReadAt,
    required this.isFavorite,
    this.series,
    this.tags,
    this.folderPath,
    required this.genre,
    required this.currentPage,
    required this.totalPages,
    required this.estimatedReadingMinutes,
    this.lastPosition,
    this.audioPath,
    this.audioLastPosition,
    this.audioLastIndex,
    required this.audioTracks,
    this.contentHash,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['author'] = Variable<String>(author);
    map['cover_path'] = Variable<String>(coverPath);
    map['file_path'] = Variable<String>(filePath);
    map['progress'] = Variable<double>(progress);
    map['added_at'] = Variable<DateTime>(addedAt);
    if (!nullToAbsent || lastReadAt != null) {
      map['last_read_at'] = Variable<DateTime>(lastReadAt);
    }
    map['is_favorite'] = Variable<bool>(isFavorite);
    if (!nullToAbsent || series != null) {
      map['series'] = Variable<String>(series);
    }
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    if (!nullToAbsent || folderPath != null) {
      map['folder_path'] = Variable<String>(folderPath);
    }
    map['genre'] = Variable<String>(genre);
    map['current_page'] = Variable<int>(currentPage);
    map['total_pages'] = Variable<int>(totalPages);
    map['estimated_reading_minutes'] = Variable<int>(estimatedReadingMinutes);
    if (!nullToAbsent || lastPosition != null) {
      map['last_position'] = Variable<String>(lastPosition);
    }
    if (!nullToAbsent || audioPath != null) {
      map['audio_path'] = Variable<String>(audioPath);
    }
    if (!nullToAbsent || audioLastPosition != null) {
      map['audio_last_position'] = Variable<int>(audioLastPosition);
    }
    if (!nullToAbsent || audioLastIndex != null) {
      map['audio_last_index'] = Variable<int>(audioLastIndex);
    }
    {
      map['audio_tracks'] = Variable<String>(
        $BooksTable.$converteraudioTracks.toSql(audioTracks),
      );
    }
    if (!nullToAbsent || contentHash != null) {
      map['content_hash'] = Variable<String>(contentHash);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  BooksCompanion toCompanion(bool nullToAbsent) {
    return BooksCompanion(
      id: Value(id),
      title: Value(title),
      author: Value(author),
      coverPath: Value(coverPath),
      filePath: Value(filePath),
      progress: Value(progress),
      addedAt: Value(addedAt),
      lastReadAt: lastReadAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReadAt),
      isFavorite: Value(isFavorite),
      series: series == null && nullToAbsent
          ? const Value.absent()
          : Value(series),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      folderPath: folderPath == null && nullToAbsent
          ? const Value.absent()
          : Value(folderPath),
      genre: Value(genre),
      currentPage: Value(currentPage),
      totalPages: Value(totalPages),
      estimatedReadingMinutes: Value(estimatedReadingMinutes),
      lastPosition: lastPosition == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPosition),
      audioPath: audioPath == null && nullToAbsent
          ? const Value.absent()
          : Value(audioPath),
      audioLastPosition: audioLastPosition == null && nullToAbsent
          ? const Value.absent()
          : Value(audioLastPosition),
      audioLastIndex: audioLastIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(audioLastIndex),
      audioTracks: Value(audioTracks),
      contentHash: contentHash == null && nullToAbsent
          ? const Value.absent()
          : Value(contentHash),
      isDeleted: Value(isDeleted),
    );
  }

  factory BookEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BookEntity(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      author: serializer.fromJson<String>(json['author']),
      coverPath: serializer.fromJson<String>(json['coverPath']),
      filePath: serializer.fromJson<String>(json['filePath']),
      progress: serializer.fromJson<double>(json['progress']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
      lastReadAt: serializer.fromJson<DateTime?>(json['lastReadAt']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      series: serializer.fromJson<String?>(json['series']),
      tags: serializer.fromJson<String?>(json['tags']),
      folderPath: serializer.fromJson<String?>(json['folderPath']),
      genre: serializer.fromJson<String>(json['genre']),
      currentPage: serializer.fromJson<int>(json['currentPage']),
      totalPages: serializer.fromJson<int>(json['totalPages']),
      estimatedReadingMinutes: serializer.fromJson<int>(
        json['estimatedReadingMinutes'],
      ),
      lastPosition: serializer.fromJson<String?>(json['lastPosition']),
      audioPath: serializer.fromJson<String?>(json['audioPath']),
      audioLastPosition: serializer.fromJson<int?>(json['audioLastPosition']),
      audioLastIndex: serializer.fromJson<int?>(json['audioLastIndex']),
      audioTracks: serializer.fromJson<List<AudioTrack>>(json['audioTracks']),
      contentHash: serializer.fromJson<String?>(json['contentHash']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'author': serializer.toJson<String>(author),
      'coverPath': serializer.toJson<String>(coverPath),
      'filePath': serializer.toJson<String>(filePath),
      'progress': serializer.toJson<double>(progress),
      'addedAt': serializer.toJson<DateTime>(addedAt),
      'lastReadAt': serializer.toJson<DateTime?>(lastReadAt),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'series': serializer.toJson<String?>(series),
      'tags': serializer.toJson<String?>(tags),
      'folderPath': serializer.toJson<String?>(folderPath),
      'genre': serializer.toJson<String>(genre),
      'currentPage': serializer.toJson<int>(currentPage),
      'totalPages': serializer.toJson<int>(totalPages),
      'estimatedReadingMinutes': serializer.toJson<int>(
        estimatedReadingMinutes,
      ),
      'lastPosition': serializer.toJson<String?>(lastPosition),
      'audioPath': serializer.toJson<String?>(audioPath),
      'audioLastPosition': serializer.toJson<int?>(audioLastPosition),
      'audioLastIndex': serializer.toJson<int?>(audioLastIndex),
      'audioTracks': serializer.toJson<List<AudioTrack>>(audioTracks),
      'contentHash': serializer.toJson<String?>(contentHash),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  BookEntity copyWith({
    int? id,
    String? title,
    String? author,
    String? coverPath,
    String? filePath,
    double? progress,
    DateTime? addedAt,
    Value<DateTime?> lastReadAt = const Value.absent(),
    bool? isFavorite,
    Value<String?> series = const Value.absent(),
    Value<String?> tags = const Value.absent(),
    Value<String?> folderPath = const Value.absent(),
    String? genre,
    int? currentPage,
    int? totalPages,
    int? estimatedReadingMinutes,
    Value<String?> lastPosition = const Value.absent(),
    Value<String?> audioPath = const Value.absent(),
    Value<int?> audioLastPosition = const Value.absent(),
    Value<int?> audioLastIndex = const Value.absent(),
    List<AudioTrack>? audioTracks,
    Value<String?> contentHash = const Value.absent(),
    bool? isDeleted,
  }) => BookEntity(
    id: id ?? this.id,
    title: title ?? this.title,
    author: author ?? this.author,
    coverPath: coverPath ?? this.coverPath,
    filePath: filePath ?? this.filePath,
    progress: progress ?? this.progress,
    addedAt: addedAt ?? this.addedAt,
    lastReadAt: lastReadAt.present ? lastReadAt.value : this.lastReadAt,
    isFavorite: isFavorite ?? this.isFavorite,
    series: series.present ? series.value : this.series,
    tags: tags.present ? tags.value : this.tags,
    folderPath: folderPath.present ? folderPath.value : this.folderPath,
    genre: genre ?? this.genre,
    currentPage: currentPage ?? this.currentPage,
    totalPages: totalPages ?? this.totalPages,
    estimatedReadingMinutes:
        estimatedReadingMinutes ?? this.estimatedReadingMinutes,
    lastPosition: lastPosition.present ? lastPosition.value : this.lastPosition,
    audioPath: audioPath.present ? audioPath.value : this.audioPath,
    audioLastPosition: audioLastPosition.present
        ? audioLastPosition.value
        : this.audioLastPosition,
    audioLastIndex: audioLastIndex.present
        ? audioLastIndex.value
        : this.audioLastIndex,
    audioTracks: audioTracks ?? this.audioTracks,
    contentHash: contentHash.present ? contentHash.value : this.contentHash,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  BookEntity copyWithCompanion(BooksCompanion data) {
    return BookEntity(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      author: data.author.present ? data.author.value : this.author,
      coverPath: data.coverPath.present ? data.coverPath.value : this.coverPath,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      progress: data.progress.present ? data.progress.value : this.progress,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
      lastReadAt: data.lastReadAt.present
          ? data.lastReadAt.value
          : this.lastReadAt,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      series: data.series.present ? data.series.value : this.series,
      tags: data.tags.present ? data.tags.value : this.tags,
      folderPath: data.folderPath.present
          ? data.folderPath.value
          : this.folderPath,
      genre: data.genre.present ? data.genre.value : this.genre,
      currentPage: data.currentPage.present
          ? data.currentPage.value
          : this.currentPage,
      totalPages: data.totalPages.present
          ? data.totalPages.value
          : this.totalPages,
      estimatedReadingMinutes: data.estimatedReadingMinutes.present
          ? data.estimatedReadingMinutes.value
          : this.estimatedReadingMinutes,
      lastPosition: data.lastPosition.present
          ? data.lastPosition.value
          : this.lastPosition,
      audioPath: data.audioPath.present ? data.audioPath.value : this.audioPath,
      audioLastPosition: data.audioLastPosition.present
          ? data.audioLastPosition.value
          : this.audioLastPosition,
      audioLastIndex: data.audioLastIndex.present
          ? data.audioLastIndex.value
          : this.audioLastIndex,
      audioTracks: data.audioTracks.present
          ? data.audioTracks.value
          : this.audioTracks,
      contentHash: data.contentHash.present
          ? data.contentHash.value
          : this.contentHash,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BookEntity(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('coverPath: $coverPath, ')
          ..write('filePath: $filePath, ')
          ..write('progress: $progress, ')
          ..write('addedAt: $addedAt, ')
          ..write('lastReadAt: $lastReadAt, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('series: $series, ')
          ..write('tags: $tags, ')
          ..write('folderPath: $folderPath, ')
          ..write('genre: $genre, ')
          ..write('currentPage: $currentPage, ')
          ..write('totalPages: $totalPages, ')
          ..write('estimatedReadingMinutes: $estimatedReadingMinutes, ')
          ..write('lastPosition: $lastPosition, ')
          ..write('audioPath: $audioPath, ')
          ..write('audioLastPosition: $audioLastPosition, ')
          ..write('audioLastIndex: $audioLastIndex, ')
          ..write('audioTracks: $audioTracks, ')
          ..write('contentHash: $contentHash, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    title,
    author,
    coverPath,
    filePath,
    progress,
    addedAt,
    lastReadAt,
    isFavorite,
    series,
    tags,
    folderPath,
    genre,
    currentPage,
    totalPages,
    estimatedReadingMinutes,
    lastPosition,
    audioPath,
    audioLastPosition,
    audioLastIndex,
    audioTracks,
    contentHash,
    isDeleted,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookEntity &&
          other.id == this.id &&
          other.title == this.title &&
          other.author == this.author &&
          other.coverPath == this.coverPath &&
          other.filePath == this.filePath &&
          other.progress == this.progress &&
          other.addedAt == this.addedAt &&
          other.lastReadAt == this.lastReadAt &&
          other.isFavorite == this.isFavorite &&
          other.series == this.series &&
          other.tags == this.tags &&
          other.folderPath == this.folderPath &&
          other.genre == this.genre &&
          other.currentPage == this.currentPage &&
          other.totalPages == this.totalPages &&
          other.estimatedReadingMinutes == this.estimatedReadingMinutes &&
          other.lastPosition == this.lastPosition &&
          other.audioPath == this.audioPath &&
          other.audioLastPosition == this.audioLastPosition &&
          other.audioLastIndex == this.audioLastIndex &&
          other.audioTracks == this.audioTracks &&
          other.contentHash == this.contentHash &&
          other.isDeleted == this.isDeleted);
}

class BooksCompanion extends UpdateCompanion<BookEntity> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> author;
  final Value<String> coverPath;
  final Value<String> filePath;
  final Value<double> progress;
  final Value<DateTime> addedAt;
  final Value<DateTime?> lastReadAt;
  final Value<bool> isFavorite;
  final Value<String?> series;
  final Value<String?> tags;
  final Value<String?> folderPath;
  final Value<String> genre;
  final Value<int> currentPage;
  final Value<int> totalPages;
  final Value<int> estimatedReadingMinutes;
  final Value<String?> lastPosition;
  final Value<String?> audioPath;
  final Value<int?> audioLastPosition;
  final Value<int?> audioLastIndex;
  final Value<List<AudioTrack>> audioTracks;
  final Value<String?> contentHash;
  final Value<bool> isDeleted;
  const BooksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.author = const Value.absent(),
    this.coverPath = const Value.absent(),
    this.filePath = const Value.absent(),
    this.progress = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.lastReadAt = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.series = const Value.absent(),
    this.tags = const Value.absent(),
    this.folderPath = const Value.absent(),
    this.genre = const Value.absent(),
    this.currentPage = const Value.absent(),
    this.totalPages = const Value.absent(),
    this.estimatedReadingMinutes = const Value.absent(),
    this.lastPosition = const Value.absent(),
    this.audioPath = const Value.absent(),
    this.audioLastPosition = const Value.absent(),
    this.audioLastIndex = const Value.absent(),
    this.audioTracks = const Value.absent(),
    this.contentHash = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  BooksCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String author,
    required String coverPath,
    required String filePath,
    this.progress = const Value.absent(),
    required DateTime addedAt,
    this.lastReadAt = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.series = const Value.absent(),
    this.tags = const Value.absent(),
    this.folderPath = const Value.absent(),
    this.genre = const Value.absent(),
    this.currentPage = const Value.absent(),
    this.totalPages = const Value.absent(),
    this.estimatedReadingMinutes = const Value.absent(),
    this.lastPosition = const Value.absent(),
    this.audioPath = const Value.absent(),
    this.audioLastPosition = const Value.absent(),
    this.audioLastIndex = const Value.absent(),
    this.audioTracks = const Value.absent(),
    this.contentHash = const Value.absent(),
    this.isDeleted = const Value.absent(),
  }) : title = Value(title),
       author = Value(author),
       coverPath = Value(coverPath),
       filePath = Value(filePath),
       addedAt = Value(addedAt);
  static Insertable<BookEntity> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? author,
    Expression<String>? coverPath,
    Expression<String>? filePath,
    Expression<double>? progress,
    Expression<DateTime>? addedAt,
    Expression<DateTime>? lastReadAt,
    Expression<bool>? isFavorite,
    Expression<String>? series,
    Expression<String>? tags,
    Expression<String>? folderPath,
    Expression<String>? genre,
    Expression<int>? currentPage,
    Expression<int>? totalPages,
    Expression<int>? estimatedReadingMinutes,
    Expression<String>? lastPosition,
    Expression<String>? audioPath,
    Expression<int>? audioLastPosition,
    Expression<int>? audioLastIndex,
    Expression<String>? audioTracks,
    Expression<String>? contentHash,
    Expression<bool>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (author != null) 'author': author,
      if (coverPath != null) 'cover_path': coverPath,
      if (filePath != null) 'file_path': filePath,
      if (progress != null) 'progress': progress,
      if (addedAt != null) 'added_at': addedAt,
      if (lastReadAt != null) 'last_read_at': lastReadAt,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (series != null) 'series': series,
      if (tags != null) 'tags': tags,
      if (folderPath != null) 'folder_path': folderPath,
      if (genre != null) 'genre': genre,
      if (currentPage != null) 'current_page': currentPage,
      if (totalPages != null) 'total_pages': totalPages,
      if (estimatedReadingMinutes != null)
        'estimated_reading_minutes': estimatedReadingMinutes,
      if (lastPosition != null) 'last_position': lastPosition,
      if (audioPath != null) 'audio_path': audioPath,
      if (audioLastPosition != null) 'audio_last_position': audioLastPosition,
      if (audioLastIndex != null) 'audio_last_index': audioLastIndex,
      if (audioTracks != null) 'audio_tracks': audioTracks,
      if (contentHash != null) 'content_hash': contentHash,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  BooksCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? author,
    Value<String>? coverPath,
    Value<String>? filePath,
    Value<double>? progress,
    Value<DateTime>? addedAt,
    Value<DateTime?>? lastReadAt,
    Value<bool>? isFavorite,
    Value<String?>? series,
    Value<String?>? tags,
    Value<String?>? folderPath,
    Value<String>? genre,
    Value<int>? currentPage,
    Value<int>? totalPages,
    Value<int>? estimatedReadingMinutes,
    Value<String?>? lastPosition,
    Value<String?>? audioPath,
    Value<int?>? audioLastPosition,
    Value<int?>? audioLastIndex,
    Value<List<AudioTrack>>? audioTracks,
    Value<String?>? contentHash,
    Value<bool>? isDeleted,
  }) {
    return BooksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      coverPath: coverPath ?? this.coverPath,
      filePath: filePath ?? this.filePath,
      progress: progress ?? this.progress,
      addedAt: addedAt ?? this.addedAt,
      lastReadAt: lastReadAt ?? this.lastReadAt,
      isFavorite: isFavorite ?? this.isFavorite,
      series: series ?? this.series,
      tags: tags ?? this.tags,
      folderPath: folderPath ?? this.folderPath,
      genre: genre ?? this.genre,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      estimatedReadingMinutes:
          estimatedReadingMinutes ?? this.estimatedReadingMinutes,
      lastPosition: lastPosition ?? this.lastPosition,
      audioPath: audioPath ?? this.audioPath,
      audioLastPosition: audioLastPosition ?? this.audioLastPosition,
      audioLastIndex: audioLastIndex ?? this.audioLastIndex,
      audioTracks: audioTracks ?? this.audioTracks,
      contentHash: contentHash ?? this.contentHash,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (coverPath.present) {
      map['cover_path'] = Variable<String>(coverPath.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (progress.present) {
      map['progress'] = Variable<double>(progress.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (lastReadAt.present) {
      map['last_read_at'] = Variable<DateTime>(lastReadAt.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (series.present) {
      map['series'] = Variable<String>(series.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (folderPath.present) {
      map['folder_path'] = Variable<String>(folderPath.value);
    }
    if (genre.present) {
      map['genre'] = Variable<String>(genre.value);
    }
    if (currentPage.present) {
      map['current_page'] = Variable<int>(currentPage.value);
    }
    if (totalPages.present) {
      map['total_pages'] = Variable<int>(totalPages.value);
    }
    if (estimatedReadingMinutes.present) {
      map['estimated_reading_minutes'] = Variable<int>(
        estimatedReadingMinutes.value,
      );
    }
    if (lastPosition.present) {
      map['last_position'] = Variable<String>(lastPosition.value);
    }
    if (audioPath.present) {
      map['audio_path'] = Variable<String>(audioPath.value);
    }
    if (audioLastPosition.present) {
      map['audio_last_position'] = Variable<int>(audioLastPosition.value);
    }
    if (audioLastIndex.present) {
      map['audio_last_index'] = Variable<int>(audioLastIndex.value);
    }
    if (audioTracks.present) {
      map['audio_tracks'] = Variable<String>(
        $BooksTable.$converteraudioTracks.toSql(audioTracks.value),
      );
    }
    if (contentHash.present) {
      map['content_hash'] = Variable<String>(contentHash.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BooksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('coverPath: $coverPath, ')
          ..write('filePath: $filePath, ')
          ..write('progress: $progress, ')
          ..write('addedAt: $addedAt, ')
          ..write('lastReadAt: $lastReadAt, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('series: $series, ')
          ..write('tags: $tags, ')
          ..write('folderPath: $folderPath, ')
          ..write('genre: $genre, ')
          ..write('currentPage: $currentPage, ')
          ..write('totalPages: $totalPages, ')
          ..write('estimatedReadingMinutes: $estimatedReadingMinutes, ')
          ..write('lastPosition: $lastPosition, ')
          ..write('audioPath: $audioPath, ')
          ..write('audioLastPosition: $audioLastPosition, ')
          ..write('audioLastIndex: $audioLastIndex, ')
          ..write('audioTracks: $audioTracks, ')
          ..write('contentHash: $contentHash, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $ReadingSessionsTable extends ReadingSessions
    with TableInfo<$ReadingSessionsTable, ReadingSessionEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadingSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<int> bookId = GeneratedColumn<int>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES books (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pagesReadMeta = const VerificationMeta(
    'pagesRead',
  );
  @override
  late final GeneratedColumn<int> pagesRead = GeneratedColumn<int>(
    'pages_read',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bookId,
    date,
    pagesRead,
    durationMinutes,
    timestamp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reading_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReadingSessionEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('pages_read')) {
      context.handle(
        _pagesReadMeta,
        pagesRead.isAcceptableOrUnknown(data['pages_read']!, _pagesReadMeta),
      );
    } else if (isInserting) {
      context.missing(_pagesReadMeta);
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMinutesMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReadingSessionEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReadingSessionEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}book_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      pagesRead: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pages_read'],
      )!,
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $ReadingSessionsTable createAlias(String alias) {
    return $ReadingSessionsTable(attachedDatabase, alias);
  }
}

class ReadingSessionEntity extends DataClass
    implements Insertable<ReadingSessionEntity> {
  final int id;
  final int bookId;
  final String date;
  final int pagesRead;
  final int durationMinutes;
  final DateTime timestamp;
  const ReadingSessionEntity({
    required this.id,
    required this.bookId,
    required this.date,
    required this.pagesRead,
    required this.durationMinutes,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['book_id'] = Variable<int>(bookId);
    map['date'] = Variable<String>(date);
    map['pages_read'] = Variable<int>(pagesRead);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  ReadingSessionsCompanion toCompanion(bool nullToAbsent) {
    return ReadingSessionsCompanion(
      id: Value(id),
      bookId: Value(bookId),
      date: Value(date),
      pagesRead: Value(pagesRead),
      durationMinutes: Value(durationMinutes),
      timestamp: Value(timestamp),
    );
  }

  factory ReadingSessionEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReadingSessionEntity(
      id: serializer.fromJson<int>(json['id']),
      bookId: serializer.fromJson<int>(json['bookId']),
      date: serializer.fromJson<String>(json['date']),
      pagesRead: serializer.fromJson<int>(json['pagesRead']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bookId': serializer.toJson<int>(bookId),
      'date': serializer.toJson<String>(date),
      'pagesRead': serializer.toJson<int>(pagesRead),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  ReadingSessionEntity copyWith({
    int? id,
    int? bookId,
    String? date,
    int? pagesRead,
    int? durationMinutes,
    DateTime? timestamp,
  }) => ReadingSessionEntity(
    id: id ?? this.id,
    bookId: bookId ?? this.bookId,
    date: date ?? this.date,
    pagesRead: pagesRead ?? this.pagesRead,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    timestamp: timestamp ?? this.timestamp,
  );
  ReadingSessionEntity copyWithCompanion(ReadingSessionsCompanion data) {
    return ReadingSessionEntity(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      date: data.date.present ? data.date.value : this.date,
      pagesRead: data.pagesRead.present ? data.pagesRead.value : this.pagesRead,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReadingSessionEntity(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('date: $date, ')
          ..write('pagesRead: $pagesRead, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, bookId, date, pagesRead, durationMinutes, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadingSessionEntity &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.date == this.date &&
          other.pagesRead == this.pagesRead &&
          other.durationMinutes == this.durationMinutes &&
          other.timestamp == this.timestamp);
}

class ReadingSessionsCompanion extends UpdateCompanion<ReadingSessionEntity> {
  final Value<int> id;
  final Value<int> bookId;
  final Value<String> date;
  final Value<int> pagesRead;
  final Value<int> durationMinutes;
  final Value<DateTime> timestamp;
  const ReadingSessionsCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.date = const Value.absent(),
    this.pagesRead = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  ReadingSessionsCompanion.insert({
    this.id = const Value.absent(),
    required int bookId,
    required String date,
    required int pagesRead,
    required int durationMinutes,
    required DateTime timestamp,
  }) : bookId = Value(bookId),
       date = Value(date),
       pagesRead = Value(pagesRead),
       durationMinutes = Value(durationMinutes),
       timestamp = Value(timestamp);
  static Insertable<ReadingSessionEntity> custom({
    Expression<int>? id,
    Expression<int>? bookId,
    Expression<String>? date,
    Expression<int>? pagesRead,
    Expression<int>? durationMinutes,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (date != null) 'date': date,
      if (pagesRead != null) 'pages_read': pagesRead,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  ReadingSessionsCompanion copyWith({
    Value<int>? id,
    Value<int>? bookId,
    Value<String>? date,
    Value<int>? pagesRead,
    Value<int>? durationMinutes,
    Value<DateTime>? timestamp,
  }) {
    return ReadingSessionsCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      date: date ?? this.date,
      pagesRead: pagesRead ?? this.pagesRead,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<int>(bookId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (pagesRead.present) {
      map['pages_read'] = Variable<int>(pagesRead.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadingSessionsCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('date: $date, ')
          ..write('pagesRead: $pagesRead, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

class $BookmarksTable extends Bookmarks
    with TableInfo<$BookmarksTable, BookmarkEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookmarksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<int> bookId = GeneratedColumn<int>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES books (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _progressMeta = const VerificationMeta(
    'progress',
  );
  @override
  late final GeneratedColumn<double> progress = GeneratedColumn<double>(
    'progress',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<String> position = GeneratedColumn<String>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bookId,
    title,
    progress,
    createdAt,
    position,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bookmarks';
  @override
  VerificationContext validateIntegrity(
    Insertable<BookmarkEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('progress')) {
      context.handle(
        _progressMeta,
        progress.isAcceptableOrUnknown(data['progress']!, _progressMeta),
      );
    } else if (isInserting) {
      context.missing(_progressMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BookmarkEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BookmarkEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}book_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      progress: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}progress'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $BookmarksTable createAlias(String alias) {
    return $BookmarksTable(attachedDatabase, alias);
  }
}

class BookmarkEntity extends DataClass implements Insertable<BookmarkEntity> {
  final int id;
  final int bookId;
  final String title;
  final double progress;
  final DateTime createdAt;
  final String position;
  const BookmarkEntity({
    required this.id,
    required this.bookId,
    required this.title,
    required this.progress,
    required this.createdAt,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['book_id'] = Variable<int>(bookId);
    map['title'] = Variable<String>(title);
    map['progress'] = Variable<double>(progress);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['position'] = Variable<String>(position);
    return map;
  }

  BookmarksCompanion toCompanion(bool nullToAbsent) {
    return BookmarksCompanion(
      id: Value(id),
      bookId: Value(bookId),
      title: Value(title),
      progress: Value(progress),
      createdAt: Value(createdAt),
      position: Value(position),
    );
  }

  factory BookmarkEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BookmarkEntity(
      id: serializer.fromJson<int>(json['id']),
      bookId: serializer.fromJson<int>(json['bookId']),
      title: serializer.fromJson<String>(json['title']),
      progress: serializer.fromJson<double>(json['progress']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      position: serializer.fromJson<String>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bookId': serializer.toJson<int>(bookId),
      'title': serializer.toJson<String>(title),
      'progress': serializer.toJson<double>(progress),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'position': serializer.toJson<String>(position),
    };
  }

  BookmarkEntity copyWith({
    int? id,
    int? bookId,
    String? title,
    double? progress,
    DateTime? createdAt,
    String? position,
  }) => BookmarkEntity(
    id: id ?? this.id,
    bookId: bookId ?? this.bookId,
    title: title ?? this.title,
    progress: progress ?? this.progress,
    createdAt: createdAt ?? this.createdAt,
    position: position ?? this.position,
  );
  BookmarkEntity copyWithCompanion(BookmarksCompanion data) {
    return BookmarkEntity(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      title: data.title.present ? data.title.value : this.title,
      progress: data.progress.present ? data.progress.value : this.progress,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BookmarkEntity(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('title: $title, ')
          ..write('progress: $progress, ')
          ..write('createdAt: $createdAt, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, bookId, title, progress, createdAt, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookmarkEntity &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.title == this.title &&
          other.progress == this.progress &&
          other.createdAt == this.createdAt &&
          other.position == this.position);
}

class BookmarksCompanion extends UpdateCompanion<BookmarkEntity> {
  final Value<int> id;
  final Value<int> bookId;
  final Value<String> title;
  final Value<double> progress;
  final Value<DateTime> createdAt;
  final Value<String> position;
  const BookmarksCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.title = const Value.absent(),
    this.progress = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.position = const Value.absent(),
  });
  BookmarksCompanion.insert({
    this.id = const Value.absent(),
    required int bookId,
    required String title,
    required double progress,
    required DateTime createdAt,
    required String position,
  }) : bookId = Value(bookId),
       title = Value(title),
       progress = Value(progress),
       createdAt = Value(createdAt),
       position = Value(position);
  static Insertable<BookmarkEntity> custom({
    Expression<int>? id,
    Expression<int>? bookId,
    Expression<String>? title,
    Expression<double>? progress,
    Expression<DateTime>? createdAt,
    Expression<String>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (title != null) 'title': title,
      if (progress != null) 'progress': progress,
      if (createdAt != null) 'created_at': createdAt,
      if (position != null) 'position': position,
    });
  }

  BookmarksCompanion copyWith({
    Value<int>? id,
    Value<int>? bookId,
    Value<String>? title,
    Value<double>? progress,
    Value<DateTime>? createdAt,
    Value<String>? position,
  }) {
    return BookmarksCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      title: title ?? this.title,
      progress: progress ?? this.progress,
      createdAt: createdAt ?? this.createdAt,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<int>(bookId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (progress.present) {
      map['progress'] = Variable<double>(progress.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (position.present) {
      map['position'] = Variable<String>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookmarksCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('title: $title, ')
          ..write('progress: $progress, ')
          ..write('createdAt: $createdAt, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $QuestsTable extends Quests with TableInfo<$QuestsTable, QuestEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<QuestType, int> type =
      GeneratedColumn<int>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<QuestType>($QuestsTable.$convertertype);
  static const VerificationMeta _targetValueMeta = const VerificationMeta(
    'targetValue',
  );
  @override
  late final GeneratedColumn<int> targetValue = GeneratedColumn<int>(
    'target_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentValueMeta = const VerificationMeta(
    'currentValue',
  );
  @override
  late final GeneratedColumn<int> currentValue = GeneratedColumn<int>(
    'current_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _wpRewardMeta = const VerificationMeta(
    'wpReward',
  );
  @override
  late final GeneratedColumn<int> wpReward = GeneratedColumn<int>(
    'wp_reward',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    type,
    targetValue,
    currentValue,
    wpReward,
    isCompleted,
    date,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quests';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuestEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('target_value')) {
      context.handle(
        _targetValueMeta,
        targetValue.isAcceptableOrUnknown(
          data['target_value']!,
          _targetValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetValueMeta);
    }
    if (data.containsKey('current_value')) {
      context.handle(
        _currentValueMeta,
        currentValue.isAcceptableOrUnknown(
          data['current_value']!,
          _currentValueMeta,
        ),
      );
    }
    if (data.containsKey('wp_reward')) {
      context.handle(
        _wpRewardMeta,
        wpReward.isAcceptableOrUnknown(data['wp_reward']!, _wpRewardMeta),
      );
    } else if (isInserting) {
      context.missing(_wpRewardMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuestEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuestEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      type: $QuestsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}type'],
        )!,
      ),
      targetValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_value'],
      )!,
      currentValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_value'],
      )!,
      wpReward: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wp_reward'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
    );
  }

  @override
  $QuestsTable createAlias(String alias) {
    return $QuestsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<QuestType, int, int> $convertertype =
      const EnumIndexConverter<QuestType>(QuestType.values);
}

class QuestEntity extends DataClass implements Insertable<QuestEntity> {
  final String id;
  final String title;
  final String description;
  final QuestType type;
  final int targetValue;
  final int currentValue;
  final int wpReward;
  final bool isCompleted;
  final String date;
  const QuestEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.targetValue,
    required this.currentValue,
    required this.wpReward,
    required this.isCompleted,
    required this.date,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    {
      map['type'] = Variable<int>($QuestsTable.$convertertype.toSql(type));
    }
    map['target_value'] = Variable<int>(targetValue);
    map['current_value'] = Variable<int>(currentValue);
    map['wp_reward'] = Variable<int>(wpReward);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['date'] = Variable<String>(date);
    return map;
  }

  QuestsCompanion toCompanion(bool nullToAbsent) {
    return QuestsCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      type: Value(type),
      targetValue: Value(targetValue),
      currentValue: Value(currentValue),
      wpReward: Value(wpReward),
      isCompleted: Value(isCompleted),
      date: Value(date),
    );
  }

  factory QuestEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuestEntity(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      type: $QuestsTable.$convertertype.fromJson(
        serializer.fromJson<int>(json['type']),
      ),
      targetValue: serializer.fromJson<int>(json['targetValue']),
      currentValue: serializer.fromJson<int>(json['currentValue']),
      wpReward: serializer.fromJson<int>(json['wpReward']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      date: serializer.fromJson<String>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'type': serializer.toJson<int>($QuestsTable.$convertertype.toJson(type)),
      'targetValue': serializer.toJson<int>(targetValue),
      'currentValue': serializer.toJson<int>(currentValue),
      'wpReward': serializer.toJson<int>(wpReward),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'date': serializer.toJson<String>(date),
    };
  }

  QuestEntity copyWith({
    String? id,
    String? title,
    String? description,
    QuestType? type,
    int? targetValue,
    int? currentValue,
    int? wpReward,
    bool? isCompleted,
    String? date,
  }) => QuestEntity(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    type: type ?? this.type,
    targetValue: targetValue ?? this.targetValue,
    currentValue: currentValue ?? this.currentValue,
    wpReward: wpReward ?? this.wpReward,
    isCompleted: isCompleted ?? this.isCompleted,
    date: date ?? this.date,
  );
  QuestEntity copyWithCompanion(QuestsCompanion data) {
    return QuestEntity(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      type: data.type.present ? data.type.value : this.type,
      targetValue: data.targetValue.present
          ? data.targetValue.value
          : this.targetValue,
      currentValue: data.currentValue.present
          ? data.currentValue.value
          : this.currentValue,
      wpReward: data.wpReward.present ? data.wpReward.value : this.wpReward,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      date: data.date.present ? data.date.value : this.date,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuestEntity(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('targetValue: $targetValue, ')
          ..write('currentValue: $currentValue, ')
          ..write('wpReward: $wpReward, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    type,
    targetValue,
    currentValue,
    wpReward,
    isCompleted,
    date,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuestEntity &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.type == this.type &&
          other.targetValue == this.targetValue &&
          other.currentValue == this.currentValue &&
          other.wpReward == this.wpReward &&
          other.isCompleted == this.isCompleted &&
          other.date == this.date);
}

class QuestsCompanion extends UpdateCompanion<QuestEntity> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> description;
  final Value<QuestType> type;
  final Value<int> targetValue;
  final Value<int> currentValue;
  final Value<int> wpReward;
  final Value<bool> isCompleted;
  final Value<String> date;
  final Value<int> rowid;
  const QuestsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.type = const Value.absent(),
    this.targetValue = const Value.absent(),
    this.currentValue = const Value.absent(),
    this.wpReward = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.date = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuestsCompanion.insert({
    required String id,
    required String title,
    required String description,
    required QuestType type,
    required int targetValue,
    this.currentValue = const Value.absent(),
    required int wpReward,
    this.isCompleted = const Value.absent(),
    required String date,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       description = Value(description),
       type = Value(type),
       targetValue = Value(targetValue),
       wpReward = Value(wpReward),
       date = Value(date);
  static Insertable<QuestEntity> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<int>? type,
    Expression<int>? targetValue,
    Expression<int>? currentValue,
    Expression<int>? wpReward,
    Expression<bool>? isCompleted,
    Expression<String>? date,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (type != null) 'type': type,
      if (targetValue != null) 'target_value': targetValue,
      if (currentValue != null) 'current_value': currentValue,
      if (wpReward != null) 'wp_reward': wpReward,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (date != null) 'date': date,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuestsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? description,
    Value<QuestType>? type,
    Value<int>? targetValue,
    Value<int>? currentValue,
    Value<int>? wpReward,
    Value<bool>? isCompleted,
    Value<String>? date,
    Value<int>? rowid,
  }) {
    return QuestsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      wpReward: wpReward ?? this.wpReward,
      isCompleted: isCompleted ?? this.isCompleted,
      date: date ?? this.date,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(
        $QuestsTable.$convertertype.toSql(type.value),
      );
    }
    if (targetValue.present) {
      map['target_value'] = Variable<int>(targetValue.value);
    }
    if (currentValue.present) {
      map['current_value'] = Variable<int>(currentValue.value);
    }
    if (wpReward.present) {
      map['wp_reward'] = Variable<int>(wpReward.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('targetValue: $targetValue, ')
          ..write('currentValue: $currentValue, ')
          ..write('wpReward: $wpReward, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('date: $date, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HighlightsTable extends Highlights
    with TableInfo<$HighlightsTable, HighlightEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HighlightsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<int> bookId = GeneratedColumn<int>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES books (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _chapterIndexMeta = const VerificationMeta(
    'chapterIndex',
  );
  @override
  late final GeneratedColumn<int> chapterIndex = GeneratedColumn<int>(
    'chapter_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _textValueMeta = const VerificationMeta(
    'textValue',
  );
  @override
  late final GeneratedColumn<String> textValue = GeneratedColumn<String>(
    'text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<String> position = GeneratedColumn<String>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bookId,
    chapterIndex,
    textValue,
    note,
    color,
    createdAt,
    position,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'highlights';
  @override
  VerificationContext validateIntegrity(
    Insertable<HighlightEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('chapter_index')) {
      context.handle(
        _chapterIndexMeta,
        chapterIndex.isAcceptableOrUnknown(
          data['chapter_index']!,
          _chapterIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_chapterIndexMeta);
    }
    if (data.containsKey('text')) {
      context.handle(
        _textValueMeta,
        textValue.isAcceptableOrUnknown(data['text']!, _textValueMeta),
      );
    } else if (isInserting) {
      context.missing(_textValueMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HighlightEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HighlightEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}book_id'],
      )!,
      chapterIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chapter_index'],
      )!,
      textValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $HighlightsTable createAlias(String alias) {
    return $HighlightsTable(attachedDatabase, alias);
  }
}

class HighlightEntity extends DataClass implements Insertable<HighlightEntity> {
  final int id;
  final int bookId;
  final int chapterIndex;
  final String textValue;
  final String? note;
  final String color;
  final DateTime createdAt;
  final String position;
  const HighlightEntity({
    required this.id,
    required this.bookId,
    required this.chapterIndex,
    required this.textValue,
    this.note,
    required this.color,
    required this.createdAt,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['book_id'] = Variable<int>(bookId);
    map['chapter_index'] = Variable<int>(chapterIndex);
    map['text'] = Variable<String>(textValue);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['color'] = Variable<String>(color);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['position'] = Variable<String>(position);
    return map;
  }

  HighlightsCompanion toCompanion(bool nullToAbsent) {
    return HighlightsCompanion(
      id: Value(id),
      bookId: Value(bookId),
      chapterIndex: Value(chapterIndex),
      textValue: Value(textValue),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      color: Value(color),
      createdAt: Value(createdAt),
      position: Value(position),
    );
  }

  factory HighlightEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HighlightEntity(
      id: serializer.fromJson<int>(json['id']),
      bookId: serializer.fromJson<int>(json['bookId']),
      chapterIndex: serializer.fromJson<int>(json['chapterIndex']),
      textValue: serializer.fromJson<String>(json['textValue']),
      note: serializer.fromJson<String?>(json['note']),
      color: serializer.fromJson<String>(json['color']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      position: serializer.fromJson<String>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bookId': serializer.toJson<int>(bookId),
      'chapterIndex': serializer.toJson<int>(chapterIndex),
      'textValue': serializer.toJson<String>(textValue),
      'note': serializer.toJson<String?>(note),
      'color': serializer.toJson<String>(color),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'position': serializer.toJson<String>(position),
    };
  }

  HighlightEntity copyWith({
    int? id,
    int? bookId,
    int? chapterIndex,
    String? textValue,
    Value<String?> note = const Value.absent(),
    String? color,
    DateTime? createdAt,
    String? position,
  }) => HighlightEntity(
    id: id ?? this.id,
    bookId: bookId ?? this.bookId,
    chapterIndex: chapterIndex ?? this.chapterIndex,
    textValue: textValue ?? this.textValue,
    note: note.present ? note.value : this.note,
    color: color ?? this.color,
    createdAt: createdAt ?? this.createdAt,
    position: position ?? this.position,
  );
  HighlightEntity copyWithCompanion(HighlightsCompanion data) {
    return HighlightEntity(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      chapterIndex: data.chapterIndex.present
          ? data.chapterIndex.value
          : this.chapterIndex,
      textValue: data.textValue.present ? data.textValue.value : this.textValue,
      note: data.note.present ? data.note.value : this.note,
      color: data.color.present ? data.color.value : this.color,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HighlightEntity(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('chapterIndex: $chapterIndex, ')
          ..write('textValue: $textValue, ')
          ..write('note: $note, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    bookId,
    chapterIndex,
    textValue,
    note,
    color,
    createdAt,
    position,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HighlightEntity &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.chapterIndex == this.chapterIndex &&
          other.textValue == this.textValue &&
          other.note == this.note &&
          other.color == this.color &&
          other.createdAt == this.createdAt &&
          other.position == this.position);
}

class HighlightsCompanion extends UpdateCompanion<HighlightEntity> {
  final Value<int> id;
  final Value<int> bookId;
  final Value<int> chapterIndex;
  final Value<String> textValue;
  final Value<String?> note;
  final Value<String> color;
  final Value<DateTime> createdAt;
  final Value<String> position;
  const HighlightsCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.chapterIndex = const Value.absent(),
    this.textValue = const Value.absent(),
    this.note = const Value.absent(),
    this.color = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.position = const Value.absent(),
  });
  HighlightsCompanion.insert({
    this.id = const Value.absent(),
    required int bookId,
    required int chapterIndex,
    required String textValue,
    this.note = const Value.absent(),
    required String color,
    required DateTime createdAt,
    required String position,
  }) : bookId = Value(bookId),
       chapterIndex = Value(chapterIndex),
       textValue = Value(textValue),
       color = Value(color),
       createdAt = Value(createdAt),
       position = Value(position);
  static Insertable<HighlightEntity> custom({
    Expression<int>? id,
    Expression<int>? bookId,
    Expression<int>? chapterIndex,
    Expression<String>? textValue,
    Expression<String>? note,
    Expression<String>? color,
    Expression<DateTime>? createdAt,
    Expression<String>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (chapterIndex != null) 'chapter_index': chapterIndex,
      if (textValue != null) 'text': textValue,
      if (note != null) 'note': note,
      if (color != null) 'color': color,
      if (createdAt != null) 'created_at': createdAt,
      if (position != null) 'position': position,
    });
  }

  HighlightsCompanion copyWith({
    Value<int>? id,
    Value<int>? bookId,
    Value<int>? chapterIndex,
    Value<String>? textValue,
    Value<String?>? note,
    Value<String>? color,
    Value<DateTime>? createdAt,
    Value<String>? position,
  }) {
    return HighlightsCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      chapterIndex: chapterIndex ?? this.chapterIndex,
      textValue: textValue ?? this.textValue,
      note: note ?? this.note,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<int>(bookId.value);
    }
    if (chapterIndex.present) {
      map['chapter_index'] = Variable<int>(chapterIndex.value);
    }
    if (textValue.present) {
      map['text'] = Variable<String>(textValue.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (position.present) {
      map['position'] = Variable<String>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HighlightsCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('chapterIndex: $chapterIndex, ')
          ..write('textValue: $textValue, ')
          ..write('note: $note, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $DictionaryLookupsTable extends DictionaryLookups
    with TableInfo<$DictionaryLookupsTable, DictionaryLookupEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DictionaryLookupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<int> bookId = GeneratedColumn<int>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES books (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _wordMeta = const VerificationMeta('word');
  @override
  late final GeneratedColumn<String> word = GeneratedColumn<String>(
    'word',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, bookId, word, timestamp];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dictionary_lookups';
  @override
  VerificationContext validateIntegrity(
    Insertable<DictionaryLookupEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('word')) {
      context.handle(
        _wordMeta,
        word.isAcceptableOrUnknown(data['word']!, _wordMeta),
      );
    } else if (isInserting) {
      context.missing(_wordMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DictionaryLookupEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DictionaryLookupEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}book_id'],
      )!,
      word: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}word'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $DictionaryLookupsTable createAlias(String alias) {
    return $DictionaryLookupsTable(attachedDatabase, alias);
  }
}

class DictionaryLookupEntity extends DataClass
    implements Insertable<DictionaryLookupEntity> {
  final int id;
  final int bookId;
  final String word;
  final DateTime timestamp;
  const DictionaryLookupEntity({
    required this.id,
    required this.bookId,
    required this.word,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['book_id'] = Variable<int>(bookId);
    map['word'] = Variable<String>(word);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  DictionaryLookupsCompanion toCompanion(bool nullToAbsent) {
    return DictionaryLookupsCompanion(
      id: Value(id),
      bookId: Value(bookId),
      word: Value(word),
      timestamp: Value(timestamp),
    );
  }

  factory DictionaryLookupEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DictionaryLookupEntity(
      id: serializer.fromJson<int>(json['id']),
      bookId: serializer.fromJson<int>(json['bookId']),
      word: serializer.fromJson<String>(json['word']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bookId': serializer.toJson<int>(bookId),
      'word': serializer.toJson<String>(word),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  DictionaryLookupEntity copyWith({
    int? id,
    int? bookId,
    String? word,
    DateTime? timestamp,
  }) => DictionaryLookupEntity(
    id: id ?? this.id,
    bookId: bookId ?? this.bookId,
    word: word ?? this.word,
    timestamp: timestamp ?? this.timestamp,
  );
  DictionaryLookupEntity copyWithCompanion(DictionaryLookupsCompanion data) {
    return DictionaryLookupEntity(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      word: data.word.present ? data.word.value : this.word,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DictionaryLookupEntity(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('word: $word, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, bookId, word, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DictionaryLookupEntity &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.word == this.word &&
          other.timestamp == this.timestamp);
}

class DictionaryLookupsCompanion
    extends UpdateCompanion<DictionaryLookupEntity> {
  final Value<int> id;
  final Value<int> bookId;
  final Value<String> word;
  final Value<DateTime> timestamp;
  const DictionaryLookupsCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.word = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  DictionaryLookupsCompanion.insert({
    this.id = const Value.absent(),
    required int bookId,
    required String word,
    required DateTime timestamp,
  }) : bookId = Value(bookId),
       word = Value(word),
       timestamp = Value(timestamp);
  static Insertable<DictionaryLookupEntity> custom({
    Expression<int>? id,
    Expression<int>? bookId,
    Expression<String>? word,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (word != null) 'word': word,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  DictionaryLookupsCompanion copyWith({
    Value<int>? id,
    Value<int>? bookId,
    Value<String>? word,
    Value<DateTime>? timestamp,
  }) {
    return DictionaryLookupsCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      word: word ?? this.word,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<int>(bookId.value);
    }
    if (word.present) {
      map['word'] = Variable<String>(word.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DictionaryLookupsCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('word: $word, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BooksTable books = $BooksTable(this);
  late final $ReadingSessionsTable readingSessions = $ReadingSessionsTable(
    this,
  );
  late final $BookmarksTable bookmarks = $BookmarksTable(this);
  late final $QuestsTable quests = $QuestsTable(this);
  late final $HighlightsTable highlights = $HighlightsTable(this);
  late final $DictionaryLookupsTable dictionaryLookups =
      $DictionaryLookupsTable(this);
  late final BooksDao booksDao = BooksDao(this as AppDatabase);
  late final ReadingSessionsDao readingSessionsDao = ReadingSessionsDao(
    this as AppDatabase,
  );
  late final BookmarksDao bookmarksDao = BookmarksDao(this as AppDatabase);
  late final QuestsDao questsDao = QuestsDao(this as AppDatabase);
  late final HighlightsDao highlightsDao = HighlightsDao(this as AppDatabase);
  late final DictionaryLookupsDao dictionaryLookupsDao = DictionaryLookupsDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    books,
    readingSessions,
    bookmarks,
    quests,
    highlights,
    dictionaryLookups,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'books',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reading_sessions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'books',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('bookmarks', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'books',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('highlights', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'books',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('dictionary_lookups', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$BooksTableCreateCompanionBuilder =
    BooksCompanion Function({
      Value<int> id,
      required String title,
      required String author,
      required String coverPath,
      required String filePath,
      Value<double> progress,
      required DateTime addedAt,
      Value<DateTime?> lastReadAt,
      Value<bool> isFavorite,
      Value<String?> series,
      Value<String?> tags,
      Value<String?> folderPath,
      Value<String> genre,
      Value<int> currentPage,
      Value<int> totalPages,
      Value<int> estimatedReadingMinutes,
      Value<String?> lastPosition,
      Value<String?> audioPath,
      Value<int?> audioLastPosition,
      Value<int?> audioLastIndex,
      Value<List<AudioTrack>> audioTracks,
      Value<String?> contentHash,
      Value<bool> isDeleted,
    });
typedef $$BooksTableUpdateCompanionBuilder =
    BooksCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> author,
      Value<String> coverPath,
      Value<String> filePath,
      Value<double> progress,
      Value<DateTime> addedAt,
      Value<DateTime?> lastReadAt,
      Value<bool> isFavorite,
      Value<String?> series,
      Value<String?> tags,
      Value<String?> folderPath,
      Value<String> genre,
      Value<int> currentPage,
      Value<int> totalPages,
      Value<int> estimatedReadingMinutes,
      Value<String?> lastPosition,
      Value<String?> audioPath,
      Value<int?> audioLastPosition,
      Value<int?> audioLastIndex,
      Value<List<AudioTrack>> audioTracks,
      Value<String?> contentHash,
      Value<bool> isDeleted,
    });

final class $$BooksTableReferences
    extends BaseReferences<_$AppDatabase, $BooksTable, BookEntity> {
  $$BooksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ReadingSessionsTable, List<ReadingSessionEntity>>
  _readingSessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.readingSessions,
    aliasName: 'books__id__reading_sessions__book_id',
  );

  $$ReadingSessionsTableProcessedTableManager get readingSessionsRefs {
    final manager = $$ReadingSessionsTableTableManager(
      $_db,
      $_db.readingSessions,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _readingSessionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BookmarksTable, List<BookmarkEntity>>
  _bookmarksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.bookmarks,
    aliasName: 'books__id__bookmarks__book_id',
  );

  $$BookmarksTableProcessedTableManager get bookmarksRefs {
    final manager = $$BookmarksTableTableManager(
      $_db,
      $_db.bookmarks,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_bookmarksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$HighlightsTable, List<HighlightEntity>>
  _highlightsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.highlights,
    aliasName: 'books__id__highlights__book_id',
  );

  $$HighlightsTableProcessedTableManager get highlightsRefs {
    final manager = $$HighlightsTableTableManager(
      $_db,
      $_db.highlights,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_highlightsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $DictionaryLookupsTable,
    List<DictionaryLookupEntity>
  >
  _dictionaryLookupsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.dictionaryLookups,
        aliasName: 'books__id__dictionary_lookups__book_id',
      );

  $$DictionaryLookupsTableProcessedTableManager get dictionaryLookupsRefs {
    final manager = $$DictionaryLookupsTableTableManager(
      $_db,
      $_db.dictionaryLookups,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _dictionaryLookupsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BooksTableFilterComposer extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverPath => $composableBuilder(
    column: $table.coverPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastReadAt => $composableBuilder(
    column: $table.lastReadAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get series => $composableBuilder(
    column: $table.series,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get folderPath => $composableBuilder(
    column: $table.folderPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get genre => $composableBuilder(
    column: $table.genre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentPage => $composableBuilder(
    column: $table.currentPage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalPages => $composableBuilder(
    column: $table.totalPages,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimatedReadingMinutes => $composableBuilder(
    column: $table.estimatedReadingMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastPosition => $composableBuilder(
    column: $table.lastPosition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioPath => $composableBuilder(
    column: $table.audioPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get audioLastPosition => $composableBuilder(
    column: $table.audioLastPosition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get audioLastIndex => $composableBuilder(
    column: $table.audioLastIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<AudioTrack>, List<AudioTrack>, String>
  get audioTracks => $composableBuilder(
    column: $table.audioTracks,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> readingSessionsRefs(
    Expression<bool> Function($$ReadingSessionsTableFilterComposer f) f,
  ) {
    final $$ReadingSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readingSessions,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingSessionsTableFilterComposer(
            $db: $db,
            $table: $db.readingSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> bookmarksRefs(
    Expression<bool> Function($$BookmarksTableFilterComposer f) f,
  ) {
    final $$BookmarksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bookmarks,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookmarksTableFilterComposer(
            $db: $db,
            $table: $db.bookmarks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> highlightsRefs(
    Expression<bool> Function($$HighlightsTableFilterComposer f) f,
  ) {
    final $$HighlightsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.highlights,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HighlightsTableFilterComposer(
            $db: $db,
            $table: $db.highlights,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> dictionaryLookupsRefs(
    Expression<bool> Function($$DictionaryLookupsTableFilterComposer f) f,
  ) {
    final $$DictionaryLookupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dictionaryLookups,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DictionaryLookupsTableFilterComposer(
            $db: $db,
            $table: $db.dictionaryLookups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BooksTableOrderingComposer
    extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverPath => $composableBuilder(
    column: $table.coverPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastReadAt => $composableBuilder(
    column: $table.lastReadAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get series => $composableBuilder(
    column: $table.series,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get folderPath => $composableBuilder(
    column: $table.folderPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get genre => $composableBuilder(
    column: $table.genre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentPage => $composableBuilder(
    column: $table.currentPage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalPages => $composableBuilder(
    column: $table.totalPages,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedReadingMinutes => $composableBuilder(
    column: $table.estimatedReadingMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastPosition => $composableBuilder(
    column: $table.lastPosition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioPath => $composableBuilder(
    column: $table.audioPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get audioLastPosition => $composableBuilder(
    column: $table.audioLastPosition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get audioLastIndex => $composableBuilder(
    column: $table.audioLastIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioTracks => $composableBuilder(
    column: $table.audioTracks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BooksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<String> get coverPath =>
      $composableBuilder(column: $table.coverPath, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<double> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastReadAt => $composableBuilder(
    column: $table.lastReadAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<String> get series =>
      $composableBuilder(column: $table.series, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get folderPath => $composableBuilder(
    column: $table.folderPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get genre =>
      $composableBuilder(column: $table.genre, builder: (column) => column);

  GeneratedColumn<int> get currentPage => $composableBuilder(
    column: $table.currentPage,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalPages => $composableBuilder(
    column: $table.totalPages,
    builder: (column) => column,
  );

  GeneratedColumn<int> get estimatedReadingMinutes => $composableBuilder(
    column: $table.estimatedReadingMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastPosition => $composableBuilder(
    column: $table.lastPosition,
    builder: (column) => column,
  );

  GeneratedColumn<String> get audioPath =>
      $composableBuilder(column: $table.audioPath, builder: (column) => column);

  GeneratedColumn<int> get audioLastPosition => $composableBuilder(
    column: $table.audioLastPosition,
    builder: (column) => column,
  );

  GeneratedColumn<int> get audioLastIndex => $composableBuilder(
    column: $table.audioLastIndex,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<AudioTrack>, String> get audioTracks =>
      $composableBuilder(
        column: $table.audioTracks,
        builder: (column) => column,
      );

  GeneratedColumn<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  Expression<T> readingSessionsRefs<T extends Object>(
    Expression<T> Function($$ReadingSessionsTableAnnotationComposer a) f,
  ) {
    final $$ReadingSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readingSessions,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.readingSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> bookmarksRefs<T extends Object>(
    Expression<T> Function($$BookmarksTableAnnotationComposer a) f,
  ) {
    final $$BookmarksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bookmarks,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookmarksTableAnnotationComposer(
            $db: $db,
            $table: $db.bookmarks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> highlightsRefs<T extends Object>(
    Expression<T> Function($$HighlightsTableAnnotationComposer a) f,
  ) {
    final $$HighlightsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.highlights,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HighlightsTableAnnotationComposer(
            $db: $db,
            $table: $db.highlights,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> dictionaryLookupsRefs<T extends Object>(
    Expression<T> Function($$DictionaryLookupsTableAnnotationComposer a) f,
  ) {
    final $$DictionaryLookupsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.dictionaryLookups,
          getReferencedColumn: (t) => t.bookId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DictionaryLookupsTableAnnotationComposer(
                $db: $db,
                $table: $db.dictionaryLookups,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$BooksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BooksTable,
          BookEntity,
          $$BooksTableFilterComposer,
          $$BooksTableOrderingComposer,
          $$BooksTableAnnotationComposer,
          $$BooksTableCreateCompanionBuilder,
          $$BooksTableUpdateCompanionBuilder,
          (BookEntity, $$BooksTableReferences),
          BookEntity,
          PrefetchHooks Function({
            bool readingSessionsRefs,
            bool bookmarksRefs,
            bool highlightsRefs,
            bool dictionaryLookupsRefs,
          })
        > {
  $$BooksTableTableManager(_$AppDatabase db, $BooksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BooksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BooksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BooksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> author = const Value.absent(),
                Value<String> coverPath = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<double> progress = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<DateTime?> lastReadAt = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<String?> series = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<String?> folderPath = const Value.absent(),
                Value<String> genre = const Value.absent(),
                Value<int> currentPage = const Value.absent(),
                Value<int> totalPages = const Value.absent(),
                Value<int> estimatedReadingMinutes = const Value.absent(),
                Value<String?> lastPosition = const Value.absent(),
                Value<String?> audioPath = const Value.absent(),
                Value<int?> audioLastPosition = const Value.absent(),
                Value<int?> audioLastIndex = const Value.absent(),
                Value<List<AudioTrack>> audioTracks = const Value.absent(),
                Value<String?> contentHash = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
              }) => BooksCompanion(
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
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String author,
                required String coverPath,
                required String filePath,
                Value<double> progress = const Value.absent(),
                required DateTime addedAt,
                Value<DateTime?> lastReadAt = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<String?> series = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<String?> folderPath = const Value.absent(),
                Value<String> genre = const Value.absent(),
                Value<int> currentPage = const Value.absent(),
                Value<int> totalPages = const Value.absent(),
                Value<int> estimatedReadingMinutes = const Value.absent(),
                Value<String?> lastPosition = const Value.absent(),
                Value<String?> audioPath = const Value.absent(),
                Value<int?> audioLastPosition = const Value.absent(),
                Value<int?> audioLastIndex = const Value.absent(),
                Value<List<AudioTrack>> audioTracks = const Value.absent(),
                Value<String?> contentHash = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
              }) => BooksCompanion.insert(
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
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$BooksTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                readingSessionsRefs = false,
                bookmarksRefs = false,
                highlightsRefs = false,
                dictionaryLookupsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (readingSessionsRefs) db.readingSessions,
                    if (bookmarksRefs) db.bookmarks,
                    if (highlightsRefs) db.highlights,
                    if (dictionaryLookupsRefs) db.dictionaryLookups,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (readingSessionsRefs)
                        await $_getPrefetchedData<
                          BookEntity,
                          $BooksTable,
                          ReadingSessionEntity
                        >(
                          currentTable: table,
                          referencedTable: $$BooksTableReferences
                              ._readingSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BooksTableReferences(
                                db,
                                table,
                                p0,
                              ).readingSessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bookId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (bookmarksRefs)
                        await $_getPrefetchedData<
                          BookEntity,
                          $BooksTable,
                          BookmarkEntity
                        >(
                          currentTable: table,
                          referencedTable: $$BooksTableReferences
                              ._bookmarksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BooksTableReferences(
                                db,
                                table,
                                p0,
                              ).bookmarksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bookId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (highlightsRefs)
                        await $_getPrefetchedData<
                          BookEntity,
                          $BooksTable,
                          HighlightEntity
                        >(
                          currentTable: table,
                          referencedTable: $$BooksTableReferences
                              ._highlightsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BooksTableReferences(
                                db,
                                table,
                                p0,
                              ).highlightsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bookId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (dictionaryLookupsRefs)
                        await $_getPrefetchedData<
                          BookEntity,
                          $BooksTable,
                          DictionaryLookupEntity
                        >(
                          currentTable: table,
                          referencedTable: $$BooksTableReferences
                              ._dictionaryLookupsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BooksTableReferences(
                                db,
                                table,
                                p0,
                              ).dictionaryLookupsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bookId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$BooksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BooksTable,
      BookEntity,
      $$BooksTableFilterComposer,
      $$BooksTableOrderingComposer,
      $$BooksTableAnnotationComposer,
      $$BooksTableCreateCompanionBuilder,
      $$BooksTableUpdateCompanionBuilder,
      (BookEntity, $$BooksTableReferences),
      BookEntity,
      PrefetchHooks Function({
        bool readingSessionsRefs,
        bool bookmarksRefs,
        bool highlightsRefs,
        bool dictionaryLookupsRefs,
      })
    >;
typedef $$ReadingSessionsTableCreateCompanionBuilder =
    ReadingSessionsCompanion Function({
      Value<int> id,
      required int bookId,
      required String date,
      required int pagesRead,
      required int durationMinutes,
      required DateTime timestamp,
    });
typedef $$ReadingSessionsTableUpdateCompanionBuilder =
    ReadingSessionsCompanion Function({
      Value<int> id,
      Value<int> bookId,
      Value<String> date,
      Value<int> pagesRead,
      Value<int> durationMinutes,
      Value<DateTime> timestamp,
    });

final class $$ReadingSessionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ReadingSessionsTable,
          ReadingSessionEntity
        > {
  $$ReadingSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BooksTable _bookIdTable(_$AppDatabase db) =>
      db.books.createAlias('reading_sessions__book_id__books__id');

  $$BooksTableProcessedTableManager get bookId {
    final $_column = $_itemColumn<int>('book_id')!;

    final manager = $$BooksTableTableManager(
      $_db,
      $_db.books,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReadingSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $ReadingSessionsTable> {
  $$ReadingSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pagesRead => $composableBuilder(
    column: $table.pagesRead,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  $$BooksTableFilterComposer get bookId {
    final $$BooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableFilterComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReadingSessionsTable> {
  $$ReadingSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pagesRead => $composableBuilder(
    column: $table.pagesRead,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  $$BooksTableOrderingComposer get bookId {
    final $$BooksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableOrderingComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReadingSessionsTable> {
  $$ReadingSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get pagesRead =>
      $composableBuilder(column: $table.pagesRead, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  $$BooksTableAnnotationComposer get bookId {
    final $$BooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableAnnotationComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReadingSessionsTable,
          ReadingSessionEntity,
          $$ReadingSessionsTableFilterComposer,
          $$ReadingSessionsTableOrderingComposer,
          $$ReadingSessionsTableAnnotationComposer,
          $$ReadingSessionsTableCreateCompanionBuilder,
          $$ReadingSessionsTableUpdateCompanionBuilder,
          (ReadingSessionEntity, $$ReadingSessionsTableReferences),
          ReadingSessionEntity,
          PrefetchHooks Function({bool bookId})
        > {
  $$ReadingSessionsTableTableManager(
    _$AppDatabase db,
    $ReadingSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadingSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadingSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReadingSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> bookId = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<int> pagesRead = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
              }) => ReadingSessionsCompanion(
                id: id,
                bookId: bookId,
                date: date,
                pagesRead: pagesRead,
                durationMinutes: durationMinutes,
                timestamp: timestamp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int bookId,
                required String date,
                required int pagesRead,
                required int durationMinutes,
                required DateTime timestamp,
              }) => ReadingSessionsCompanion.insert(
                id: id,
                bookId: bookId,
                date: date,
                pagesRead: pagesRead,
                durationMinutes: durationMinutes,
                timestamp: timestamp,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ReadingSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bookId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (bookId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.bookId,
                                referencedTable:
                                    $$ReadingSessionsTableReferences
                                        ._bookIdTable(db),
                                referencedColumn:
                                    $$ReadingSessionsTableReferences
                                        ._bookIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReadingSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReadingSessionsTable,
      ReadingSessionEntity,
      $$ReadingSessionsTableFilterComposer,
      $$ReadingSessionsTableOrderingComposer,
      $$ReadingSessionsTableAnnotationComposer,
      $$ReadingSessionsTableCreateCompanionBuilder,
      $$ReadingSessionsTableUpdateCompanionBuilder,
      (ReadingSessionEntity, $$ReadingSessionsTableReferences),
      ReadingSessionEntity,
      PrefetchHooks Function({bool bookId})
    >;
typedef $$BookmarksTableCreateCompanionBuilder =
    BookmarksCompanion Function({
      Value<int> id,
      required int bookId,
      required String title,
      required double progress,
      required DateTime createdAt,
      required String position,
    });
typedef $$BookmarksTableUpdateCompanionBuilder =
    BookmarksCompanion Function({
      Value<int> id,
      Value<int> bookId,
      Value<String> title,
      Value<double> progress,
      Value<DateTime> createdAt,
      Value<String> position,
    });

final class $$BookmarksTableReferences
    extends BaseReferences<_$AppDatabase, $BookmarksTable, BookmarkEntity> {
  $$BookmarksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BooksTable _bookIdTable(_$AppDatabase db) =>
      db.books.createAlias('bookmarks__book_id__books__id');

  $$BooksTableProcessedTableManager get bookId {
    final $_column = $_itemColumn<int>('book_id')!;

    final manager = $$BooksTableTableManager(
      $_db,
      $_db.books,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BookmarksTableFilterComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  $$BooksTableFilterComposer get bookId {
    final $$BooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableFilterComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BookmarksTableOrderingComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  $$BooksTableOrderingComposer get bookId {
    final $$BooksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableOrderingComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BookmarksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<double> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  $$BooksTableAnnotationComposer get bookId {
    final $$BooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableAnnotationComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BookmarksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BookmarksTable,
          BookmarkEntity,
          $$BookmarksTableFilterComposer,
          $$BookmarksTableOrderingComposer,
          $$BookmarksTableAnnotationComposer,
          $$BookmarksTableCreateCompanionBuilder,
          $$BookmarksTableUpdateCompanionBuilder,
          (BookmarkEntity, $$BookmarksTableReferences),
          BookmarkEntity,
          PrefetchHooks Function({bool bookId})
        > {
  $$BookmarksTableTableManager(_$AppDatabase db, $BookmarksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookmarksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookmarksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookmarksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> bookId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<double> progress = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> position = const Value.absent(),
              }) => BookmarksCompanion(
                id: id,
                bookId: bookId,
                title: title,
                progress: progress,
                createdAt: createdAt,
                position: position,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int bookId,
                required String title,
                required double progress,
                required DateTime createdAt,
                required String position,
              }) => BookmarksCompanion.insert(
                id: id,
                bookId: bookId,
                title: title,
                progress: progress,
                createdAt: createdAt,
                position: position,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BookmarksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bookId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (bookId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.bookId,
                                referencedTable: $$BookmarksTableReferences
                                    ._bookIdTable(db),
                                referencedColumn: $$BookmarksTableReferences
                                    ._bookIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BookmarksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BookmarksTable,
      BookmarkEntity,
      $$BookmarksTableFilterComposer,
      $$BookmarksTableOrderingComposer,
      $$BookmarksTableAnnotationComposer,
      $$BookmarksTableCreateCompanionBuilder,
      $$BookmarksTableUpdateCompanionBuilder,
      (BookmarkEntity, $$BookmarksTableReferences),
      BookmarkEntity,
      PrefetchHooks Function({bool bookId})
    >;
typedef $$QuestsTableCreateCompanionBuilder =
    QuestsCompanion Function({
      required String id,
      required String title,
      required String description,
      required QuestType type,
      required int targetValue,
      Value<int> currentValue,
      required int wpReward,
      Value<bool> isCompleted,
      required String date,
      Value<int> rowid,
    });
typedef $$QuestsTableUpdateCompanionBuilder =
    QuestsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> description,
      Value<QuestType> type,
      Value<int> targetValue,
      Value<int> currentValue,
      Value<int> wpReward,
      Value<bool> isCompleted,
      Value<String> date,
      Value<int> rowid,
    });

class $$QuestsTableFilterComposer
    extends Composer<_$AppDatabase, $QuestsTable> {
  $$QuestsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<QuestType, QuestType, int> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentValue => $composableBuilder(
    column: $table.currentValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wpReward => $composableBuilder(
    column: $table.wpReward,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuestsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestsTable> {
  $$QuestsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentValue => $composableBuilder(
    column: $table.currentValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wpReward => $composableBuilder(
    column: $table.wpReward,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestsTable> {
  $$QuestsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<QuestType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentValue => $composableBuilder(
    column: $table.currentValue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get wpReward =>
      $composableBuilder(column: $table.wpReward, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);
}

class $$QuestsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuestsTable,
          QuestEntity,
          $$QuestsTableFilterComposer,
          $$QuestsTableOrderingComposer,
          $$QuestsTableAnnotationComposer,
          $$QuestsTableCreateCompanionBuilder,
          $$QuestsTableUpdateCompanionBuilder,
          (
            QuestEntity,
            BaseReferences<_$AppDatabase, $QuestsTable, QuestEntity>,
          ),
          QuestEntity,
          PrefetchHooks Function()
        > {
  $$QuestsTableTableManager(_$AppDatabase db, $QuestsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<QuestType> type = const Value.absent(),
                Value<int> targetValue = const Value.absent(),
                Value<int> currentValue = const Value.absent(),
                Value<int> wpReward = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuestsCompanion(
                id: id,
                title: title,
                description: description,
                type: type,
                targetValue: targetValue,
                currentValue: currentValue,
                wpReward: wpReward,
                isCompleted: isCompleted,
                date: date,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String description,
                required QuestType type,
                required int targetValue,
                Value<int> currentValue = const Value.absent(),
                required int wpReward,
                Value<bool> isCompleted = const Value.absent(),
                required String date,
                Value<int> rowid = const Value.absent(),
              }) => QuestsCompanion.insert(
                id: id,
                title: title,
                description: description,
                type: type,
                targetValue: targetValue,
                currentValue: currentValue,
                wpReward: wpReward,
                isCompleted: isCompleted,
                date: date,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuestsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuestsTable,
      QuestEntity,
      $$QuestsTableFilterComposer,
      $$QuestsTableOrderingComposer,
      $$QuestsTableAnnotationComposer,
      $$QuestsTableCreateCompanionBuilder,
      $$QuestsTableUpdateCompanionBuilder,
      (QuestEntity, BaseReferences<_$AppDatabase, $QuestsTable, QuestEntity>),
      QuestEntity,
      PrefetchHooks Function()
    >;
typedef $$HighlightsTableCreateCompanionBuilder =
    HighlightsCompanion Function({
      Value<int> id,
      required int bookId,
      required int chapterIndex,
      required String textValue,
      Value<String?> note,
      required String color,
      required DateTime createdAt,
      required String position,
    });
typedef $$HighlightsTableUpdateCompanionBuilder =
    HighlightsCompanion Function({
      Value<int> id,
      Value<int> bookId,
      Value<int> chapterIndex,
      Value<String> textValue,
      Value<String?> note,
      Value<String> color,
      Value<DateTime> createdAt,
      Value<String> position,
    });

final class $$HighlightsTableReferences
    extends BaseReferences<_$AppDatabase, $HighlightsTable, HighlightEntity> {
  $$HighlightsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BooksTable _bookIdTable(_$AppDatabase db) =>
      db.books.createAlias('highlights__book_id__books__id');

  $$BooksTableProcessedTableManager get bookId {
    final $_column = $_itemColumn<int>('book_id')!;

    final manager = $$BooksTableTableManager(
      $_db,
      $_db.books,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$HighlightsTableFilterComposer
    extends Composer<_$AppDatabase, $HighlightsTable> {
  $$HighlightsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chapterIndex => $composableBuilder(
    column: $table.chapterIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textValue => $composableBuilder(
    column: $table.textValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  $$BooksTableFilterComposer get bookId {
    final $$BooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableFilterComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HighlightsTableOrderingComposer
    extends Composer<_$AppDatabase, $HighlightsTable> {
  $$HighlightsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chapterIndex => $composableBuilder(
    column: $table.chapterIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textValue => $composableBuilder(
    column: $table.textValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  $$BooksTableOrderingComposer get bookId {
    final $$BooksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableOrderingComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HighlightsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HighlightsTable> {
  $$HighlightsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get chapterIndex => $composableBuilder(
    column: $table.chapterIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get textValue =>
      $composableBuilder(column: $table.textValue, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  $$BooksTableAnnotationComposer get bookId {
    final $$BooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableAnnotationComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HighlightsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HighlightsTable,
          HighlightEntity,
          $$HighlightsTableFilterComposer,
          $$HighlightsTableOrderingComposer,
          $$HighlightsTableAnnotationComposer,
          $$HighlightsTableCreateCompanionBuilder,
          $$HighlightsTableUpdateCompanionBuilder,
          (HighlightEntity, $$HighlightsTableReferences),
          HighlightEntity,
          PrefetchHooks Function({bool bookId})
        > {
  $$HighlightsTableTableManager(_$AppDatabase db, $HighlightsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HighlightsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HighlightsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HighlightsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> bookId = const Value.absent(),
                Value<int> chapterIndex = const Value.absent(),
                Value<String> textValue = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> position = const Value.absent(),
              }) => HighlightsCompanion(
                id: id,
                bookId: bookId,
                chapterIndex: chapterIndex,
                textValue: textValue,
                note: note,
                color: color,
                createdAt: createdAt,
                position: position,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int bookId,
                required int chapterIndex,
                required String textValue,
                Value<String?> note = const Value.absent(),
                required String color,
                required DateTime createdAt,
                required String position,
              }) => HighlightsCompanion.insert(
                id: id,
                bookId: bookId,
                chapterIndex: chapterIndex,
                textValue: textValue,
                note: note,
                color: color,
                createdAt: createdAt,
                position: position,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HighlightsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bookId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (bookId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.bookId,
                                referencedTable: $$HighlightsTableReferences
                                    ._bookIdTable(db),
                                referencedColumn: $$HighlightsTableReferences
                                    ._bookIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$HighlightsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HighlightsTable,
      HighlightEntity,
      $$HighlightsTableFilterComposer,
      $$HighlightsTableOrderingComposer,
      $$HighlightsTableAnnotationComposer,
      $$HighlightsTableCreateCompanionBuilder,
      $$HighlightsTableUpdateCompanionBuilder,
      (HighlightEntity, $$HighlightsTableReferences),
      HighlightEntity,
      PrefetchHooks Function({bool bookId})
    >;
typedef $$DictionaryLookupsTableCreateCompanionBuilder =
    DictionaryLookupsCompanion Function({
      Value<int> id,
      required int bookId,
      required String word,
      required DateTime timestamp,
    });
typedef $$DictionaryLookupsTableUpdateCompanionBuilder =
    DictionaryLookupsCompanion Function({
      Value<int> id,
      Value<int> bookId,
      Value<String> word,
      Value<DateTime> timestamp,
    });

final class $$DictionaryLookupsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $DictionaryLookupsTable,
          DictionaryLookupEntity
        > {
  $$DictionaryLookupsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BooksTable _bookIdTable(_$AppDatabase db) =>
      db.books.createAlias('dictionary_lookups__book_id__books__id');

  $$BooksTableProcessedTableManager get bookId {
    final $_column = $_itemColumn<int>('book_id')!;

    final manager = $$BooksTableTableManager(
      $_db,
      $_db.books,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DictionaryLookupsTableFilterComposer
    extends Composer<_$AppDatabase, $DictionaryLookupsTable> {
  $$DictionaryLookupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get word => $composableBuilder(
    column: $table.word,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  $$BooksTableFilterComposer get bookId {
    final $$BooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableFilterComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DictionaryLookupsTableOrderingComposer
    extends Composer<_$AppDatabase, $DictionaryLookupsTable> {
  $$DictionaryLookupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get word => $composableBuilder(
    column: $table.word,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  $$BooksTableOrderingComposer get bookId {
    final $$BooksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableOrderingComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DictionaryLookupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DictionaryLookupsTable> {
  $$DictionaryLookupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get word =>
      $composableBuilder(column: $table.word, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  $$BooksTableAnnotationComposer get bookId {
    final $$BooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableAnnotationComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DictionaryLookupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DictionaryLookupsTable,
          DictionaryLookupEntity,
          $$DictionaryLookupsTableFilterComposer,
          $$DictionaryLookupsTableOrderingComposer,
          $$DictionaryLookupsTableAnnotationComposer,
          $$DictionaryLookupsTableCreateCompanionBuilder,
          $$DictionaryLookupsTableUpdateCompanionBuilder,
          (DictionaryLookupEntity, $$DictionaryLookupsTableReferences),
          DictionaryLookupEntity,
          PrefetchHooks Function({bool bookId})
        > {
  $$DictionaryLookupsTableTableManager(
    _$AppDatabase db,
    $DictionaryLookupsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DictionaryLookupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DictionaryLookupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DictionaryLookupsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> bookId = const Value.absent(),
                Value<String> word = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
              }) => DictionaryLookupsCompanion(
                id: id,
                bookId: bookId,
                word: word,
                timestamp: timestamp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int bookId,
                required String word,
                required DateTime timestamp,
              }) => DictionaryLookupsCompanion.insert(
                id: id,
                bookId: bookId,
                word: word,
                timestamp: timestamp,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DictionaryLookupsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bookId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (bookId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.bookId,
                                referencedTable:
                                    $$DictionaryLookupsTableReferences
                                        ._bookIdTable(db),
                                referencedColumn:
                                    $$DictionaryLookupsTableReferences
                                        ._bookIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DictionaryLookupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DictionaryLookupsTable,
      DictionaryLookupEntity,
      $$DictionaryLookupsTableFilterComposer,
      $$DictionaryLookupsTableOrderingComposer,
      $$DictionaryLookupsTableAnnotationComposer,
      $$DictionaryLookupsTableCreateCompanionBuilder,
      $$DictionaryLookupsTableUpdateCompanionBuilder,
      (DictionaryLookupEntity, $$DictionaryLookupsTableReferences),
      DictionaryLookupEntity,
      PrefetchHooks Function({bool bookId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BooksTableTableManager get books =>
      $$BooksTableTableManager(_db, _db.books);
  $$ReadingSessionsTableTableManager get readingSessions =>
      $$ReadingSessionsTableTableManager(_db, _db.readingSessions);
  $$BookmarksTableTableManager get bookmarks =>
      $$BookmarksTableTableManager(_db, _db.bookmarks);
  $$QuestsTableTableManager get quests =>
      $$QuestsTableTableManager(_db, _db.quests);
  $$HighlightsTableTableManager get highlights =>
      $$HighlightsTableTableManager(_db, _db.highlights);
  $$DictionaryLookupsTableTableManager get dictionaryLookups =>
      $$DictionaryLookupsTableTableManager(_db, _db.dictionaryLookups);
}
