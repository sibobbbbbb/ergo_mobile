import 'package:flutter/material.dart';
import 'database/db_test.dart';
void main() {
  runApp(const MaterialApp(
    home: HomeBoard(),
  ));
  test();
}

class ErgoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ErgoAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Ergo Mobile',
        style: TextStyle(
          color: Colors.black,
          fontSize: 35,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: Image.asset('assets/logoergo.png'),
      centerTitle: true,
      backgroundColor: const Color(0xFF006494),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: GestureDetector(
            onTap: () {
              print("PROFIL");
            },
            child: const CircleAvatar(
              backgroundImage: AssetImage('assets/SiBoB.png'),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class HomeBoard extends StatefulWidget {
  const HomeBoard({super.key});

  @override
  State<HomeBoard> createState() => _HomeBoardState();
}

class _HomeBoardState extends State<HomeBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF022B42),
      appBar: const ErgoAppBar(),
      body: Container(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.topLeft,
                    // Aligns the child to the top-left corner
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 30, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Aligns text to the left
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
                              color: const Color(0xFF006494),
                              borderRadius: BorderRadius.circular(20), // Sudut melengkung
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
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [const Text(
                        ' Your Boards',
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
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        margin: const EdgeInsets.only(top: 20),
                                        color: Colors.amber,
                                        width: 150,
                                        height: 150,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        margin: const EdgeInsets.only(top: 20),
                                        color: Colors.amber,
                                        width: 150,
                                        height: 150,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 70),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Floating");
        },
        backgroundColor: const Color(0xFF006494),
        child: const Icon(Icons.add),
      ),
    );
  }
}
