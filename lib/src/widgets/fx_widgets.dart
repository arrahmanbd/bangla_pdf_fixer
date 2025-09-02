part of 'package:bangla_pdf_fixer/bangla_pdf_fixer.dart';

class BanglaText extends pw.StatelessWidget {
  final String text;
  final double fontSize;
  final pw.FontWeight fontWeight;
  final PdfColor color;
  final pw.TextAlign textAlign;
  final BanglaFontType fontType;

  BanglaText(
    this.text, {
    this.fontSize = 16,
    this.fontWeight = pw.FontWeight.normal,
    this.color = PdfColors.black,
    this.textAlign = pw.TextAlign.start,
    this.fontType = BanglaFontType.kalpurush,
  });

  @override
  pw.Widget build(pw.Context context) {
    return pw.Text(
      text.fix,
      textAlign: textAlign,
      style: pw.TextStyle(
        font: BanglaFontManager().getFont(fontType),
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}

/// Represents a single text span in a PDF RichText.
class RichTextItem {
  final String text;
  final double fontSize;
  final PdfColor color;
  final BanglaFontType fontType;

  const RichTextItem({
    required this.text,
    this.fontSize = 14,
    this.color = PdfColors.black,
    required this.fontType,
  });
}

/// A reusable RichText widget for PDF documents supporting automatic Bangla detection.
class BanglaRichText extends pw.StatelessWidget {
  final List<BanglaTextSpan> spans;
  final pw.TextAlign textAlign;

  BanglaRichText({
    required this.spans,
    this.textAlign = pw.TextAlign.start,
  });

  @override
  pw.Widget build(pw.Context context) {
    return pw.RichText(
      textAlign: textAlign,
      text: pw.TextSpan(
        children: spans.map((span) {
          return pw.TextSpan(
            text: span.text.fix,
            style: pw.TextStyle(
              font: BanglaFontManager().getFont(span.fontType),
              fontSize: span.fontSize,
              fontWeight: span.fontWeight,
              color: span.color,
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// A text span for BanglaRichText
class BanglaTextSpan {
  final String text;
  final double fontSize;
  final pw.FontWeight fontWeight;
  final PdfColor color;
  final BanglaFontType fontType;

  BanglaTextSpan(
    this.text, {
    this.fontSize = 16,
    this.fontWeight = pw.FontWeight.normal,
    this.color = PdfColors.black,
    this.fontType = BanglaFontType.kalpurush,
  });
}

/// Header widget (like pw.Header but with Bangla support)
class BanglaHeader extends pw.StatelessWidget {
  final String text;
  final double fontSize;
  final pw.FontWeight fontWeight;
  final BanglaFontType fontType;

  BanglaHeader(
    this.text, {
    this.fontSize = 24,
    this.fontWeight = pw.FontWeight.bold,
    this.fontType = BanglaFontType.kalpurush,
  });

  @override
  pw.Widget build(pw.Context context) {
    return pw.Header(
      level: 0,
      child: BanglaText(
        text,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontType: fontType,
      ),
    );
  }
}

/// Paragraph widget (like pw.Paragraph but Bangla)
class BanglaParagraph extends pw.StatelessWidget {
  final String text;
  final double fontSize;
  final pw.FontWeight fontWeight;
  final pw.TextAlign textAlign;
  final BanglaFontType fontType;

  BanglaParagraph(
    this.text, {
    this.fontSize = 14,
    this.fontWeight = pw.FontWeight.normal,
    this.textAlign = pw.TextAlign.start,
    this.fontType = BanglaFontType.kalpurush,
  });

  @override
  pw.Widget build(pw.Context context) {
    return pw.Paragraph(
      text: text.fix,
      style: pw.TextStyle(
        font: BanglaFontManager().getFont(fontType),
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      textAlign: textAlign,
    );
  }
}
