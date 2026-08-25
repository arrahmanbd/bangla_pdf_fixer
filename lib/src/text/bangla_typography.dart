import 'package:pdf/pdf.dart';
import 'package:pdf_text_shaper/pdf_text_shaper.dart';

/// Reusable font/style configuration for Bangla PDF widgets.
///
/// This keeps document code compact when the same regular/bold fonts and
/// fallback chain are used throughout many widgets.
final class BanglaTypography {
  const BanglaTypography({
    required this.regularFont,
    this.boldFont,
    this.fallbackFonts = const <ShapedFont>[],
    this.boldFallbackFonts,
    this.defaultColor = PdfColors.black,
    this.preserveUnicodeText = true,
  });

  final ShapedFont regularFont;
  final ShapedFont? boldFont;
  final List<ShapedFont> fallbackFonts;
  final List<ShapedFont>? boldFallbackFonts;
  final PdfColor defaultColor;
  final bool preserveUnicodeText;

  /// Creates a shaped text style using this typography configuration.
  ShapedTextStyle style({
    bool bold = false,
    double fontSize = 14,
    PdfColor? color,
    double? lineHeight,
    ShapedTextAlign align = ShapedTextAlign.start,
    bool? preserveUnicode,
  }) {
    return ShapedTextStyle(
      font: bold ? boldFont ?? regularFont : regularFont,
      fallbackFonts: bold ? boldFallbackFonts ?? fallbackFonts : fallbackFonts,
      fontSize: fontSize,
      color: color ?? defaultColor,
      lineHeight: lineHeight,
      align: align,
      preserveUnicodeText: preserveUnicode ?? preserveUnicodeText,
    );
  }

  ShapedTextStyle body({
    double fontSize = 14,
    PdfColor? color,
    double lineHeight = 1.25,
    ShapedTextAlign align = ShapedTextAlign.start,
  }) {
    return style(
      fontSize: fontSize,
      color: color,
      lineHeight: lineHeight,
      align: align,
    );
  }

  ShapedTextStyle heading({
    double fontSize = 24,
    PdfColor? color,
    double? lineHeight,
    ShapedTextAlign align = ShapedTextAlign.start,
  }) {
    return style(
      bold: true,
      fontSize: fontSize,
      color: color,
      lineHeight: lineHeight,
      align: align,
    );
  }
}
