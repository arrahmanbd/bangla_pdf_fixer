part of 'package:bangla_pdf_fixer/bangla_pdf_fixer.dart';

extension BanglaTextExtension on String {
  bool get isBanglaText => BanglaFontManager.isBanglaText(this);

  /// Fixes the Bangla text by mapping it to ANSI (if Bangla).
  String get fix => isBanglaText ? BanglaUnicodeMapper.encodeANSI(this) : this;
}

extension BanglaFontTypeExtension on BanglaFontType {
  /// Returns a ready-to-use pw.TextStyle with this Bangla font
  pw.TextStyle ts({
    double fontSize = 16,
    pw.FontWeight fontWeight = pw.FontWeight.normal,
    pw.PdfColor color = PdfColors.black,
  }) {
    return pw.TextStyle(
      font: BanglaFontManager().getFont(this),
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  /// Get a ready-to-use TextStyle for this font
  pw.TextStyle style({
    double fontSize = 16,
    pw.FontWeight fontWeight = pw.FontWeight.normal,
    pw.PdfColor color = PdfColors.black,
  }) {
    return pw.TextStyle(
      font: BanglaFontManager().getFont(this),
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  /// Shortcut to create a BanglaText widget
  pw.Widget text(
    String text, {
    double fontSize = 16,
    pw.FontWeight fontWeight = pw.FontWeight.normal,
    pw.PdfColor color = PdfColors.black,
    pw.TextAlign textAlign = pw.TextAlign.start,
  }) {
    return pw.Text(
      text.fix,
      style: style(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
      textAlign: textAlign,
    );
  }
}
