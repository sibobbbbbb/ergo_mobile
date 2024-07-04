import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
        await dbManager.getTasksByProject(widget.parentProject.idProject);
    setState(() {
      tasks = loadedTasks;
    });
  }

  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void showAddTaskDialog() {
    DateTime? selectedDeadline;
    TimeOfDay? selectedTime;
    String? selectedKategori;
    bool nameError = false;
    bool deadlineError = false;
    bool timeError = false;
    bool kategoriError = false;

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

    Future<void> selectTime(BuildContext context) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (picked != null && picked != selectedTime) {
        setState(() {
          selectedTime = picked;
        });
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Task Title:'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _projectNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter task title',
                        errorText: nameError ? 'Task title is required' : null,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            selectedDeadline == null
                                ? 'No deadline chosen!'
                                : 'Deadline: ${DateFormat('yyyy-MM-dd').format(selectedDeadline!)}',
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
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            selectedTime == null
                                ? 'No time chosen!'
                                : 'Time: ${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              color: timeError ? Colors.red : Colors.black,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => selectTime(context).then((_) => setState(() {})),
                          child: const Text('Select Time'),
                        ),
                      ],
                    ),
                    if (timeError)
                      const Text(
                        'Time is required',
                        style: TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: selectedKategori,
                      decoration: InputDecoration(
                        hintText: 'Select Category',
                        errorText: kategoriError ? 'Category is required' : null,
                      ),
                      items: ['Low', 'Medium', 'High'].map((String kategori) {
                        return DropdownMenuItem<String>(
                          value: kategori,
                          child: Text(kategori),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedKategori = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        hintText: 'Enter description',
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: const Text('Create Task'),
                  onPressed: () {
                    setState(() {
                      nameError = _projectNameController.text.isEmpty;
                      deadlineError = selectedDeadline == null;
                      timeError = selectedTime == null;
                      kategoriError = selectedKategori == null;
                    });

                    if (!nameError && !deadlineError && !timeError && !kategoriError) {
                      String taskTitle = _projectNameController.text;
                      String kategori = selectedKategori!;
                      String description = _descriptionController.text.isNotEmpty
                          ? _descriptionController.text
                          : '';
                      DateTime deadline = DateTime(
                        selectedDeadline!.year,
                        selectedDeadline!.month,
                        selectedDeadline!.day,
                      );
                      String time = '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}';

                      addTask(taskTitle, deadline, time, kategori, description);
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


  Future<void> addTask(String projectName, DateTime deadline, String time, String kategori , String deskripsi) async {
    int newIdTask = await dbManager.getLastTaskId() + 1;
    Task task = Task(
        idTask: newIdTask,
        idProject: widget.parentProject.idProject,
        namaTask: projectName,
        status: 'Not Yet Started',
        kategori: kategori,
        deskripsi: deskripsi,
        deadlineTask: '${deadline.year}-${deadline.month}-${deadline.day} $time',
    );
    await dbManager.createTask(task);
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
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: Colors.grey[700],
                    size: 14,
                  ),
                  Text(
                    ' ${task.deadlineTask}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
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
      resizeToAvoidBottomInset: false,
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
                                  percent:
                                      widget.parentProject.tingkatKetuntasan,
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
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                                  showAddTaskDialog();
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
                                fontSize: 17,
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
                                fontSize:17,
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
