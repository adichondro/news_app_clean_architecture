import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/local/dao/article_dao.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/local/tables/article_table.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

/// Primary SQLite database manager for local data persistence powered by Drift.
///
/// Registers database tables ([ArticleTable]) and data access objects ([ArticleDao]).
@DriftDatabase(tables: [ArticleTable], daos: [ArticleDao])
class AppDatabase extends _$AppDatabase {
  /// Initializes the database instance using [_openConnection].
  AppDatabase() : super(_openConnection());

  /// Initializes an in-memory or custom [QueryExecutor] database instance for testing.
  @visibleForTesting
  AppDatabase.forTesting(super.executor);

  /// Specifies the current schema version for SQLite database migrations.
  @override
  int get schemaVersion => 1;
}

/// Opens a lazy connection to the SQLite database file on disk.
///
/// Uses [NativeDatabase.createInBackground] to perform database initialization
/// off the main UI isolate thread to prevent frame drops.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'news_app_db.sqlite'));

    return NativeDatabase.createInBackground(file);
  });
}

