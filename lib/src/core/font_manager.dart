part of 'package:bangla_pdf_fixer/bangla_pdf_fixer.dart';

/// Singleton Font Manager for Bangla Fonts.
class BanglaFontManager {
  BanglaFontManager._internal();
  static final BanglaFontManager _instance = BanglaFontManager._internal();
  factory BanglaFontManager() => _instance;

  final Map<BanglaFontType, pw.Font> _fontCache = {};

  /// Initialize and preload all fonts synchronously accessible later
  Future<void> initialize() async {
    for (var type in BanglaFontType.values) {
      await _loadFont(type);
    }
  }

  /// Get a font synchronously (must call `initialize()` before using)
  pw.Font getFont(BanglaFontType type) {
    final font = _fontCache[type];
    if (font == null) {
      throw Exception(
          'Font $type not loaded! Call await BanglaFontManager().initialize() before using.');
    }
    return font;
  }

  /// Internal font loader
  Future<void> _loadFont(BanglaFontType type) async {
    final path = BanglaFonts.getPath(type);
    final font = pw.Font.ttf(await rootBundle.load(path));
    _fontCache[type] = font;
  }

  /// Function to load a TTF font from byte data and return the font family name
  static bool isBanglaText(String text) {
    // Regex for Bangla Unicode block
    final banglaRegex = RegExp(r'[\u0980-\u09FF]');
    return banglaRegex.hasMatch(text);
  }
}
