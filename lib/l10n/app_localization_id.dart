// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localization.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Berita Harian';

  @override
  String get newsSourceDefault => 'BERITA';

  @override
  String get noTitle => 'Tanpa Judul';

  @override
  String get unknownAuthor => 'Penulis Tidak Dikenal';

  @override
  String get shareComingSoon => 'Fitur bagikan segera hadir!';

  @override
  String get refresh => 'Segarkan';

  @override
  String get exploreNews => 'Jelajahi Berita';

  @override
  String get tryAgain => 'Coba Lagi';

  @override
  String get clearAll => 'Hapus Semua';

  @override
  String get lightThemeTooltip => 'Beralih ke Mode Terang';

  @override
  String get darkThemeTooltip => 'Beralih ke Mode Gelap';

  @override
  String get articleSaved => 'Artikel berhasil disimpan!';

  @override
  String get articleRemoved => 'Artikel berhasil dihapus!';

  @override
  String get allArticlesCleared => 'Semua artikel berhasil dibersihkan!';

  @override
  String get savedArticlesTitle => 'Artikel Tersimpan';

  @override
  String get articlesBookmarkedSuffix => 'artikel tersimpan untuk dibaca nanti';

  @override
  String get noSavedArticlesTitle => 'Belum Ada Artikel Tersimpan';

  @override
  String get noSavedArticlesMessage =>
      'Artikel yang Anda simpan akan muncul di sini. Temukan berita menarik dan simpan menggunakan ikon bookmark.';

  @override
  String get popularTopicsTitle => 'Topik Populer untuk Anda';

  @override
  String get topicPolitics => 'Politik';

  @override
  String get topicTechnology => 'Teknologi';

  @override
  String get topicScience => 'Sains';

  @override
  String get topicHealth => 'Kesehatan';

  @override
  String get topicBusiness => 'Bisnis';

  @override
  String get oopsErrorTitle => 'Ups! Terjadi kesalahan';

  @override
  String get failedToLoadSavedArticles =>
      'Gagal memuat artikel tersimpan. Silakan coba lagi.';

  @override
  String get unexpectedError => 'Terjadi kesalahan yang tidak terduga.';

  @override
  String get connectionErrorTitle => 'Masalah Koneksi';

  @override
  String get connectionErrorMessage =>
      'Gagal memuat berita. Periksa koneksi internet Anda.';

  @override
  String get noArticlesFoundTitle => 'Tidak Ada Artikel';

  @override
  String get noArticlesFoundMessage =>
      'Belum ada artikel yang tersedia saat ini. Silakan periksa kembali nanti.';

  @override
  String get connectionTimeout =>
      'Batas waktu koneksi habis. Periksa koneksi internet Anda dan coba lagi.';

  @override
  String get noInternetConnection => 'Tidak ada koneksi internet.';

  @override
  String get serverErrorDefault =>
      'Terjadi kesalahan pada server. Silakan coba beberapa saat lagi.';

  @override
  String get changeLanguage => 'Ganti Bahasa';

  @override
  String get english => 'Bahasa Inggris';

  @override
  String get indonesian => 'Bahasa Indonesia';
}
