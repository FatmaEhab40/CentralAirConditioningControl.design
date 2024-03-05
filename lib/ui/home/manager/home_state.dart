
abstract class HomeState {}

class HomeInitial extends HomeState {}

class GetRoomsSuccessState extends HomeState {}

class GetRoomsFailureState extends HomeState {
  final String errorMessage;
  GetRoomsFailureState(this.errorMessage);
}

class DeleteRoomsSuccessState extends HomeState {}

class DeleteRoomsFailureState extends HomeState {
  final String errorMessage;
  DeleteRoomsFailureState(this.errorMessage);
}

class AddRoomsSuccessState extends HomeState {}

class AddRoomsFailureState extends HomeState {
  final String errorMessage;
  AddRoomsFailureState(this.errorMessage);
}

class UpdateRoomsSuccessState extends HomeState {}

class UpdateRoomsFailureState extends HomeState {
  final String errorMessage;
  UpdateRoomsFailureState(this.errorMessage);
}
