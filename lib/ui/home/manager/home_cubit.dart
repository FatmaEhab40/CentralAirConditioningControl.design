import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:design/models/models.dart';
import 'package:design/ui/home/manager/home_state.dart';
import '../../table/page/table_screen.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  List<Rooms> rooms = [];


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

}
