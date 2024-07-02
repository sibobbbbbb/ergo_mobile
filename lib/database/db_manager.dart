import 'package:sqflite/sqflite.dart';
import 'database.dart';
import 'db_helper.dart';

class DatabaseManager {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Tambahkan fungsi untuk menghapus semua board
  Future<void> deleteAllData() async {
    final db = await _databaseHelper.database;
    await db.delete('Boards');
    await db.delete('Projects');
    await db.delete('Tasks');
  }
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

  // Fungsi untuk mendapatkan Board berdasarkan idBoard
  Future<Board> getBoardById(int idBoard) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Boards',
      where: 'idBoard = ?',
      whereArgs: [idBoard],
    );
    if (maps.isNotEmpty) {
      return Board(
        idBoard: maps[0]['idBoard'],
        namaBoard: maps[0]['namaBoard'],
        isFavorite: maps[0]['isFavorite'],
      );
    } else {
      throw Exception('Board with id $idBoard not found');
    }
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

  Future<int> getLastBoardId() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT idBoard FROM Boards ORDER BY idBoard DESC LIMIT 1');

    if (result.isNotEmpty) {
      return result.first['idBoard'];
    } else {
      return 0; // Return 0 if there are no boards
    }
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

  // Projects by idBoard
  Future<List<Project>> getProjectsByBoard(int idBoard) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Projects',
      where: 'idBoard = ?',
      whereArgs: [idBoard],
    );
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

  Future<int> getLastProjectId() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT idProject FROM Projects ORDER BY idProject DESC LIMIT 1');

    if (result.isNotEmpty) {
      return result.first['idProject'];
    } else {
      return 0; // Return 0 if there are no projects
    }
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

  // Tasks by idProject
  Future<List<Task>> getTasksByProject(int idProject) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Tasks',
      where: 'idProject = ?',
      whereArgs: [idProject],
    );
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

  Future<int> getLastTaskId() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT idTask FROM Tasks ORDER BY idTask DESC LIMIT 1');

    if (result.isNotEmpty) {
      return result.first['idTask'];
    } else {
      return 0; // Return 0 if there are no tasks
    }
  }

}
