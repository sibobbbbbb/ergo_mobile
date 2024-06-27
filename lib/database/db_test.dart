import 'database.dart';
import 'db_manager.dart';

Future<void> test() async {
  // Buat instance DatabaseManager
  DatabaseManager dbManager = DatabaseManager();

  // Buat tabel
  await dbManager.createBoard(Board(idBoard: 1, namaBoard: 'Ini board 1', isFavorite: 0));
  await dbManager.createBoard(Board(idBoard: 2, namaBoard: 'Ini board 2', isFavorite: 0));
  await dbManager.createBoard(Board(idBoard: 3, namaBoard: 'Ini board 3', isFavorite: 0));

  // Tambah data Board
  Board board1 = Board(idBoard: 1, namaBoard: 'Ini board 1', isFavorite: 0);
  Board board2 = Board(idBoard: 2, namaBoard: 'Ini board 2', isFavorite: 0);
  Board board3 = Board(idBoard: 3, namaBoard: 'Ini board 3', isFavorite: 0);

  await dbManager.createBoard(board1);
  await dbManager.createBoard(board2);
  await dbManager.createBoard(board3);

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
