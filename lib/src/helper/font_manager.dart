
import 'package:flutter/services.dart';

class FontManager {

  //Load Fonts as byteData
  static Future<ByteData> loadFont(String fontPath) async {
    return await rootBundle.load(fontPath);
  }

/// Function to load a TTF font from byte data and return the font family name
static Future<String> loadFontAndReturnFamily(String fontPath, String fontFamilyName) async {
  try {
    final fontData =  await loadFont(fontPath).then((data) => data.buffer.asUint8List());
    final fontLoader = FontLoader(fontFamilyName)..addFont(Future.value(ByteData.sublistView(fontData)));
    await fontLoader.load();
    return fontFamilyName;
  } catch (e) {
    throw Exception("Error loading font: $e");
  }
}
}
