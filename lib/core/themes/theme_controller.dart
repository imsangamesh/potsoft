import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:potsoft/core/constants/mykeys.dart';

class ThemeController extends GetxController {
  //
  final _box = GetStorage();

  final isDark = false.obs;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  bool get _isDarkMode => _box.read(MyKeys.isDarkMode) ?? false;

  configCurrTheme() => _isDarkMode ? isDark(true) : isDark(false);

  toggleThemeMode() {
    if (Get.isDarkMode) {
      /// ------------------------------- `LIGHT`
      Get.changeThemeMode(ThemeMode.light);
      _box.write(MyKeys.isDarkMode, false);
      isDark(false);
    } else {
      /// ------------------------------- `DARK`
      Get.changeThemeMode(ThemeMode.dark);
      _box.write(MyKeys.isDarkMode, true);
      isDark(true);
    }
  }
}
