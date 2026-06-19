// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_dao.dart';

// ignore_for_file: type=lint
mixin _$ArticleDaoMixin on DatabaseAccessor<AppDatabase> {
  $ArticleTableTable get articleTable => attachedDatabase.articleTable;
  ArticleDaoManager get managers => ArticleDaoManager(this);
}

class ArticleDaoManager {
  final _$ArticleDaoMixin _db;
  ArticleDaoManager(this._db);
  $$ArticleTableTableTableManager get articleTable =>
      $$ArticleTableTableTableManager(_db.attachedDatabase, _db.articleTable);
}
