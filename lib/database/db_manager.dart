import 'package:sqflite/sqflite.dart';
import 'database.dart';
import 'db_helper.dart';

class DatabaseManager {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Boards CRUD operations
  Future<void> createBoard(Board board) async {
    final db = await _databaseHelper.database;
    await db.insert('Boards', board.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Board>> getAllBoards() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Boards');
    return List.generate(maps.length, (i) {
      return Board(
        idBoard: maps[i]['idBoard'],
        namaBoard: maps[i]['namaBoard'],
        isFavorite: maps[i]['isFavorite'],
      );
    });
  }

  Future<void> updateBoard(Board board) async {
    final db = await _databaseHelper.database;
    await db.update(
      'Boards',
      board.toMap(),
      where: 'idBoard = ?',
      whereArgs: [board.idBoard],
    );
  }

  Future<void> deleteBoard(int idBoard) async {
    final db = await _databaseHelper.database;
    await db.delete(
      'Boards',
      where: 'idBoard = ?',
      whereArgs: [idBoard],
    );
  }

  // Projects CRUD operations
  Future<void> createProject(Project project) async {
    final db = await _databaseHelper.database;
    await db.insert('Projects', project.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Project>> getAllProjects() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Projects');
    return List.generate(maps.length, (i) {
      return Project(
        idProject: maps[i]['idProject'],
        idBoard: maps[i]['idBoard'],
        namaProject: maps[i]['namaProject'],
        tingkatKetuntasan: maps[i]['tingkatKetuntasan'],
        deadlineProject: maps[i]['deadlineProject'],
        isFavorite: maps[i]['isFavorite'],
      );
    });
  }

  Future<void> updateProject(Project project) async {
    final db = await _databaseHelper.database;
    await db.update(
      'Projects',
      project.toMap(),
      where: 'idProject = ?',
      whereArgs: [project.idProject],
    );
  }

  Future<void> deleteProject(int idProject) async {
    final db = await _databaseHelper.database;
    await db.delete(
      'Projects',
      where: 'idProject = ?',
      whereArgs: [idProject],
    );
  }

  // Tasks CRUD operations
  Future<void> createTask(Task task) async {
    final db = await _databaseHelper.database;
    await db.insert('Tasks', task.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Task>> getAllTasks() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Tasks');
    return List.generate(maps.length, (i) {
      return Task(
        idTask: maps[i]['idTask'],
        idProject: maps[i]['idProject'],
        namaTask: maps[i]['namaTask'],
        status: maps[i]['status'],
        kategori: maps[i]['kategori'],
        deskripsi: maps[i]['deskripsi'],
        deadlineTask: maps[i]['deadlineTask'],
      );
    });
  }

  Future<void> updateTask(Task task) async {
    final db = await _databaseHelper.database;
    await db.update(
      'Tasks',
      task.toMap(),
      where: 'idTask = ?',
      whereArgs: [task.idTask],
    );
  }

  Future<void> deleteTask(int idTask) async {
    final db = await _databaseHelper.database;
    await db.delete(
      'Tasks',
      where: 'idTask = ?',
      whereArgs: [idTask],
    );
  }
}
