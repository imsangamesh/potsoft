import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'core/constants/my_constants.dart';
import 'core/themes/my_themes.dart';
import 'core/themes/theme_controller.dart';
import 'modules/auth/auth_controller.dart';
import 'modules/auth/signin_screen.dart';
import 'modules/home/home_screen.dart';

void main() async {
  await GetStorage.init();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();

  final authController = Get.put(AuthController());
  final themeController = Get.put(ThemeController());

  themeController.configCurrTheme();
  authController.checkForBusinessAccAndUpdate(showStatus: false);

  if (authController.isUserPresent && auth.currentUser != null) {
    log('======================== USER ID : ${auth.currentUser!.uid}');
    runApp(const MyApp(HomeScreen()));
    return;
  }

  runApp(MyApp(SigninScreen()));
}

final globalThemeContrl = Get.put(ThemeController());

class MyApp extends StatelessWidget {
  const MyApp(this.screen, {super.key});

  final dynamic screen;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Potsoft',
      debugShowCheckedModeBanner: false,
      themeMode: globalThemeContrl.themeMode,
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      home: screen,
    );
  }
}
