import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:potsoft/core/themes/my_colors.dart';
import 'package:potsoft/core/themes/my_textstyles.dart';
import 'package:potsoft/core/widgets/my_buttons.dart';

class Utils {
  //
  static void normalDialog() {
    showAlert(
      'Oops',
      'Sorry, something went wrong, please report us while we work on it.',
    );
  }

  static Widget emptyList(String text) {
    return SizedBox(
      height: 150,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bubble_chart_outlined, size: 30),
            const SizedBox(height: 5),
            Text(
              text,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------------------------------ `default`
  static void showAlert(String title, String description,
      {bool? isDismissable}) {
    Get.defaultDialog(
      backgroundColor: Get.isDarkMode ? MyColors.lightPurple : MyColors.wheat,
      barrierDismissible: isDismissable ?? true,
      //
      content: Padding(
        padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      title,
                      style: GoogleFonts.berkshireSwash(
                        textStyle: MyTStyles.kTS20Medium.copyWith(
                          color: MyColors.darkPink,
                        ),
                      ),
                    ),
                  ),
                ),
                const MyCloseBtn()
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                description,
                style: MyTStyles.kTS16Regular
                    .copyWith(color: MyColors.darkScaffoldBG),
              ),
            ),
          ],
        ),
      ),
      //
      title: '',
      titleStyle: const TextStyle(fontSize: 0),
      titlePadding: EdgeInsets.zero,
      //
      middleText: '',
      middleTextStyle: const TextStyle(fontSize: 0),
      contentPadding: EdgeInsets.zero,
      //
    );
  }

  // ------------------------------------------------------------------------------------ `snack bar`
  static showSnackBar(String message, {bool? status}) {
    Color myColor(int a) => status == null
        ? const Color(0xFFFFEBAF)
        : status
            ? const Color(0xFF79F17D)
            : const Color(0xFFE9746C);

    Get.showSnackbar(GetSnackBar(
      padding: const EdgeInsets.all(0),
      messageText: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: myColor(170),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: myColor(255)),
        ),
        child: Center(
            child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              status == null
                  ? Icons.notifications_active
                  : status
                      ? Icons.done_all_rounded
                      : Icons.warning_rounded,
              size: 20,
              color: MyColors.darkScaffoldBG,
            ),
            const SizedBox(width: 10),
            Text(
              message,
              style: MyTStyles.kTS13Medium.copyWith(color: MyColors.black),
            ),
          ],
        )),
      ),
      backgroundColor: Colors.transparent,
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
      duration: const Duration(milliseconds: 2000),
    ));
  }

  // ------------------------------------------------------------------------------------ `loading`
  static progressIndctr({String? label}) {
    Get.dialog(Scaffold(
      backgroundColor: MyColors.color(20),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: MyColors.color(100),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  backgroundColor:
                      Get.isDarkMode ? MyColors.darkScaffoldBG : MyColors.wheat,
                  color: MyColors.color(255),
                ),
              ),
            ),
            const SizedBox(height: 5),
            if (label != null)
              Text(
                label,
                style:
                    MyTStyles.kTS14Regular.copyWith(color: MyColors.color(255)),
              )
          ],
        ),
      ),
    ));
  }

  // ------------------------------------------------------------------------------------ `confirm`
  static void confirmDialogBox(
    String title,
    String description, {
    required VoidCallback yesFun,
    bool? isDismissable,
    VoidCallback? noFun,
  }) {
    Get.defaultDialog(
      backgroundColor: Get.isDarkMode ? MyColors.darkPurple : MyColors.wheat,
      barrierDismissible: isDismissable ?? true,
      //
      content: Padding(
        padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      title,
                      style: GoogleFonts.berkshireSwash(
                        textStyle: MyTStyles.kTS20Medium.copyWith(
                          color: Get.isDarkMode
                              ? MyColors.lightPurple
                              : MyColors.darkPink,
                        ),
                      ),
                    ),
                  ),
                ),
                const MyCloseBtn()
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                description,
                style: MyTStyles.kTS14Medium.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyOutlinedBtn(
                    'Nope',
                    noFun ?? () => Get.back(),
                    icon: Icons.close_rounded,
                  ),
                  const Text('|'),
                  MyOutlinedBtn('Yup ', () {
                    Get.back();
                    yesFun();
                  }, icon: Icons.check_rounded),
                ],
              ),
            )
          ],
        ),
      ),
      //
      title: '',
      titleStyle: const TextStyle(fontSize: 0),
      titlePadding: EdgeInsets.zero,
      //
      middleText: '',
      middleTextStyle: const TextStyle(fontSize: 0),
      contentPadding: EdgeInsets.zero,
      //
    );
  }
}
