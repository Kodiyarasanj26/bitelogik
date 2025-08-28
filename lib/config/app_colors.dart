
import 'dart:ui';

class AppColor {
  static Color primaryColor = HexColor("#7B1F84");
  static Color secondaryColor = HexColor("#4A397D");
  static Color primaryWhite = HexColor("#FFFFFF");
  static Color textColor000000 = HexColor("#000000");



}


class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}