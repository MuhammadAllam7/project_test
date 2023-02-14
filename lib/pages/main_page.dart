import 'package:flutter/material.dart';

import '../services/functions/functions.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String activePage = 'Home';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Row(
          children: [
            Container(
              width: 70,
              padding: const EdgeInsets.only(top: 24, right: 12, left: 12),
              height: MediaQuery.of(context).size.height,
              child: leftSideMenu(),
            ),
            Expanded(
              child: Container(
                // margin: const EdgeInsets.only(top: 24, right: 12),
                padding: const EdgeInsets.only(top: 2, right: 2, left: 2),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12)),
                ),
                child: selectPage(activePage),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget leftSideMenu() {
    return Column(children: [
      logo(),
      const SizedBox(height: 20),
      Expanded(
        child: ListView(
          children: [
            menuItem(
              menu: 'Home',
              icon: Icons.rocket_sharp,
            ),
            menuItem(
              menu: 'Menu',
              icon: Icons.format_list_bulleted_rounded,
            ),
            menuItem(
              menu: 'History',
              icon: Icons.history_toggle_off_rounded,
            ),
            menuItem(
              menu: 'Promos',
              icon: Icons.discount_outlined,
            ),
            menuItem(
              menu: 'Settings',
              icon: Icons.sports_soccer_outlined,
            ),
          ],
        ),
      ),
    ]);
  }

  Widget menuItem({
    required String menu,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: GestureDetector(
        onTap: () => setState(() => activePage = menu),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: AnimatedContainer(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: activePage == menu
                  ? Colors.deepOrangeAccent
                  : Colors.transparent,
            ),
            duration: const Duration(milliseconds: 300),
            curve: Curves.slowMiddle,
            child: Column(
              children: [
                Icon(icon),
                const SizedBox(height: 5),
                Text(
                  menu,
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget logo() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.deepOrangeAccent,
          ),
          child: const Icon(
            Icons.fastfood,
            size: 14,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Cairo Cash',
          style: TextStyle(
            color: Colors.white,
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
