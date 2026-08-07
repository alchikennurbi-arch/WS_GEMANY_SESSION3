// import 'package:flutter/material.dart';
// import 'package:session3/pages/create.dart';
// import 'package:session3/pages/feed.dart';
// import 'package:session3/pages/mapp.dart';
// import 'package:session3/pages/profile.dart';

// class Bottomnavbar extends StatefulWidget {
//   const Bottomnavbar({super.key});

//   @override
//   State<Bottomnavbar> createState() => _BottomnavbarState();
// }

// class _BottomnavbarState extends State<Bottomnavbar> {
//   List<Widget> pages = [Feed(), MapPage(), Profile(), Create()];
//   int currentPage = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: pages[currentPage],
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Colors.white,
//         selectedItemColor: Colors.black,
//         unselectedItemColor: Colors.grey,
//         currentIndex: currentPage,
//         onTap: (value) {
//           setState(() {
//             currentPage = value;
//           });
//         },
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.circle), label: "Feed"),

//           BottomNavigationBarItem(icon: Icon(Icons.circle), label: "Map"),

//           BottomNavigationBarItem(
//             icon: Icon(Icons.circle),
//             label: "User Profile",
//           ),

//           BottomNavigationBarItem(
//             icon: Icon(Icons.circle),
//             label: "Create Post",
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:session3/pages/create.dart';
import 'package:session3/pages/feed.dart';
import 'package:session3/pages/mapp.dart';
import 'package:session3/pages/profile.dart';

class Bottomnavbar extends StatefulWidget {
  const Bottomnavbar({super.key});

  @override
  State<Bottomnavbar> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {
  List<Widget> pages = [Feed(), Mapp(), Create(), Profile()];

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[currentPage],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.pink,

        currentIndex: currentPage,
        onTap: (value) {
          setState(() {
            currentPage = value;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.circle), label: "Feed"),
          BottomNavigationBarItem(icon: Icon(Icons.circle), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.circle), label: "Create"),
          BottomNavigationBarItem(icon: Icon(Icons.circle), label: "Profile"),
        ],
      ),
    );
  }
}
