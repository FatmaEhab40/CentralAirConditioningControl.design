import 'package:bloc/bloc.dart';
import 'package:design/models/models.dart';
import 'package:design/ui/login/manager/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  void login({required String email, required String password}) {
    String email = ConstantVar.emailController.text;
    String password = ConstantVar.passwordController1.text;

    ConstantVar.auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      emit(LoginSuccessState());
    }).catchError((error) {
      if (error is FirebaseAuthException) {
        if (error.code == 'user-not-found') {
          emit(LoginFailureState('No user found for that email.'));
        } else if (error.code == 'wrong-password') {
          emit(LoginFailureState('Wrong password provided for that user.'));
        }
      }
      emit(LoginFailureState(error.toString()));
    });
  }

  void toggleObscureText() {
    emit(LoginState(isObscure: !state.isObscure));
  }
}
