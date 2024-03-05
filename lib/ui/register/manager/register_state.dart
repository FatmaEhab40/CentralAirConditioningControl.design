
class RegisterState {
  final bool isObscure;
  final String? errorMessage;

  RegisterState({this.isObscure = true, this.errorMessage});
}

class RegisterInitial extends RegisterState {}

class RegisterSuccessState extends RegisterState {}

class RegisterFailureState extends RegisterState {

  final String errorMessage;
  RegisterFailureState(this.errorMessage);

}


