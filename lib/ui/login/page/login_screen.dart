import 'package:design/models/models.dart';
import 'package:design/ui/home/page/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:design/ui/forgetPassword/page/forgetPassword_screen.dart';
import 'package:design/ui/register/page/register_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../manager/login_cubit.dart';
import '../manager/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final cubit = LoginCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {onStatChange(state);},
        builder: (context, state) {
          return Scaffold(
              body: Stack(
               alignment: Alignment.center,
                 children: [
                Opacity(
                   opacity: 0.9.sign,
                   child: CachedNetworkImage(
                  imageUrl:
                      "https://www.lg.com/eg_en/images/business/indoor-ceiling-concealed-duct/Ceiling-Concealed-Duct-02-Mobile.jpg",
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
               Container(
                margin: EdgeInsets.all(20.sp),
                padding: EdgeInsets.all(10.sp),
                height: 100.sp,
                child: Column(
                  children: [
                    SizedBox(height: 30.sp),
                    GradientText(
                      'Login',
                      style: GoogleFonts.eagleLake(fontSize: 30.sp),
                      gradientType: GradientType.linear,
                      colors: ConstantVar.gradientList,
                    ),
                    SizedBox(height: 10.sp),
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
                          }
                          return null;
                        }),
                    SizedBox(height: 20.sp),
                    TextFormField(
                        controller: ConstantVar.passwordController1,
                        textInputAction: TextInputAction.done,
                        obscureText: state.isObscure,
                        decoration: InputDecoration(
                          labelText: 'Password',
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
                              const Icon(Icons.lock, color: Colors.brown),
                          suffixIcon: IconButton(
                            icon: Icon(
                                color: Colors.brown,
                                state.isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                            onPressed: () {
                                context.read<LoginCubit>().toggleObscureText();
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
                    SizedBox(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgetPasswordScreen(),
                                ));
                          },
                          child: Text(
                            "Forget Password",
                            style: TextStyle(
                                color: Colors.brown,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            login();
                          },
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.0.sp, vertical: 5.0.sp),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(10.0.sp))),
                          child: Text(
                            "Login",
                            style:
                                TextStyle(color: Colors.brown, fontSize: 15.sp),
                          ),
                        )),
                    SizedBox(height: 5.sp),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ));
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
            ],
          ));
        },
      ),
    );
  }

  void login() {
    String email = ConstantVar.emailController.text;
    String password = ConstantVar.passwordController1.text;
    cubit.login(email: email, password: password);
  }

  void onLoginSuccess() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  void onStatChange(state) {
    if (state is LoginSuccessState) {
      onLoginSuccess();
    } else if (state is LoginFailureState) {
      Toast(message: state.errorMessage);
    }
  }


}
