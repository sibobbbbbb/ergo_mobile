import 'dart:async';

import 'package:ergo_mobile/widgets/projects_board.dart';
import 'package:flutter/material.dart';
import '../database/database.dart';
import '../database/db_manager.dart';
import 'app_bar.dart';

class HomeBoard extends StatefulWidget {
  const HomeBoard({super.key});

  @override
  State<HomeBoard> createState() => _HomeBoardState();
}

class _HomeBoardState extends State<HomeBoard> {
  bool isFavorite = false;
  final DatabaseManager dbManager = DatabaseManager();
  List<Board> boards = [];

  // Pagination
  int currentPage = 0;
  final int itemsPerPage = 6;

  @override
  void initState() {
    super.initState();
    loadBoards();
  }

  Future<void> loadBoards() async {
    List<Board> loadedBoards = (!isFavorite)? await dbManager.getAllBoards(): await dbManager.getAllFavBoards();
    setState(() {
      boards = loadedBoards;
    });
  }

  final TextEditingController _boardNameController = TextEditingController();

  void _showAddBoardDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // backgroundColor: colorWidget,
          title: const Text('Board Title:'),
          content: TextField(
            controller: _boardNameController,
            decoration: const InputDecoration(
              hintText: 'Enter board title',
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
              child: const Text('Create Project'),
              onPressed: () {
                // Handle the create board logic here
                String boardName = _boardNameController.text;
                addBoard(boardName);
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> addBoard(String boardName) async {
    int newIdBoard = await dbManager.getLastBoardId() + 1;
    Board board = Board(idBoard: newIdBoard, namaBoard: boardName, isFavorite: 0);
    await dbManager.createBoard(board);
    setState(() {
      loadBoards();
    });
  }

  Widget createBoard(Board board) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProjectBoard(parentBoard: board),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(20),
          ),
          width: 150,
          height: 90,
          child: Center(
            child: Text(
              board.namaBoard,
              style: const TextStyle(
                color: Colors.black,
                letterSpacing: 2.0,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String textFav = (!isFavorite)? 'All Boards' : 'Fav Boards';
    int start = currentPage * itemsPerPage;
    int end = start + itemsPerPage;
    List<Board> displayBoards = boards.sublist(
      start,
      end > boards.length ? boards.length : end,
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF022B42),
      appBar: const ErgoAppBar(isGoHome: false),
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
                      const Text(
                        ' Hi User',
                        style: TextStyle(
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
                              'Choose a board to begin your journey',
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
                        ' Your Boards',
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
                              width: 158,
                              child: ElevatedButton(
                                onPressed: () {
                                  _showAddBoardDialog();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorWidget,
                                ),
                                child: const Center(
                                  child: Text(
                                    '+ Add New Board',
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
                            padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 2 / 1,
                              ),
                              itemCount: displayBoards.length,
                              itemBuilder: (context, index) {
                                return createBoard(displayBoards[index]);
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
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                  textFav,
                                  style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              Switch(
                                  value: isFavorite,
                                  onChanged: (value) {
                                    setState(() {
                                      isFavorite = value;
                                      currentPage = 0;
                                      loadBoards();
                                    });
                                  },
                                  activeTrackColor: colorWidget,
                                  activeColor: const Color(0xFF022B42),
                              ),

                            ],
                          ),
                          ElevatedButton(
                            onPressed: end < boards.length
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
                                fontSize: 17,
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
