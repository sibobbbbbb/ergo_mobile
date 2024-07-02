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
  final int itemsPerPage = 2;

  @override
  void initState() {
    super.initState();
    loadBoards();
  }

  Future<void> loadBoards() async {
    List<Task> loadedTasks =
        await dbManager.getTasksByProject(widget.parentProject.idBoard);
    setState(() {
      tasks = loadedTasks;
    });
  }

  Widget createTask(Task task) {
    return Card(
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.namaTask,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusChip(task.status),
                  Text(
                    task.kategori,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Due Date: ${task.deadlineTask}',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                task.deskripsi,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'Completed':
        color = Colors.greenAccent;
        break;
      case 'Not Yet Started':
        color = Colors.redAccent;
        break;
      default:
        color = Colors.grey;
    }
    return Chip(
      backgroundColor: color,
      label: Text(
        status,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int start = currentPage * itemsPerPage;
    int end = start + itemsPerPage;
    List<Task> currentTasks = tasks.sublist(
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
                          color: colorWidget,
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
                  padding: const EdgeInsets.fromLTRB(20,0,20,0),
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
                      const SizedBox(height: 6),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorWidget,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(13, 13, 13, 16),
                            itemCount: currentTasks.length,
                            itemBuilder: (context, index) {
                              final task = currentTasks[index];
                              return createTask(task);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: currentPage > 0
                                ? () {
                              setState(() {
                                currentPage--;
                              });
                            }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorWidget,
                            ),
                            child: const Text(
                              'Previous',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: end < tasks.length
                                ? () {
                              setState(() {
                                currentPage++;
                              });
                            }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorWidget,
                            ),
                            child: const Text(
                              'Next',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 9),
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
