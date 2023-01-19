import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyColors {
  //
  static color(int a) => Get.isDarkMode
      ? MyColors.lightPurple.withAlpha(a)
      : MyColors.pink.withAlpha(a);

  static const white = Colors.white;
  static const black = Color(0xFF030723);
  static const green = Color(0xFF00FF08);
  static const grey = Color(0xFF9E9E9E);

  static const pink = Color(0xffFF8FB1);
  static const orangePink = Color(0xffFEBEB1);
  static const purple = Color(0xff7A4495);
  static const emerald = Color(0xff647E68);
  static const wheatGrey = Color(0xffDCD7C9);
  static const wheat = Color(0xffF2DEBA);

  /// ------------------------------------------------------ `scaffold`
  static const lightScaffoldBG = Color(0xffFFF5E4);
  static const darkScaffoldBG = Color(0xFF03071B);

  /// ========================================================================== `SHADES`

  // -------------- light
  static const lightPink = Color(0xffffc6d7);
  static const lightPurple = Color(0xffBA94D1);

  // -------------- dark
  static const darkPink = Color(0xffde004a);
  static const darkPurple = Color(0xFF442C4F);

  // -------------- inter
  static const interPink = Color(0xFFEC407A);

  /// ========================================================================== `WIDGETS`

  // -------------- light
  static final lightListTile = const Color(0xffFF8FB1).withAlpha(30);

  // -------------- dark
  static final darkListTile = const Color(0xffBA94D1).withAlpha(15);
}



// 1 playfairDisplay
// 1 berkshireSwash
// 2 quicksand
// 3 zillaSlab - M

// amatic sc
