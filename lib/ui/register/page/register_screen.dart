import 'package:design/ui/login/page/login_screen.dart';
import 'package:design/ui/register/manager/register_cubit.dart';
import 'package:design/ui/register/manager/register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../models/models.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final cubit = RegisterCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          onStatChange(state);
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: ConstantVar.backgroundPage,
            appBar: AppBar(backgroundColor: ConstantVar.backgroundPage,
                elevation: 0),
            body: Form(
              key: ConstantVar.formKey,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(10.sp),
                  height: 200.sp,
                  child:
                   Center(
                     child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: GradientText(
                            'Register',
                            style: GoogleFonts.eagleLake(fontSize: 30.sp),
                            gradientType: GradientType.linear,
                            colors: ConstantVar.gradientList,
                          ),
                        ),
                        SizedBox(height: 10.sp),
                        TextFormField(
                            controller: ConstantVar.nameController,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: const Color(0xFF3E2723), width: 5.sp)),
                              labelStyle: const TextStyle(
                                  color: Colors.brown, fontWeight: FontWeight.bold),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: const Color(0xFF3E2723), width: 5.sp),
                              ),
                              prefixIcon:
                                  const Icon(Icons.person, color: Colors.brown),
                            ),
                            cursorColor: const Color(0xFF3E2723),
                            validator: (value) {
                              if (value!.isEmpty) {
                                Toast(message: "Name is required !");
                              }
                              return null;
                            }),
                        SizedBox(height: 15.sp),
                        TextFormField(
                            controller: ConstantVar.phoneController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'Phone',
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: const Color(0xFF3E2723), width: 5.sp)),
                              labelStyle: const TextStyle(
                                  color: Colors.brown, fontWeight: FontWeight.bold),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: const Color(0xFF3E2723), width: 5.sp),
                              ),
                              prefixIcon:
                                  const Icon(Icons.phone, color: Colors.brown),
                            ),
                            cursorColor: const Color(0xFF3E2723),
                            maxLength: 11,
                            validator: (value) {
                              if (value!.isEmpty) {
                                Toast(message: "Phone is required !");
                              }
                              return null;
                            }),
                        SizedBox(height: 15.sp),
                        TextFormField(
                            controller: ConstantVar.emailController,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: const Color(0xFF3E2723), width: 5.sp)),
                              labelStyle: const TextStyle(
                                  color: Colors.brown, fontWeight: FontWeight.bold),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: const Color(0xFF3E2723), width: 5.sp),
                              ),
                              prefixIcon:
                                  const Icon(Icons.email, color: Colors.brown),
                            ),
                            cursorColor: const Color(0xFF3E2723),
                            validator: (value) {
                              if (value!.isEmpty) {
                                Toast(message: "Email is required !");
                                return "Email is required !";

                              }
                              if (!value.contains("@")||
                                  !value.contains("gmail")||
                                  !value.contains(".")||
                                  !value.contains("com")) {
                                Toast(message: "Email is wrong !");
                                return "Email is wrong !";
                              }
                              return null;
                            }),
                        SizedBox(height: 15.sp),
                       TextFormField(
                                controller: ConstantVar.passwordController1,
                                textInputAction: TextInputAction.done,
                                obscureText: state.isObscure,
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
                                        state.isObscure
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                    onPressed: () {
                                      context.read<RegisterCubit>().toggleObscureText();
                                    },
                                  ),
                                ),
                                cursorColor: const Color(0xFF3E2723),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    Toast(message: "Password is required !");
                                  }
                                  return null;
                                }
                                ),
                        SizedBox(height: 10.sp),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: ()  {
                               register();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.0.sp, vertical: 5.0.sp),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0.sp)),
                            ),
                            child: Text(
                              "Register",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15.sp),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void register()  {
    String email = ConstantVar.emailController.text;
    String password = ConstantVar.passwordController1.text;
    String phone = ConstantVar.phoneController.text;
    String name = ConstantVar.nameController.text;
       cubit.createAccount(
           email:email,
           password:password,
           phone:phone,
           name:name);

  }

  void onRegisterSuccess() {
    Toast(message: "Account Created.");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  void onStatChange(state) {
    if (state is RegisterSuccessState) {
      onRegisterSuccess();
    } else if (state is RegisterFailureState) {
      Toast(message: state.errorMessage);
    }
  }
  
}
