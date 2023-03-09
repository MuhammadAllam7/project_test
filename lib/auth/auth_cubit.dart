import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/main_page.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AppInitial());

  static AuthCubit get(BuildContext context) => BlocProvider.of(context);

  final formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  void loginButton(BuildContext context) async {
    var navigator = Navigator.of(context);
    if (formKey.currentState!.validate()) {
      try {
        final credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        String? uid = credential.user?.uid;

        if (uid != null) {
          final prefs = await SharedPreferences.getInstance();
          prefs.setBool('loggedIn', true);
          prefs.setString('uid', uid);

          navigator.pushReplacement(
            MaterialPageRoute(builder: (context) => MainPage(uid)),
          );
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          showSnackBar(context, 'Email is not registered');
        } else if (e.code == 'wrong-password') {
          showSnackBar(context, 'Password is not correct');
        } else if (e.code == 'invalid-email') {
          showSnackBar(context, 'Invalid email');
        }
      }
      emit(LoginState());
    }
  }

  void showSnackBar(BuildContext context, msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
}
