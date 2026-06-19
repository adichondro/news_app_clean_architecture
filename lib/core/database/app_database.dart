import 'dart:io';

import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/local/dao/article_dao.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/local/tables/article_table.dart';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// File ini akan di-generate otomatis oleh build_runner
part 'app_database.g.dart';

// Daftarkan semua Tabel dan DAO Anda di dalam anotasi ini
@DriftDatabase(tables: [ArticleTable], daos: [ArticleDao])
class AppDatabase extends _$AppDatabase {
  // Constructor ini akan memanggil fungsi _openConnection() untuk menyiapkan file database
  AppDatabase() : super(_openConnection());

  // schemaVersion digunakan untuk mengatur versi database.
  // Jika di masa depan Anda menambahkan kolom baru ke ArticleTable,
  // Anda harus menaikkan angka ini menjadi 2, 3, dst., dan mengatur migrasinya.
  @override
  int get schemaVersion => 1;
}

// Fungsi untuk membuka (atau membuat) file SQLite di penyimpanan lokal perangkat
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // 1. Cari lokasi folder aman di perangkat (Application Documents Directory)
    final dbFolder = await getApplicationDocumentsDirectory();

    // 2. Buat file bernama 'news_app_db.sqlite' di dalam folder tersebut
    final file = File(p.join(dbFolder.path, 'news_app_db.sqlite'));

    // 3. Gunakan NativeDatabase.createInBackground agar proses pembuatan/pembukaan database
    //    tidak membuat UI (Main Thread) menjadi lag / freeze.
    return NativeDatabase.createInBackground(file);
  });
}
