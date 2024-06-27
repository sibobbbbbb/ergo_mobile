import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'ergo.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Boards (
        idBoard INTEGER PRIMARY KEY,
        namaBoard TEXT NOT NULL,
        isFavorite INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE Projects (
        idProject INTEGER PRIMARY KEY,
        idBoard INTEGER,
        namaProject TEXT NOT NULL,
        tingkatKetuntasan INTEGER,
        deadlineProject TEXT,
        isFavorite INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE Tasks (
        idTask INTEGER PRIMARY KEY,
        idProject INTEGER,
        namaTask TEXT NOT NULL,
        status TEXT,
        kategori TEXT,
        deskripsi TEXT,
        deadlineTask TEXT
      )
    ''');
  }

  Future<void> executeQuery(String query, [List<dynamic>? arguments]) async {
    final db = await database;
    await db.rawQuery(query, arguments);
  }
}
