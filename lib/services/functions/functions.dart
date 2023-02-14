import 'package:flutter/material.dart';

import '../../pages/others/home.dart';

Widget selectPage(String activePage) {
  switch (activePage) {
    case 'Home':
      return const HomePage();
    case 'Menu':
      return Container();
    case 'History':
      return Container();
    case 'Promos':
      return Container();
    case 'Settings':
      return Container();
    default:
      return const HomePage();
  }
}
