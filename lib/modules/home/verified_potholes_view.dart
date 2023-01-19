import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:potsoft/modules/home/pothole_details_screen.dart';

import '../../core/constants/my_constants.dart';
import '../../core/themes/my_colors.dart';
import '../../core/themes/my_textstyles.dart';
import '../../core/themes/theme_controller.dart';
import '../../core/utilities/utils.dart';

class VerifiedPotholesView extends StatelessWidget {
  const VerifiedPotholesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verified Potholes')),
      body: StreamBuilder(
        stream: fire
            .collection('verifiedPotholes')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          final snapData = snapshot.data;

          if (snapshot.connectionState == ConnectionState.waiting ||
              snapData == null) {
            return const CircularProgressIndicator();
          }

          if (snapData.docs.isEmpty) {
            return Utils.emptyList('no potholes uploaded yet!');
          }
          return Padding(
            padding: const EdgeInsets.all(13),
            child: Column(
              children: [
                // -------------------------------------- uploads count tile
                GetX<ThemeController>(
                  builder: (cntrl) => Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: cntrl.isDark()
                            ? MyColors.lightPurple.withAlpha(25)
                            : MyColors.pink.withAlpha(35)),
                    child: Row(
                      children: [
                        const Text('total verified Potholes so far'),
                        const Spacer(),
                        Text(
                          '${snapData.docs.length} ',
                          style: MyTStyles.kTS16Bold,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: GridView.builder(
                    itemCount: snapData.docs.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 13,
                      crossAxisSpacing: 13,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: (context, index) {
                      final data = snapData.docs[index].data();

                      return GestureDetector(
                        onTap: () => Get.to(() => PotholeDetailsScreen(data)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: GridTile(
                            footer: SizedBox(
                              height: 45,
                              child: GridTileBar(
                                  backgroundColor: Colors.black26,
                                  title: Text(
                                    data['street'].toString().capitalize!,
                                  ),
                                  subtitle: Text(
                                    data['subArea'] != ''
                                        ? data['subArea']
                                        : data['city'],
                                    style: MyTStyles.kTS12Regular,
                                  )),
                            ),
                            child: Image.network(
                              data['image'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
