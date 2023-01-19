import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:potsoft/model/pot_hole_model.dart';

import '../../core/constants/my_constants.dart';
import '../../core/utilities/utils.dart';

class PotholeController {
  //
  static Future<String?> uploadImageFile(File file, String id) async {
    try {
      Utils.progressIndctr(label: 'uploading...');
      TaskSnapshot taskSnapshot =
          await store.ref().child('pothole_images').child(id).putFile(file);

      Get.back();
      return await taskSnapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      Get.back();
      Utils.showAlert(e.code, e.message.toString());
    } catch (e) {
      Get.back();
      Utils.normalDialog();
    }
    return null;
  }

  static updateNewPotholeToFire(PotholeModel potholeModel) async {
    try {
      // ------------------- updating to all potholes
      await fire
          .collection('potholes')
          .doc(potholeModel.id)
          .set(potholeModel.toMap());

      // ------------------- updating to user pothole collection
      await fire
          .collection('individualPotholes')
          .doc('userId: ${auth.currentUser!.uid}')
          .collection('potholes')
          .doc(potholeModel.id)
          .set(potholeModel.toMap());

      Get.back();
      Utils.showSnackBar('new pothole uploaded! Thankyou', status: true);
    } on FirebaseException catch (e) {
      Utils.showAlert(e.code, e.message.toString());
    } catch (e) {
      Utils.normalDialog();
    }
  }
}
