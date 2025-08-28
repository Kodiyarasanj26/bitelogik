import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String authBox = "authBox";

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(authBox);
  }

  static void saveLoginState(bool isLoggedIn) {
    Hive.box(authBox).put("isLoggedIn", isLoggedIn);
  }

  static bool isLoggedIn() {
    return Hive.box(authBox).get("isLoggedIn", defaultValue: false);
  }

  static void clearLogin() {
    Hive.box(authBox).put("isLoggedIn", false);
  }
}
