import 'dart:developer';

import 'package:potsoft/core/constants/mykeys.dart';
import 'package:potsoft/modules/auth/signin_screen.dart';
import 'package:potsoft/core/utilities/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/constants/my_constants.dart';
import '../home/home_screen.dart';

class AuthController extends GetxController {
  //
  final _box = GetStorage();

  bool get isUserPresent => _box.read<bool>(MyKeys.userStatus) ?? false;

  bool get isUserAnonymous => _box.read<bool>(MyKeys.isAnonymous) ?? false;

  bool get isBusinessAcc => _box.read<bool>(MyKeys.isBusiness) ?? false;

  signInWithGoogle() async {
    try {
      /// `Trigger` the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      /// get the authentication details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      /// create a new `credential`
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      Utils.progressIndctr(label: 'loading...');

      /// once signed-in extract `UserCredentials`
      final userCredential = await auth.signInWithCredential(credential);

      /// if user `couldn't` login
      if (userCredential.user == null) {
        Utils.normalDialog();
        return;
      }

      _box.write(MyKeys.userStatus, true);

      Get.offAll(() => const HomeScreen());
      Utils.showSnackBar('Login Successful!', status: true);

      /// ---------------------------------------- check for `ADMIN`
      checkForBusinessAccAndUpdate(showStatus: true);
      //
      Utils.showAlert(
        'Notice',
        'We use location services to locate you with highest precisions so that potholes are located easily.\nWe really appreciate your cooperation.',
      );
      //
    } on FirebaseAuthException catch (e) {
      Get.back();
      Utils.showAlert('Oops', e.message.toString());
    } catch (e) {
      Get.back();

      if (e.toString() == 'Null check operator used on a null value') {
        Utils.showSnackBar('Please select your email to proceed');
      } else {
        Utils.showAlert('Oops', e.toString());
      }
    }
  }

  checkForBusinessAccAndUpdate({required bool showStatus}) async {
    if (await isBusinessAccount()) {
      log('======================== USER IS ADMIN ========================');
      _box.write(MyKeys.isBusiness, true);

      if (showStatus) {
        Utils.showAlert(
          'Hey there!',
          'You have got access to our potholes data from the admin team.',
        );
      }
    } else {
      _box.write(MyKeys.isBusiness, false);
    }
  }

  Future<bool> isBusinessAccount() async {
    try {
      final snapshot = await fire.collection('businesses').get();
      final dataList = snapshot.docs.map((echDoc) => echDoc.data()).toList();

      for (var each in dataList) {
        if (each['email'] == auth.currentUser!.email) return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  signInAnonymously() async {
    try {
      Utils.progressIndctr(label: 'loading...');
      await auth.signInAnonymously();

      _box.write(MyKeys.userStatus, true);
      _box.write(MyKeys.isAnonymous, true);

      Get.back();
      Get.offAll(() => const HomeScreen());
      Utils.showSnackBar('Login Successful!', status: true);
      //
    } on FirebaseAuthException catch (e) {
      Utils.showAlert('OOPS', e.message.toString());
    } catch (e) {
      Utils.normalDialog();
    }
  }

  logout() async {
    try {
      // ------------------------------ google logout
      await GoogleSignIn().signOut();

      // ------------------------------ clearing user login STATUS
      _box.write(MyKeys.userStatus, false);

      // ------------------------------ clearing user login STATUS
      _box.erase();

      // ------------------------------ if anonymous deleting user data
      if (isUserAnonymous) {
        auth.currentUser!.delete();
      }

      Get.offAll(() => SigninScreen());
    } catch (e) {
      log('=================== couldn\'t logout ==================');
    }
  }
}
