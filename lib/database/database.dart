class Board {
  final int idBoard;
  final String namaBoard;
  final int isFavorite;

  Board({required this.idBoard, required this.namaBoard, required this.isFavorite});

  Map<String, dynamic> toMap() {
    return {
      'idBoard': idBoard,
      'namaBoard': namaBoard,
      'isFavorite': isFavorite,
    };
  }
}

class Project {
  final int idProject;
  final int idBoard;
  final String namaProject;
  final int tingkatKetuntasan;
  final String deadlineProject;
  final int isFavorite;

  Project({required this.idProject, required this.idBoard, required this.namaProject, required this.tingkatKetuntasan, required this.deadlineProject, required this.isFavorite});

  Map<String, dynamic> toMap() {
    return {
      'idProject': idProject,
      'idBoard': idBoard,
      'namaProject': namaProject,
      'tingkatKetuntasan': tingkatKetuntasan,
      'deadlineProject': deadlineProject,
      'isFavorite': isFavorite,
    };
  }
}

class Task {
  final int idTask;
  final int idProject;
  final String namaTask;
  final String status;
  final String kategori;
  final String deskripsi;
  final String deadlineTask;

  Task({required this.idTask, required this.idProject, required this.namaTask, required this.status, required this.kategori, required this.deskripsi, required this.deadlineTask});

  Map<String, dynamic> toMap() {
    return {
      'idTask': idTask,
      'idProject': idProject,
      'namaTask': namaTask,
      'status': status,
      'kategori': kategori,
      'deskripsi': deskripsi,
      'deadlineTask': deadlineTask,
    };
  }
}