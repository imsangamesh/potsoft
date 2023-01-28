import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:potsoft/core/themes/my_colors.dart';
import 'package:potsoft/core/themes/my_textstyles.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../core/widgets/my_buttons.dart';

class PotholeDetailsScreen extends StatelessWidget {
  const PotholeDetailsScreen(this.dataMap, {super.key});

  final Map<String, dynamic> dataMap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text(dataMap['name']), centerTitle: false),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(dataMap['image'], fit: BoxFit.cover),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: MyColors.color(25),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    labelText('Name', dataMap['name']),
                    labelText('Street', dataMap['street']),
                    labelText('Country', dataMap['country']),
                    labelText('Postal-code', dataMap['postCode']),
                    labelText('City', dataMap['city']),
                    labelText('Sub area', dataMap['subArea']),
                    labelText('latitude', dataMap['lat'].toStringAsFixed(2)),
                    labelText('longitude', dataMap['long'].toStringAsFixed(2)),
                    const SizedBox(height: 10),
                    labelText(
                      'uploaded on',
                      DateFormat('dd MMM yyy  |  hh:mm')
                          .format(DateTime.parse(dataMap['date'])),
                    ),
                    const SizedBox(height: 10),
                    labelText('Description', dataMap['description']),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30, left: 15, right: 15),
              child: SizedBox(
                width: double.infinity,
                child: MyOutlinedBtn(
                  'View in Google Map',
                  () => openGoogleMap(dataMap['lat'], dataMap['long']),
                  icon: Icons.launch_rounded,
                  radius: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static openGoogleMap(double lat, double long) async {
    String url = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    await launchUrlString(url);
  }

  labelText(String title, String subtitle) {
    return RichText(
      text: TextSpan(
        text: '$title: ',
        style: MyTStyles.kTS14Medium.copyWith(
          color: Get.isDarkMode ? const Color(0xFFDBDBDB) : MyColors.black,
          height: 1.5,
        ),
        children: [TextSpan(text: subtitle, style: MyTStyles.kTS14Regular)],
      ),
    );
  }
}
