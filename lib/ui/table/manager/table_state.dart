import '../page/table_screen.dart';

abstract class TableState {}

class TableInitial extends TableState {
  TableInitial() : super();
}

class GetPeriodsSuccessState extends TableState {
  GetPeriodsSuccessState();
}

class GetPeriodsFailureState extends TableState {
  final String errorMessage;
  GetPeriodsFailureState(this.errorMessage);
}

class DeletePeriodsSuccessState extends TableState {
  DeletePeriodsSuccessState();
}

class DeletePeriodsFailureState extends TableState {
  final String errorMessage;
  DeletePeriodsFailureState(this.errorMessage);
}

class AddPeriodsSuccessState extends TableState {
  AddPeriodsSuccessState();
}

class AddPeriodsFailureState extends TableState {
  final String errorMessage;
  AddPeriodsFailureState(this.errorMessage);
}

class UpdatePeriodsSuccessState extends TableState {
  UpdatePeriodsSuccessState();
}

class UpdatePeriodsFailureState extends TableState {
  final String errorMessage;
  UpdatePeriodsFailureState(this.errorMessage);
}

class GetRoomsSuccessState extends TableState {
  GetRoomsSuccessState();
}

class GetRoomsFailureState extends TableState {
  final String errorMessage;
  GetRoomsFailureState(this.errorMessage);
}

class DeleteRoomsSuccessState extends TableState {
  DeleteRoomsSuccessState();
}

class DeleteRoomsFailureState extends TableState {
  final String errorMessage;
  DeleteRoomsFailureState(this.errorMessage);
}

class AddRoomsSuccessState extends TableState {
  AddRoomsSuccessState();
}

class AddRoomsFailureState extends TableState {
  final String errorMessage;
  AddRoomsFailureState(this.errorMessage);
}

class UpdateRoomsSuccessState extends TableState {
  UpdateRoomsSuccessState();
}

class UpdateRoomsFailureState extends TableState {
  final String errorMessage;
  UpdateRoomsFailureState(this.errorMessage);
}

class TableUpdated extends TableState {
  TableUpdated({required List<Rooms> newRooms});
}
