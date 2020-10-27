import 'dart:ui';

class ColorUtils {
  static Color fromHex(String hex) {
    assert(hex != null);
    if (hex == null || hex.isEmpty) {
      return Color(0xff000000);
    }
    if (hex.length == 7) {
      if (hex.startsWith('#')) {
        hex = hex.replaceFirst('#', 'ff');
      }
      return Color(int.parse(hex, radix: 16));
    } else {
      return Color(0xff000000);
    }
  }

  static String toHex(Color color) {
    assert(color != null);
    if (color == null) {
      return '#000000';
    }
    return color.value.toRadixString(16);
  }
}
