import 'package:ergo_mobile/widgets/home_board.dart';
import 'package:flutter/material.dart';

class ErgoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isGoHome;

  const ErgoAppBar({super.key, required this.isGoHome});

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
      leading: GestureDetector(
        onTap: () {
          if (isGoHome) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomeBoard()
                )
            );
          }
        },
        child: Image.asset('assets/logoergo.png'),
      ),
      centerTitle: true,
      backgroundColor: const Color(0xFF006494),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: GestureDetector(
            onTap: () {},
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
