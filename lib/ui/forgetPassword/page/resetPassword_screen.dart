import 'package:design/models/models.dart';
import 'package:design/ui/forgetPassword/manager/reset_password_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../manager/reset_password_state.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final cubit = ResetPasswordCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          onStatChange(state);},
        builder: (context, state) {
          return Scaffold(
              backgroundColor: ConstantVar.backgroundPage,
              appBar: AppBar(backgroundColor: ConstantVar.backgroundPage,elevation: 0),
              body: Center(
                child: Container(
                    margin: EdgeInsets.all(10.sp),
                    padding: EdgeInsets.all(10.sp),
                    height: 100.sp,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20.sp),
                        GradientText(
                          'Reset Password',
                          style: GoogleFonts.eagleLake(fontSize: 25.sp),
                          gradientType: GradientType.linear,
                          colors: ConstantVar.gradientList,
                        ),
                        SizedBox(height: 20.sp),
                        TextFormField(
                            controller: ConstantVar.passwordController1,
                            textInputAction: TextInputAction.next,
                            obscureText: state.isObscure1,
                            decoration: InputDecoration(
                              labelText: 'Password',
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
                              const Icon(Icons.lock, color: Colors.brown),
                              suffixIcon: IconButton(
                                icon: Icon(
                                    color: Colors.brown,
                                    state.isObscure1
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                onPressed: () {
                                  context.read<ResetPasswordCubit>().toggleObscureText();
                                },
                              ),
                            ),
                            cursorColor: const Color(0xFF3E2723),
                            validator: (value) {
                              if (value!.isEmpty) {
                                Toast(message: "Password is required !");
                              }
                              return null;
                            }),
                        SizedBox(height: 20.sp),
                        TextFormField(
                            controller: ConstantVar.passwordController2,
                            textInputAction: TextInputAction.next,
                            obscureText: state.isObscure2,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
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
                              const Icon(Icons.lock, color: Colors.brown),
                              suffixIcon: IconButton(
                                icon: Icon(
                                    color: Colors.brown,
                                    state.isObscure2
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                onPressed: () {
                                  context.read<ResetPasswordCubit>().toggleObscureText();
                                },
                              ),
                            ),
                            cursorColor: const Color(0xFF3E2723),
                            validator: (value) {
                              if (value!.isEmpty) {
                                Toast(
                                    message:
                                    "Confirm Password is required !");
                              }else if(ConstantVar.passwordController2!=ConstantVar.passwordController1){
                                Toast(
                                    message:
                                    "Confirm Password is wrong !");
                              }
                              return null;
                            }),
                        SizedBox(height: 10.sp),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              cubit.resetPassword();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.0.sp, vertical: 5.0.sp),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0.sp)),
                            ),
                            child: Text(
                              "Done",
                              style:
                              TextStyle(color: Colors.white, fontSize: 15.sp),
                            ),
                          ),
                        ),
                      ],
                    )),
              ));
        },
      ),
    );
  }

  void onResetPasswordSuccess() {
    Navigator.pop(context);
  }

  void onStatChange(state) {
    if (state is ResetPasswordSuccessState) {
      onResetPasswordSuccess();
    } else if (state is ResetPasswordFailureState) {
      Toast(message: state.errorMessage);
    }
  }
}