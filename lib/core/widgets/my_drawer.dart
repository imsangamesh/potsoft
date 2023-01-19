import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:potsoft/core/constants/mykeys.dart';
import 'package:potsoft/core/utilities/utils.dart';
import 'package:potsoft/modules/home/verified_potholes_view.dart';

import '../../../core/constants/my_constants.dart';
import '../../../core/themes/my_colors.dart';
import '../../../core/themes/my_textstyles.dart';
import '../../main.dart';
import '../../modules/auth/auth_controller.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  final box = GetStorage();
  final authController = Get.put(AuthController());

  String get name => auth.currentUser!.displayName ?? 'Guest User';
  String get email => auth.currentUser!.email ?? '';
  String get imageUrl =>
      auth.currentUser!.photoURL ??
      'https://img.freepik.com/premium-psd/3d-cartoon-avatar-smiling-man_1020-5130.jpg?size=338&ext=jpg&uid=R65626931&ga=GA1.2.1025021015.1655558182&semt=sph';

  primaryWithAlpha(int a) => isDark.value
      ? MyColors.lightPurple.withAlpha(a)
      : MyColors.pink.withAlpha(a);

  final isDark = Get.isDarkMode.obs;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Drawer(
      child: Obx(
        () => SizedBox(
          height: size.height,
          width: size.width * 0.6,
          child: Column(
            children: [
              AppBar(
                leading: const SizedBox(),
                title: const Text('it\'s all ME'),
              ),
              // --------------------------------------------------- profile
              const SizedBox(height: 25),
              CircleAvatar(
                radius: 50,
                backgroundColor: primaryWithAlpha(60),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      width: 7,
                      color: primaryWithAlpha(100),
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 35,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.network(imageUrl),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // ----------------------- name
              Text(
                name,
                overflow: TextOverflow.clip,
                maxLines: 1,
                style: MyTStyles.kTS18Medium.copyWith(
                    color: isDark.value ? MyColors.wheat : MyColors.darkPink),
              ),
              // ----------------------- email
              Text(
                email,
                overflow: TextOverflow.clip,
                maxLines: 1,
                style: GoogleFonts.quicksand(
                  textStyle: MyTStyles.kTS12Regular.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isDark.value ? MyColors.wheat : MyColors.darkPink,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              // --------------------------------------------------------- change theme
              Container(
                height: 45,
                decoration: BoxDecoration(
                  border: Border.symmetric(
                      horizontal: BorderSide(
                    width: 0,
                    color: primaryWithAlpha(100),
                  )),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: primaryWithAlpha(100),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // ----------------------- day
                              Icon(
                                isDark.value
                                    ? Icons.light_mode_outlined
                                    : Icons.light_mode_rounded,
                                size: 25,
                                color: isDark.value
                                    ? Colors.grey
                                    : MyColors.darkPink,
                              ),
                              // ----------------------- switch
                              CupertinoSwitch(
                                thumbColor: primaryWithAlpha(255),
                                activeColor: MyColors.emerald,
                                value: isDark.value,
                                onChanged: (newVal) {
                                  globalThemeContrl.toggleThemeMode();
                                  isDark(newVal);
                                },
                              ),
                              // ----------------------- night
                              Icon(
                                isDark.value
                                    ? Icons.nights_stay
                                    : Icons.nights_stay_outlined,
                                size: 25,
                                color:
                                    isDark.value ? MyColors.wheat : Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // ------------------------------- theme-label-text
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [primaryWithAlpha(100), Colors.transparent],
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              isDark.value ? 'it\'s Dark!' : 'rise & shine!',
                              style: MyTStyles.cursiveMedium
                                  .copyWith(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // ------------------------------------- Check out potholes for Business
              const SizedBox(height: 10),
              if (authController.isBusinessAcc)
                ListTile(
                  onTap: () {
                    Get.back();
                    Get.to(() => const VerifiedPotholesView());
                  },
                  leading: Icon(
                    Icons.auto_awesome,
                    color: isDark.value ? MyColors.wheat : MyColors.darkPink,
                  ),
                  tileColor: primaryWithAlpha(100),
                  title: const Text(
                    'Check-out Potholes!',
                    style: MyTStyles.kTS16Medium,
                  ),
                  trailing: Icon(
                    Icons.keyboard_double_arrow_right_rounded,
                    color: isDark.value ? MyColors.wheat : MyColors.darkPink,
                  ),
                ),
              // ------------------------------------- Request for business Acc
              if (!authController.isBusinessAcc)
                ListTile(
                  onTap: requestForBusiness,
                  tileColor: primaryWithAlpha(100),
                  title: const Text(
                    'Request for Business Acc?',
                    style: MyTStyles.kTS16Medium,
                  ),
                  subtitle:
                      isRequestPlaced ? const Text('request placed') : null,
                ),
              const Spacer(),
              // --------------------------------------------------------- logout
              InkWell(
                onTap: () => Utils.confirmDialogBox(
                  'Wanna logout?',
                  'Hey, you would have stayed a while more & uploaded more potholes!',
                  yesFun: () => authController.logout(),
                ),
                child: Container(
                  height: 45,
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(color: primaryWithAlpha(100)),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.power_settings_new_rounded,
                        color: MyColors.darkPink,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'logout',
                        style: MyTStyles.cursiveMedium.copyWith(
                          fontSize: 18,
                          color: MyColors.darkPink,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool get isRequestPlaced => box.read(MyKeys.isBusinessRequested) ?? false;

  requestForBusiness() {
    Get.back();

    if (isRequestPlaced) {
      Utils.showAlert(
        'Alert!',
        'you have already placed a request, please wait for confirmation email.',
      );
    } else {
      Utils.confirmDialogBox(
        'Are you sure?',
        'Do you want to place a request to start business account with us?',
        yesFun: postRequestToFirestore,
      );
    }
  }

  postRequestToFirestore() async {
    box.write(MyKeys.isBusinessRequested, true);

    try {
      Get.back();
      fire.collection('businessRequests').doc().set({
        'name': auth.currentUser!.displayName,
        'email': auth.currentUser!.email,
      });

      Utils.showSnackBar('Request placed', status: true);
    } catch (e) {
      Utils.normalDialog();
    }
  }
}
