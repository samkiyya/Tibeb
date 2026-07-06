import 'dart:convert';
import 'package:drift/drift.dart';
import '../../models/book_model.dart';

class AudioTrackListConverter extends TypeConverter<List<AudioTrack>, String> {
  const AudioTrackListConverter();

  @override
  List<AudioTrack> fromSql(String fromDb) {
    try {
      final List<dynamic> list = json.decode(fromDb);
      return list.map((x) => AudioTrack.fromMap(x)).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  String toSql(List<AudioTrack> value) {
    return json.encode(value.map((x) => x.toMap()).toList());
  }
}
