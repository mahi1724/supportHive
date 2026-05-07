// import 'package:flutter/material.dart';
// import 'package:supporthive1/controller/home_controller.dart';

// class CustomBottomNavigationBar extends StatelessWidget {
//   final HomeController controller;
//   const CustomBottomNavigationBar({
//     super.key,
//     required this.controller,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: AnimatedBuilder(
//         animation: controller,
//         builder: (context, child) {
//           return BottomNavigationBar(
//             currentIndex: controller.selectedTabIndex,
//             onTap: controller.setTabIndex,
//             type: BottomNavigationBarType.fixed,
//             selectedItemColor: const Color(0xFF4A6741),
//             unselectedItemColor: Colors.grey,
//             backgroundColor: Colors.white,
//             elevation: 0,
//             items: const [
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.home_outlined),
//                 activeIcon: Icon(Icons.home),
//                 label: 'Home',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.search_outlined),
//                 activeIcon: Icon(Icons.search),
//                 label: 'Search',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.favorite_outline),
//                 activeIcon: Icon(Icons.favorite),
//                 label: 'Counselling',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.help_outline),
//                 activeIcon: Icon(Icons.help),
//                 label: 'Quiz',
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

///////////////////////////////////////
library;


import 'package:flutter/material.dart';
import 'package:supporthive1/controller/home_controller.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final HomeController controller;

  const CustomBottomNavigationBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return BottomNavigationBar(
          currentIndex: controller.selectedTabIndex,
          onTap: controller.setTabIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF4A6741),
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              activeIcon: Icon(Icons.favorite),
              label: 'Counselling',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.gamepad_rounded),
              activeIcon: Icon(Icons.gamepad_rounded),
              label: 'games',
            ),
          ],
        );
      },
    );
  }
}
