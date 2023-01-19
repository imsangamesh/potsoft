import 'package:google_fonts/google_fonts.dart';
import 'package:potsoft/core/constants/my_images.dart';
import 'package:potsoft/core/themes/my_colors.dart';
import 'package:potsoft/core/themes/my_textstyles.dart';
import 'package:potsoft/modules/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SigninScreen extends StatelessWidget {
  SigninScreen({super.key});

  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: MyColors.white,
      body: Column(children: [
        const SizedBox(height: 120),
        Text(
          'Welcome to Potsoft',
          style: MyTStyles.cursiveMedium.copyWith(
            color: Get.isDarkMode ? MyColors.purple : MyColors.interPink,
          ),
        ),
        Text(
          'securely signin with us to help\npeople in need.',
          style: GoogleFonts.rubik(textStyle: MyTStyles.kTS12Regular),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: size.height * 0.5,
          width: size.width,
          child: Image.asset(MyImages.login),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => authController.signInWithGoogle(),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.only(top: 5, bottom: 5, left: 8),
            textStyle: MyTStyles.kTS16Medium,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.account_circle, size: 30),
              SizedBox(width: 30),
              Text('Sign up with Google'),
              SizedBox(width: 50),
            ],
          ),
        ),
      ]),
    );
  }
}
