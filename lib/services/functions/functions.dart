import 'package:flutter/material.dart';

import '../../pages/others/home.dart';

Widget selectPage(String activePage, String uid) {
  switch (activePage) {
    case 'Home':
      return HomePage(uid);
    case 'Menu':
      return Container();
    case 'History':
      return Container();
    case 'Promos':
      return Container();
    case 'Settings':
      return Container();
    default:
      return HomePage(uid);
  }
}

