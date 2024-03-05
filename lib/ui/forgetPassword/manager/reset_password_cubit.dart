import 'package:bloc/bloc.dart';
import 'package:design/models/models.dart';
import 'package:design/ui/forgetPassword/manager/reset_password_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(ResetPasswordInitial());

  void resetPassword() async {
    try {
      await ConstantVar.auth
          .sendPasswordResetEmail(
          email: ConstantVar.emailController.text.trim());
      emit(ResetPasswordSuccessState());
    }

    on FirebaseAuthException catch (e) {
      emit(ResetPasswordFailureState(e.toString()));
    }
  }


  void toggleObscureText() {
    emit(ResetPasswordState(isObscure1: !state.isObscure1,isObscure2: !state.isObscure2));
  }
}
