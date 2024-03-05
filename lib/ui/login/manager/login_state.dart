 class LoginState {
   final bool isObscure;
   final String? errorMessage;

   LoginState({this.isObscure = true, this.errorMessage});
 }

class LoginInitial extends LoginState {}

class LoginSuccessState extends LoginState {}

class LoginFailureState extends LoginState {
  @override
  final String errorMessage;
  LoginFailureState(this.errorMessage);
}