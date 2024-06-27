import 'database.dart';
import 'db_manager.dart';

Future<void> test() async {
  // Buat instance DatabaseManager
  DatabaseManager dbManager = DatabaseManager();
  // await dbManager.deleteAllData();

  // Tambah data Board
  Board board1 = Board(idBoard: 1, namaBoard: 'Ini board 1', isFavorite: 0);
  Board board2 = Board(idBoard: 2, namaBoard: 'Ini board 2', isFavorite: 0);
  Board board3 = Board(idBoard: 3, namaBoard: 'Ini board 3', isFavorite: 0);
  Board board4 = Board(idBoard: 4, namaBoard: 'Ini board 4', isFavorite: 0);
  Board board5 = Board(idBoard: 5, namaBoard: 'Ini board 5', isFavorite: 0);
  Board board6 = Board(idBoard: 6, namaBoard: 'Ini board 6', isFavorite: 0);
  Board board7 = Board(idBoard: 7, namaBoard: 'Ini board 7', isFavorite: 0);
  Board board8 = Board(idBoard: 8, namaBoard: 'Ini board 8', isFavorite: 0);
  Board board9 = Board(idBoard: 9, namaBoard: 'Ini board 9', isFavorite: 0);
  Board board10 = Board(idBoard: 10, namaBoard: 'Ini board 10', isFavorite: 0);
  Board board11 = Board(idBoard: 11, namaBoard: 'Ini board 11', isFavorite: 0);

  await dbManager.createBoard(board1);
  await dbManager.createBoard(board2);
  await dbManager.createBoard(board3);
  await dbManager.createBoard(board4);
  await dbManager.createBoard(board5);
  await dbManager.createBoard(board6);
  await dbManager.createBoard(board7);
  await dbManager.createBoard(board8);
  await dbManager.createBoard(board9);
  await dbManager.createBoard(board10);
  await dbManager.createBoard(board11);
  List<Board> boards = await dbManager.getAllBoards();
  for (var project in boards) {
    print('Board ID: ${project.idBoard}, Board Name: ${project.namaBoard}');
  }

  // Tambah data Project
  Project project1 = Project(idProject: 1, idBoard: 1, namaProject: 'Ini project 1', tingkatKetuntasan: 0, deadlineProject: '2022-12-31', isFavorite: 0);
  Project project2 = Project(idProject: 2, idBoard: 1, namaProject: 'Ini project 2', tingkatKetuntasan: 0, deadlineProject: '2021-12-31', isFavorite: 0);
  Project project3 = Project(idProject: 3, idBoard: 1, namaProject: 'Ini project 3', tingkatKetuntasan: 0, deadlineProject: '2020-12-31', isFavorite: 0);

  await dbManager.createProject(project1);
  await dbManager.createProject(project2);
  await dbManager.createProject(project3);

  // Ambil semua Project berdasarkan Board ID
  List<Project> projects = await dbManager.getAllProjects();
  for (var project in projects) {
    print('Project ID: ${project.idProject}, Board ID: ${project.idBoard}, Project Name: ${project.namaProject}');
  }

  // Tambah data Task
  Task task1 = Task(idTask: 1, idProject: 1, namaTask: 'Ini task 1', status: "Not Yet Started", kategori: 'Kategori 1', deskripsi: 'Deskripsi task 1', deadlineTask: '2022-12-31 00:00');
  Task task2 = Task(idTask: 2, idProject: 1, namaTask: 'Ini task 2', status: "Not Yet Started", kategori: 'Kategori 2', deskripsi: 'Deskripsi task 2', deadlineTask: '2022-12-31 23:59');
  Task task3 = Task(idTask: 3, idProject: 1, namaTask: 'Ini task 3', status: "Not Yet Started", kategori: 'Kategori 3', deskripsi: 'Deskripsi task 3', deadlineTask: '2022-12-31 23:59');

  await dbManager.createTask(task1);
  await dbManager.createTask(task2);
  await dbManager.createTask(task3);

  // Ambil semua Task berdasarkan Project ID
  List<Task> tasks = await dbManager.getAllTasks();
  for (var task in tasks) {
    print('Task ID: ${task.idTask}, Project ID: ${task.idProject}, Task Name: ${task.namaTask}');
  }
}
