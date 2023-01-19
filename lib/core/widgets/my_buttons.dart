import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../themes/my_colors.dart';
import '../themes/my_textstyles.dart';

/// --------------------------------------------------------------------------------------- `CLOSE`
class MyCloseBtn extends StatelessWidget {
  const MyCloseBtn({this.icon, this.ontap, super.key});

  final VoidCallback? ontap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: InkWell(
        onTap: ontap ?? () => Get.back(),
        borderRadius: BorderRadius.circular(30),
        splashColor: MyColors.pink,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.circle,
                color: MyColors.lightPink,
                size: 30,
              ),
            ),
            Icon(icon ?? Icons.close, size: 23, color: MyColors.darkPink),
          ],
        ),
      ),
    );
  }
}

/// --------------------------------------------------------------------------------------- `OUTLINE BUTTONS`
class MyOutlinedBtn extends StatelessWidget {
  const MyOutlinedBtn(
    this.label,
    this.ontap, {
    this.icon,
    this.radius,
    super.key,
  });

  final VoidCallback? ontap;
  final String label;
  final IconData? icon;
  final double? radius;

  primary(int a) => Get.isDarkMode
      ? MyColors.lightPurple.withAlpha(a)
      : MyColors.pink.withAlpha(a);

  @override
  Widget build(BuildContext context) {
    /// --------------------------------------------------- `Label`
    if (icon == null) {
      return OutlinedButton(
        onPressed: ontap,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 30),
          ),
          side: BorderSide(width: 1, color: primary(60)),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        ),
        child: Text(label, style: MyTStyles.kTS16Medium),
      );
    }

    /// --------------------------------------------------- `Label & Icon`
    return OutlinedButton.icon(
      onPressed: ontap,
      icon: Icon(icon),
      label: Text(label, style: MyTStyles.kTS16Medium),
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 30),
        ),
        side: BorderSide(width: 1, color: primary(60)),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7.5),
      ),
    );
  }
}

/// --------------------------------------------------------------------------------------- `OUTLINED ICON`
class MyOutlinedIconBtn extends StatelessWidget {
  const MyOutlinedIconBtn(
    this.icon,
    this.ontap, {
    this.radius,
    this.size,
    Key? key,
  }) : super(key: key);

  final IconData icon;
  final VoidCallback ontap;
  final double? radius;
  final double? size;

  primary(int a) => Get.isDarkMode
      ? MyColors.lightPurple.withAlpha(a)
      : MyColors.pink.withAlpha(a);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size ?? 42,
      width: size ?? 42,
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: FittedBox(
          child: InkWell(
            splashColor: primary(60),
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius ?? 100),
                border: Border.all(
                  width: 1.2,
                  color: primary(80),
                ),
              ),
              child: IconButton(
                splashRadius: 30,
                icon: Icon(
                  icon,
                  size: 32,
                  color: Get.isDarkMode
                      ? MyColors.lightPurple
                      : MyColors.interPink,
                ),
                onPressed: ontap,
                splashColor: primary(60),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// --------------------------------------------------------------------------------------- `SELECTABLE`
class MySelectableIconBtn extends StatelessWidget {
  const MySelectableIconBtn(
    this.isSelected,
    this.selectedIcon,
    this.unSelectedIcon,
    this.ontap, {
    this.radius,
    this.size,
    Key? key,
  }) : super(key: key);

  final IconData selectedIcon;
  final IconData unSelectedIcon;
  final VoidCallback ontap;
  final double? radius;
  final double? size;
  final bool isSelected;

  primary(int a) => Get.isDarkMode
      ? MyColors.lightPurple.withAlpha(a)
      : MyColors.pink.withAlpha(a);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size ?? 42,
      width: size ?? 42,
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: FittedBox(
          child: InkWell(
            splashColor: primary(60),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius ?? 100),
                border: Border.all(
                  width: isSelected ? 3.5 : 1.2,
                  color: isSelected
                      ? Get.isDarkMode
                          ? MyColors.lightPurple
                          : MyColors.interPink
                      : primary(80),
                ),
              ),
              child: IconButton(
                icon: Icon(
                  isSelected ? selectedIcon : unSelectedIcon,
                  size: 32,
                  color: Get.isDarkMode
                      ? MyColors.lightPurple
                      : MyColors.interPink,
                ),
                onPressed: ontap,
                splashColor: primary(80),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
