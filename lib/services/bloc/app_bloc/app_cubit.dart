import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  static AppCubit get(BuildContext context) => BlocProvider.of(context);

  String _activePage = 'Home';

  String get activePage => _activePage;

  void setActivePage(String page) {
    _activePage = page;
    emit(ActivePageState());
  }
}
