
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class GetUsersSuccessState extends ProfileState {}

class GetUsersFailureState extends ProfileState {
  final String errorMessage;
  GetUsersFailureState(this.errorMessage);
}

class DeleteUsersSuccessState extends ProfileState {}

class DeleteUsersFailureState extends ProfileState {
  final String errorMessage;
  DeleteUsersFailureState(this.errorMessage);
}

class AddUsersSuccessState extends ProfileState {}

class AddUsersFailureState extends ProfileState {
  final String errorMessage;
  AddUsersFailureState(this.errorMessage);
}

class UpdateUsersSuccessState extends ProfileState {}

class UpdateUsersFailureState extends ProfileState {
  final String errorMessage;
  UpdateUsersFailureState(this.errorMessage);
}