import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/database/database.dart';
import '../core/repositories/database_repository.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final databaseRepositoryProvider = Provider<DatabaseRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return DatabaseRepositoryImpl(db);
});
