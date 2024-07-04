import 'dart:async';
import 'package:ergo_mobile/widgets/task_page.dart';
import 'package:flutter/material.dart';
import '../database/database.dart';
import '../database/db_manager.dart';
import 'app_bar.dart';

class ProjectBoard extends StatefulWidget {
  final Board parentBoard;
  const ProjectBoard({super.key, required this.parentBoard});
  @override
  State<ProjectBoard> createState() => _ProjectBoardState();
}

class _ProjectBoardState extends State<ProjectBoard> {
  final DatabaseManager dbManager = DatabaseManager();
  List<Project> projects = [];
  // Pagination
  int currentPage = 0;
  final int itemsPerPage = 6;

  @override
  void initState() {
    super.initState();
    loadProjects();
  }

  Future<void> loadProjects() async {
    List<Project> loadedProjects = await dbManager.getProjectsByBoard(widget.parentBoard.idBoard);
    setState(() {
      projects = loadedProjects;
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
    Project project = Project(idProject: newIdProject, idBoard: widget.parentBoard.idBoard, namaProject: projectName , tingkatKetuntasan: 0, deadlineProject: deadline!.toIso8601String() , isFavorite: 0);
    await dbManager.createProject(project);
    setState(() {
      loadProjects();
    });
  }

  Widget createProject(Project project) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskBoard(parentProject: project),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.fromLTRB(18, 8, 10, 0),
          width: 150,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project.namaProject,
                style: const TextStyle(
                  color: Colors.black,
                  letterSpacing: 1.5,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: Colors.grey[700],
                    size: 14,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    project.deadlineProject,
                    style: const TextStyle(
                      color: Colors.black,
                      letterSpacing: 1.0,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Text(
                ' ${(project.tingkatKetuntasan * 100).toString()}% Completed',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int start = currentPage * itemsPerPage;
    int end = start + itemsPerPage;
    List<Project> displayProjects = projects.sublist(
      start,
      end > projects.length ? projects.length : end,
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
                  padding: const EdgeInsets.fromLTRB(20, 20, 30, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        ' ${widget.parentBoard.namaBoard} ',
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
                              'Choose a project that you want to continue',
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
                  padding: const EdgeInsets.fromLTRB(20, 20, 30, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        ' Your Projects',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          wordSpacing: 5,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
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
                                    '+ Add New Project',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )),
                        ]),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorWidget,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 27, 8, 8),
                            child: GridView.builder(
                              gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 2 / 1,
                              ),
                              itemCount: displayProjects.length,
                              itemBuilder: (context, index) {
                                return createProject(displayProjects[index]);
                              },
                            ),
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
                            onPressed: end < projects.length
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