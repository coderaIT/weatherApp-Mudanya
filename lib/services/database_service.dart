import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/note_model.dart';
import '../utils/constants.dart';

/// SQLite veritabanı işlemleri — notları yerel olarak saklar.
class DatabaseService {
  static Database? _database;

  /// Veritabanı örneğini döndürür (yoksa oluşturur).
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// weather_notes.db dosyasını ve notes tablosunu oluşturur.
  Future<Database> _initDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, AppConstants.dbName);

      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          // Notlar tablosu: id, içerik, oluşturulma tarihi
          await db.execute('''
            CREATE TABLE ${AppConstants.notesTable} (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              content TEXT NOT NULL,
              createdAt TEXT NOT NULL
            )
          ''');
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Tüm notları en yeniden eskiye sıralı getirir.
  Future<List<NoteModel>> getNotes() async {
    try {
      final db = await database;
      final maps = await db.query(
        AppConstants.notesTable,
        orderBy: 'createdAt DESC',
      );
      return maps.map((map) => NoteModel.fromMap(map)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Yeni not ekler.
  Future<int> insertNote(NoteModel note) async {
    try {
      final db = await database;
      return await db.insert(
        AppConstants.notesTable,
        {
          'content': note.content,
          'createdAt': note.createdAt.toIso8601String(),
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Belirtilen id'li notu siler.
  Future<int> deleteNote(int id) async {
    try {
      final db = await database;
      return await db.delete(
        AppConstants.notesTable,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      rethrow;
    }
  }
}
