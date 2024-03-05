import 'package:design/ui/profile/manager/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/models.dart';
import '../page/profile_screen.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
 List<User> myData =[];
  String imageUrl="";


  void getUsersFromFirestore() {
    final userId= ConstantVar.auth.currentUser!.uid;
    ConstantVar.firestore.collection("Users")
        .where('userId',isEqualTo:userId)
        .get()
        .then((value) {
      myData.clear();
      for(var document in value.docs) {
        final user=User.fromMap(document.data());
        myData.add(user);
      }
      emit(GetUsersSuccessState());
    }).catchError((error)
    {emit(GetUsersFailureState(error.toString()));});
  }


  void updateCurrentUser( int index, User item){
    myData[index].image=item.image;
    myData[index].name=item.name;
    myData[index].phone=item.phone;
    myData[index].email=item.email;
    myData[index].userId=item.userId;
    emit(UpdateUsersSuccessState());
  }


}
