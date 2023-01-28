import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:potsoft/core/helpers/my_helper.dart';
import 'package:potsoft/core/themes/my_colors.dart';
import 'package:potsoft/model/pot_hole_model.dart';
import 'package:potsoft/modules/upload/location_services.dart';
import 'package:potsoft/modules/upload/pothole_controller.dart';

import '../../core/themes/my_textstyles.dart';
import '../../core/utilities/textfield_wrapper.dart';
import '../../core/utilities/utils.dart';
import '../../core/widgets/my_buttons.dart';

class UploadNewPothole extends StatefulWidget {
  const UploadNewPothole({super.key});

  @override
  State<UploadNewPothole> createState() => _UploadNewPotholeState();
}

class _UploadNewPotholeState extends State<UploadNewPothole> {
  //
  File? image;
  double? lat, long;
  PotholeModel? place;
  final fetching = false.obs;
  final showLocationFetchBtn = false.obs;
  final descriptionCntrl = TextEditingController();

  @override
  initState() {
    getLocation();

    super.initState();
  }

  primary(int a) => Get.isDarkMode
      ? MyColors.lightPurple.withAlpha(a)
      : MyColors.pink.withAlpha(a);

  canSubmit() {
    if (lat == null ||
        long == null ||
        image == null ||
        descriptionCntrl.text == '') {
      return false;
    } else {
      return true;
    }
  }

  submitLocation() async {
    if (lat == null || long == null) {
      Utils.showAlert(
        'Oops!',
        'please make sure you\'ve selected your location before submitting.',
      );
      return;
    }

    if (image == null) {
      Utils.showAlert(
        'Oops!',
        'please take a picture of pothole to proceed further.',
      );
      return;
    }

    final id = MyHelper.genDateId;
    final imageUrl = await PotholeController.uploadImageFile(image!, id);
    if (imageUrl == null) {
      Utils.showSnackBar('couldn\'t upload image', status: false);
      return;
    }

    final newPothole = PotholeModel(
      id: id,
      image: imageUrl,
      name: place!.name,
      street: place!.street,
      subArea: place!.subArea,
      city: place!.city,
      country: place!.country,
      postCode: place!.postCode,
      lat: lat!,
      long: long!,
      date: DateTime.now().toIso8601String(),
      createdAt: Timestamp.now(),
      isVerified: 'false',
      description: descriptionCntrl.text,
    );

    PotholeController.updateNewPotholeToFire(newPothole);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text('Upload New Pothole')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              if (fetching())
                const Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: LinearProgressIndicator(minHeight: 2),
                ),
              Row(
                children: [
                  /// ------------------------------------------------------- `image-picker card`
                  Expanded(child: imagePickerCard(size)),
                  const SizedBox(width: 15),

                  /// ------------------------------------------------------- `location card`
                  Expanded(
                    child: InkWell(
                      onTap: () => getLocation(),
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        height: size.width * 0.5 - 40,
                        decoration: BoxDecoration(
                          color: primary(50),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: primary(150)),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.location_on_rounded),
                              const SizedBox(height: 5),
                              Text(
                                lat == null || long == null
                                    ? 'grant location\npermission'
                                    : 'location fetched!',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              MyOutlinedBtn(
                                'View in Map',
                                lat == null || long == null
                                    ? null
                                    : () => LocationServices.openGoogleMap(
                                        lat!, long!),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              ///-------------------------------------------------- `fetch Location btn`
              Obx(
                () => showLocationFetchBtn()
                    ? MyOutlinedBtn('Fetch Location', getLocation)
                    : const SizedBox(),
              ),

              /// ------------------------------------------------------- `location info`
              if (place != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '  Your location:',
                      style: MyTStyles.kTS14Regular,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 15),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: primary(25),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            labelText('Name', place!.name),
                            labelText('Street', place!.street),
                            labelText('Country', place!.country),
                            labelText('Postal-code', place!.postCode),
                            labelText('City', place!.city),
                            labelText('Sub area', place!.subArea),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

              /// ------------------------------------------------------- `description`
              TextFieldWrapper(
                TextField(
                  controller: descriptionCntrl,
                  maxLines: 5,
                  decoration: const InputDecoration.collapsed(
                    hintText: 'enter description',
                    hintStyle: MyTStyles.kTS15Medium,
                  ),
                ),
              ),

              SizedBox(
                width: double.infinity,
                child: MyOutlinedBtn(
                  'Upload',
                  canSubmit() ? submitLocation : null,
                  radius: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// --------------------------------------- `get LOCATION and ADDRESS`
  getLocation() async {
    fetching(true);

    await LocationServices.getCurrentLocation().then((value) async {
      if (value != null || value!.isNotEmpty) {
        //
        setState(() {
          lat = value[0];
          long = value[1];
          place = value[2];
        });

        await getLiveLocation();
      } else {
        showLocationFetchBtn(true);
      }
    });

    fetching(false);
  }

  /// --------------------------------------- `get LIVE LOCATION`
  getLiveLocation() async {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position position) async {
        await LocationServices.getAddress(position).then((newPlace) {
          setState(() {
            lat = position.latitude;
            long = position.longitude;
            place = newPlace;
          });
        });
      },
    );
  }

  /// --------------------------------------- `pick IMAGE`
  pickImage() async {
    try {
      final img = await ImagePicker().pickImage(source: ImageSource.camera);

      if (img == null) {
        Utils.showSnackBar('you didn\'t choose image');
        return;
      }

      setState(() {
        image = File(img.path);
      });
    } on PlatformException {
      Utils.showSnackBar('Oops, failed to capture image');
    }
  }

  labelText(String title, String subtitle) {
    return RichText(
      text: TextSpan(
        text: '$title: ',
        style: MyTStyles.kTS13Medium.copyWith(
          color: Get.isDarkMode ? const Color(0xFFDBDBDB) : MyColors.black,
          height: 1.2,
        ),
        children: [TextSpan(text: subtitle, style: MyTStyles.kTS13Regular)],
      ),
    );
  }

  /// --------------------------------------- `image picker widget`
  Widget imagePickerCard(Size size) {
    if (image == null) {
      return InkWell(
        onTap: pickImage,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: size.width * 0.5 - 40,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: primary(50),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: primary(150)),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.add_a_photo),
                SizedBox(height: 10),
                Text('capture image'),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container(
        height: size.width * 0.5 - 40,
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: primary(50),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: primary(100)),
        ),
        child: Stack(
          children: [
            SizedBox.expand(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(image!, fit: BoxFit.cover),
              ),
            ),
            Positioned(
              right: 0,
              child: MyCloseBtn(ontap: () => setState(() => image = null)),
            ),
          ],
        ),
      );
    }
  }
}
