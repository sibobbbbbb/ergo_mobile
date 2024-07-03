import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
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
    loadTasks();
  }

  Future<void> loadTasks() async {
    List<Task> loadedTasks =
        await dbManager.getTasksByProject(widget.parentProject.idBoard);
    setState(() {
      tasks = loadedTasks;
    });
  }

  final TextEditingController _projectNameController = TextEditingController();

  void _showAddProjectDialog() {
    DateTime? selectedDeadline;
    bool nameError = false;
    bool deadlineError = false;

    Future<void> selectDeadline(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != selectedDeadline) {
        setState(() {
          selectedDeadline = picked;
        });
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Project Title:'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _projectNameController,
                    decoration: InputDecoration(
                      hintText: 'Enter project title',
                      errorText: nameError ? 'Project name is required' : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedDeadline == null
                              ? 'No deadline chosen!'
                              : 'Deadline: ${selectedDeadline!.toLocal()}'.split(' ')[0],
                          style: TextStyle(
                            color: deadlineError ? Colors.red : Colors.black,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => selectDeadline(context).then((_) => setState(() {})),
                        child: const Text('Select Deadline'),
                      ),
                    ],
                  ),
                  if (deadlineError)
                    const Text(
                      'Deadline is required',
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: const Text('Create Project'),
                  onPressed: () {
                    setState(() {
                      nameError = _projectNameController.text.isEmpty;
                      deadlineError = selectedDeadline == null;
                    });

                    if (!nameError && !deadlineError) {
                      String projectName = _projectNameController.text;
                      DateTime? deadline = selectedDeadline;
                      addProject(projectName, deadline); // Pass the deadline to addProject
                      Navigator.of(context).pop(); // Close the dialog
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }


  Future<void> addProject(String projectName, DateTime? deadline) async {
    int newIdProject = await dbManager.getLastProjectId() + 1;
    Project project = Project(idProject: newIdProject, idBoard: widget.parentProject.idBoard, namaProject: projectName , tingkatKetuntasan: 0, deadlineProject: deadline!.toIso8601String() , isFavorite: 0);
    await dbManager.createProject(project);
    setState(() {
      loadTasks();
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
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildStatusChip(task.status),
                  Text(
                    task.kategori,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                'Due Date: ${task.deadlineTask}',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
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

  Widget buildStatusChip(String status) {
    Color? color;
    switch (status) {
      case 'Completed':
        color = Colors.greenAccent;
        break;
      case 'Not Yet Started':
        color = Colors.redAccent;
        break;
      case 'On Progress':
        color = Colors.blueAccent;
        break;
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
                  padding: const EdgeInsets.fromLTRB(20, 9, 30, 0),
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
                      const SizedBox(height: 3),
                      Container(
                        decoration: BoxDecoration(
                          color: colorWidget,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.fromLTRB(16, 10, 10, 9.37),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'So,',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'This is your workspace to track all your task.',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'And This Is Your Progress Bar',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                LinearPercentIndicator(
                                  lineHeight: 17,
                                  width: 290,
                                  percent: widget.parentProject.tingkatKetuntasan,
                                  backgroundColor: Colors.grey[300],
                                  progressColor: Colors.blue,
                                  // barRadius: const Radius.circular(20),
                                ),
                                // const SizedBox(width: ,),
                                Text(
                                  ' ${(widget.parentProject.tingkatKetuntasan * 100).toString()}%',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
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
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Row(children: [
                          Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              height: 35,
                              width: 166,
                              child: ElevatedButton(
                                onPressed: () {
                                  _showAddProjectDialog();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorWidget,
                                ),
                                child: const Center(
                                  child: Text(
                                    '+ Add New Task',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )),
                        ]),
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
