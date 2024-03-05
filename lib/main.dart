import 'package:design/ui/home/page/home_screen.dart';
import 'package:design/ui/login/page/login_screen.dart';
import 'package:design/ui/table/page/add_screen.dart';
import 'package:design/ui/table/page/edit_screen.dart';
import 'package:design/ui/table/page/table_screen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'models/models.dart';
import 'package:app_settings/app_settings.dart';


Future<bool> checkInternetConnection()async {
    bool hasConnection = await InternetConnectionChecker().hasConnection;
      if (hasConnection) {
        await Firebase.initializeApp();
      }
      return hasConnection;
}

Widget showDialog(){
          return AlertDialog(
            backgroundColor: ConstantVar.backgroundPage,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(50))
            ),
            title: GradientText(
                'No Internet Connection',
                style: GoogleFonts.eagleLake(fontSize: 20.sp),
                gradientType: GradientType.linear,
                colors: ConstantVar.gradientList,textAlign: TextAlign.center,
            ),
            content: const Text(
                'Please check your internet connection.',
             textAlign: TextAlign.center),
            actions: [
              Center(
                child: TextButton(
                  onPressed: () {
                    AppSettings.openAppSettings(type: AppSettingsType.wifi);
                  },
                  child: const Text('OK',
                      style: TextStyle(color: Colors.brown)),
                ),
              ),
            ],
          );
        }

Future<void> restartApp() async {
  await SystemChannels.platform.invokeMethod('restartApp');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.instance.getToken()
      .then((value){
    print("FCM Token =>$value");
  });
  FirebaseAppCheck.instance.activate(androidProvider: AndroidProvider.playIntegrity);


  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        theme: ThemeData(
          useMaterial3: false,
        ),
        home: const LoginScreen(),
      //   SafeArea(
      //          child: FutureBuilder<bool>(
      //              future: checkInternetConnection(),
      //              builder: (context, snapshot) {
      //                final connectionStatus = snapshot.data;
      //                if (connectionStatus == InternetConnectionStatus.connected) {
      //                  restartApp();
      //                }
      //                if (snapshot.connectionState == ConnectionState.waiting) {
      //                  return const Center(
      //                      child: CircularProgressIndicator()
      //                  );
      //                }
      //                else if (snapshot.hasError) {
      //                  return Center(
      //                      child: Text('Error: ${snapshot.error}')
      //                  );
      //                } else {
      //                  bool connection = snapshot.data ?? false; // Access the result
      //                  return connection
      //                      ? const LoginScreen()
      //                      :  showDialog();
      //                }
      //              },
      //
      // ),
      // )

        // ConstantVar.auth
        //     .currentUser== null?
        // const LoginScreen()
        //     : const HomeScreen(),
      );
    });
  }
}
