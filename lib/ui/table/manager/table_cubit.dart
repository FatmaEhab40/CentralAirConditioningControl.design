import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:design/models/models.dart';
import 'package:design/ui/table/manager/table_state.dart';
import 'package:design/ui/table/page/table_screen.dart';

class TableCubit extends Cubit<TableState> {
  TableCubit() : super(TableInitial());

  List<Periods> periods = [];
  List<Rooms> rooms = [];

  void getPeriods() {
    final userId= ConstantVar.auth.currentUser!.uid;
    ConstantVar.firestore.collection("periods")
        .where('userId',isEqualTo:userId)
        .get()
        .then((value) {
      periods.clear();
      for(var document in value.docs) {
        final period=Periods.fromMap(document.data());
        periods.add(period);
      }
      emit(GetPeriodsSuccessState());
    }).catchError((error)
    {emit(GetPeriodsFailureState(error.toString()));});
  }

  void deletePeriod(String idPeriod)async{
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await ConstantVar.firestore.collection("periods")
          .where('id', isEqualTo: idPeriod).get();
      if (querySnapshot.docs.isNotEmpty) {
        final String documentId = querySnapshot.docs.first.id;
        await ConstantVar.firestore.collection("periods")
            .doc(documentId)
            .delete();
          periods.removeWhere((element) => element.id== idPeriod);
            emit(DeletePeriodsSuccessState());
      }else {
        emit(DeletePeriodsFailureState('No period found with this id'));
      }
    }catch (e) {
      emit(DeletePeriodsFailureState(e.toString()));
    }
  }

  void addPeriod({required Periods item}){
    periods.add(item);
    emit(AddPeriodsSuccessState());
  }

  void updatePeriod(String idPeriod, String updateValue) async {
    String period = updateValue;
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await ConstantVar.firestore.collection("periods")
          .where('id', isEqualTo: idPeriod).get();

      if (querySnapshot.docs.isNotEmpty) {
        final String documentId = querySnapshot.docs.first.id;
        await ConstantVar.firestore.collection("periods")
            .doc(documentId).update({
          'duration': period,
        }).then((value) {
          emit(UpdatePeriodsSuccessState());
        });
      } else {
        emit(UpdatePeriodsFailureState('No period found with this id'));
      }
    } catch (e) {
      emit(UpdatePeriodsFailureState(e.toString()));
    }
  }

  void getRooms() {
    final userId= ConstantVar.auth.currentUser!.uid;
    ConstantVar.firestore.collection("rooms")
        .where('userId',isEqualTo:userId)
        .get()
        .then((value) {
      rooms.clear();
      for(var document in value.docs) {
        final room=Rooms.fromMap(document.data());
        rooms.add(room);
      }
      emit(GetRoomsSuccessState());
    }).catchError((error)
    {emit(GetRoomsFailureState(error.toString()));});
  }

  void deleteRoom(String idRoom)async{
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await ConstantVar.firestore.collection("rooms")
          .where('id', isEqualTo: idRoom).get();
      if (querySnapshot.docs.isNotEmpty) {
        final String documentId = querySnapshot.docs.first.id;
        await ConstantVar.firestore.collection("rooms")
            .doc(documentId)
            .delete();
        rooms.removeWhere((element) => element.id== idRoom);
             emit(DeleteRoomsSuccessState());
      }else {
        emit(DeleteRoomsFailureState('No room found with this id'));
      }
    }catch (e) {
      emit(DeleteRoomsFailureState(e.toString()));
    }
  }

  void addRoom({required Rooms item}){
    rooms.add(item);
    emit(AddRoomsSuccessState());
  }

  void updateRoom(String idPeriod, String updateValue) async {
    String room = updateValue;
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await ConstantVar.firestore.collection("rooms")
          .where('id', isEqualTo: idPeriod).get();

      if (querySnapshot.docs.isNotEmpty) {
        final String documentId = querySnapshot.docs.first.id;
        await ConstantVar.firestore.collection("rooms")
            .doc(documentId).update({
          'name': room,
        }).then((value) {
          emit(UpdateRoomsSuccessState());
        });
      } else {
        emit(UpdateRoomsFailureState('No room found with this id'));
      }
    } catch (e) {
      emit(UpdateRoomsFailureState(e.toString()));
    }
  }

  void updateSelectedRooms(List<Rooms> newRooms) {
    emit(TableUpdated(newRooms: newRooms));
  }

}
