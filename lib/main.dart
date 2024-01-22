import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_processing_app/home/home.dart';
import 'package:image_processing_app/widgets/bar.dart';

import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 852),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
              navigatorKey: navigatorKey,
              scaffoldMessengerKey: Bar.messengerKey,
              title: 'Image Processing',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                    seedColor: Colors.deepPurple, brightness: Brightness.dark),
                useMaterial3: true,
              ),
              home: const Home());
        });
  }
}
