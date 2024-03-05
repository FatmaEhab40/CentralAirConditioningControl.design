import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class ConstantVar{
  static  bool isObscure = true;
  static final nameController = TextEditingController();
  static final phoneController = TextEditingController();
  static final emailController = TextEditingController();
  static final passwordController1 = TextEditingController();
  static final passwordController2 = TextEditingController();
  static  final periodController = TextEditingController();
  static final roomController = TextEditingController();
  static final formKey = GlobalKey<FormState>();

  static final  List<Color> gradientList=[
    const Color(0xFF795548),
    const Color(0xFF8D6E63),
    const Color(0xFFA1887F),
    const Color(0xFFF9A825),
    const Color(0xFFF57F17)
  ];
  static const Color backgroundPage = Color(0xFFD7CCC8);
  static const Color backgroundContainer = Color(0xFF8D6E63);

  static final firestore=FirebaseFirestore.instance;
  static final auth=FirebaseAuth.instance;
  static final storage = FirebaseStorage.instance;
}

class Toast {
  String message;
  Color backgroundColor;
  Color textColor;
  double fontSize;

  Toast({this.backgroundColor=Colors.brown,
        this.textColor=Colors.white,
        this.fontSize=16.0,
      required this.message}) ;

   void toast(message,backgroundColor,textColor,fontSize) {
    Fluttertoast.showToast(
        msg: message,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: fontSize
    );
  }
}



