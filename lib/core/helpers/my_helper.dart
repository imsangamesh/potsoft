import 'package:potsoft/core/constants/my_constants.dart';

class MyHelper {
  static String get genDateId =>
      'user:${auth.currentUser!.uid} genId:${DateTime.now().toIso8601String()}|-|-|${DateTime.now().toIso8601String()}|-|-|${DateTime.now().toIso8601String()}';
}
