import 'dart:io';
import 'package:design/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../manager/profile_cubit.dart';
import '../manager/profile_state.dart';

class User {
  String image = "";
  String name = "";
  String phone = "";
  String email = "";
  String id = "";
  String userId = "";

  User(this.image, this.name, this.phone, this.email, this.id) {
    userId = ConstantVar.auth.currentUser!.uid;
  }

  Map<String, dynamic> toMap() {
    return {
      "Image": image,
      "Name": name,
      "Phone": phone,
      "Email": email,
      "id": id,
      "UserId": userId,
    };
  }

  User.fromMap(Map<dynamic, dynamic> data) {
    data['Image'];
    data['Name'];
    data['Phone'];
    data['Email'];
    data['id'];
    data['UserId'];
  }
}

final cubit = ProfileCubit();

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String imageUrl = "";
  bool load = false;

  @override
  void initState() {
    super.initState();
    cubit.getUsersFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: Scaffold(
          backgroundColor: ConstantVar.backgroundPage,
          appBar: AppBar(
            backgroundColor: ConstantVar.backgroundPage,
            title: GradientText(
              'Profile',
              style: GoogleFonts.eagleLake(fontSize: 20.sp),
              gradientType: GradientType.linear,
              colors: ConstantVar.gradientList,
            ),
            centerTitle: true,
          ),
          body: Padding(
              padding: const EdgeInsets.all(30),
              child: BlocBuilder<ProfileCubit, ProfileState>(
                buildWhen: (previous, current) {
                  return current is GetUsersSuccessState ||
                      current is DeleteUsersSuccessState ||
                      current is AddUsersSuccessState ||
                      current is UpdateUsersSuccessState;
                },
                builder: (context, state) {
                  return Column(
                    children: [
                      if (imageUrl.isEmpty)
                        InkWell(
                          onTap: () => pickImage(),
                          child: const CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.brown,
                              child: Icon(
                                Icons.person,
                                size: 45,
                                color: Colors.white,
                              )),
                        )
                      else
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            InkWell(
                              onTap: () => pickImage(),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(imageUrl),
                              ),
                            ),
                            Visibility(
                                visible: load,
                                child: const CircularProgressIndicator())
                          ],
                        ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          TextFormField(
                            controller: ConstantVar.nameController,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: const Color(0xFF3E2723),
                                      width: 5.sp)),
                              labelStyle: const TextStyle(
                                  color: Colors.brown,
                                  fontWeight: FontWeight.bold),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: const Color(0xFF3E2723),
                                    width: 5.sp),
                              ),
                              prefixIcon:
                                  const Icon(Icons.person, color: Colors.brown),
                            ),
                            cursorColor: const Color(0xFF3E2723),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: ConstantVar.phoneController,
                            maxLength: 11,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: 'Phone',
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: const Color(0xFF3E2723),
                                      width: 5.sp)),
                              labelStyle: const TextStyle(
                                  color: Colors.brown,
                                  fontWeight: FontWeight.bold),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: const Color(0xFF3E2723),
                                    width: 5.sp),
                              ),
                              prefixIcon: const Icon(Icons.phone_android,
                                  color: Colors.brown),
                            ),
                            cursorColor: const Color(0xFF3E2723),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            enabled: false,
                            controller: ConstantVar.emailController,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: const Color(0xFF3E2723),
                                      width: 5.sp)),
                              labelStyle: const TextStyle(
                                  color: Colors.brown,
                                  fontWeight: FontWeight.bold),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: const Color(0xFF3E2723),
                                    width: 5.sp),
                              ),
                              prefixIcon:
                                  const Icon(Icons.email, color: Colors.brown),
                            ),
                            cursorColor: const Color(0xFF3E2723),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Email is required !";
                              }
                              if (!value.contains("@") ||
                                  !value.contains("gmail") ||
                                  !value.contains(".") ||
                                  !value.contains("com")) {
                                return "Email is wrong !";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => saveUserData(),
                          style: OutlinedButton.styleFrom(
                              shape: const StadiumBorder(),
                              backgroundColor: Colors.brown),
                          child: const Text("Update",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  );
                },
              ))),
    );
  }

  void saveUserData() {
    final userId = ConstantVar.auth.currentUser!.uid;
    ConstantVar.firestore.collection("Users").doc(userId).update({
      "Name": ConstantVar.nameController.text,
      "Phone": ConstantVar.phoneController.text,
      "Image": imageUrl,
    });
  }

  void getUserData() {
    final userId = ConstantVar.auth.currentUser!.uid;
    ConstantVar.firestore.collection("Users").doc(userId).get();
  }

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    final image = File(file!.path);
    uploadImage(image);
  }

  void saveImage(String imageUrl) {
    final userId = ConstantVar.auth.currentUser!.uid;
    ConstantVar.firestore
        .collection("Users")
        .doc(userId)
        .update({'imageUrl': imageUrl});
  }

  void updateUi(Map<String, dynamic> map) {
    ConstantVar.nameController.text = map["Name"];
    ConstantVar.phoneController.text = map["Phone"];
    ConstantVar.emailController.text = map["Email"];
    setState(() {
      imageUrl = map["Image"];
    });
  }

  void uploadImage(File image) {
    setState(() {
      load = true;
    });
    final userId = ConstantVar.auth.currentUser!.uid;
    ConstantVar.storage
        .ref("profileImage/$userId")
        .putFile(image)
        .then((value) {
      // Toast(message:"uploadImage");
      getImage();
    }).catchError((error) {
      setState(() {
        load = false;
      });
      //Toast(message: error.toString());
    });
  }

  void getImage() {
    final userId = ConstantVar.auth.currentUser!.uid;
    ConstantVar.storage
        .ref("profileImage/$userId")
        .getDownloadURL()
        .then((imageUrl) {
      //Toast(message:imageUrl);
      setState(() {
        this.imageUrl = imageUrl;
        load = false;
      });
      saveImage(imageUrl);
    }).catchError((error) {
      //  Toast(message: error.toString());});
    });
  }

  @override
  void dispose() {
    ConstantVar.emailController.dispose();
    ConstantVar.passwordController1.dispose();
    ConstantVar.nameController.dispose();
    ConstantVar.phoneController.dispose();
    super.dispose();
  }
}
