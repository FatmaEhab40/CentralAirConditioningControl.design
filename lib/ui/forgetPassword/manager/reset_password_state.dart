
 class ResetPasswordState {
  final bool isObscure1;
  final bool isObscure2;
  final String? errorMessage;

  ResetPasswordState({this.isObscure1 = true,this.isObscure2 = true,this.errorMessage});
}

class ResetPasswordInitial extends ResetPasswordState {}

 class ResetPasswordSuccessState extends ResetPasswordState {}

 class ResetPasswordFailureState extends ResetPasswordState {
  final String errorMessage;
   ResetPasswordFailureState(this.errorMessage);
 }
