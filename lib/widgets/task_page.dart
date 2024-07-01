import 'dart:async';
import 'package:flutter/material.dart';
import '../database/database.dart';
import '../database/db_manager.dart';
import 'app_bar.dart';

class TaskBoard extends StatefulWidget {
  final Project parentProject;

  const TaskBoard({super.key, required this.parentProject});

  @override
  State<TaskBoard> createState() => _TaskBoardState();
}

class _TaskBoardState extends State<TaskBoard> {
  final DatabaseManager dbManager = DatabaseManager();
  List<Task> tasks = [];

  // Pagination
  int currentPage = 0;
  final int itemsPerPage = 6;

  @override
  void initState() {
    super.initState();
    loadBoards();
  }

  Future<void> loadBoards() async {
    List<Task> loadedProjects =
        await dbManager.getTasksByProject(widget.parentProject.idBoard);
    setState(() {
      tasks = loadedProjects;
    });
  }

  Widget createTask(Task task) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(20),
        ),
        width: 150,
        height: 90,
        child: Center(
          child: Text(
            task.namaTask,
            style: const TextStyle(
              color: Colors.black,
              letterSpacing: 2.0,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int start = currentPage * itemsPerPage;
    int end = start + itemsPerPage;
    tasks.sublist(
      start,
      end > tasks.length ? tasks.length : end,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF022B42),
      appBar: const ErgoAppBar(isGoHome: true),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.fromLTRB(20, 20, 30, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        ' ${widget.parentProject.namaProject} ',
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          wordSpacing: 5,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF006494),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome!',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'This is your workspace to track all your task',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        ' Your Tasks',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          wordSpacing: 5,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF006494),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: SingleChildScrollView(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columns: const [
                                  DataColumn(label: Text('Task Name')),
                                  DataColumn(label: Text('Status')),
                                  DataColumn(label: Text('Category')),
                                  DataColumn(label: Text('Due Date / Time')),
                                  DataColumn(label: Text('Description')),
                                ],
                                rows: tasks.map((task) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(task.namaTask)),
                                      DataCell(Text(task.status)),
                                      DataCell(Text(task.kategori)),
                                      DataCell(Text(task.deadlineTask)),
                                      DataCell(Text(task.deskripsi)),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
