import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf_text_shaper/pdf_text_shaper.dart';

import 'bangla_text.dart';

/// A lightweight Unicode-safe bullet list for Bangla PDF content.
final class BanglaBulletList extends pw.StatelessWidget {
  BanglaBulletList({
    required this.items,
    this.style,
    this.font,
    this.fallbackFonts = const <ShapedFont>[],
    this.fontSize = 12,
    this.color = PdfColors.black,
    this.lineHeight = 1.25,
    this.preserveUnicodeText = true,
    this.spacing = 6,
    this.indent = 0,
    this.markerGap = 8,
    this.markerSize = 4,
    this.markerColor,
  }) : assert(
         style != null || font != null,
         'Provide either style or font to BanglaBulletList.',
       ),
       assert(spacing >= 0),
       assert(indent >= 0),
       assert(markerGap >= 0),
       assert(markerSize > 0);

  final List<String> items;
  final ShapedTextStyle? style;
  final ShapedFont? font;
  final List<ShapedFont> fallbackFonts;

  final double fontSize;
  final PdfColor color;
  final double lineHeight;
  final bool preserveUnicodeText;

  final double spacing;
  final double indent;
  final double markerGap;
  final double markerSize;
  final PdfColor? markerColor;

  @override
  pw.Widget build(pw.Context context) {
    if (items.isEmpty) {
      return pw.SizedBox.shrink();
    }

    final textStyle =
        style ??
        ShapedTextStyle(
          font: font!,
          fallbackFonts: fallbackFonts,
          fontSize: fontSize,
          color: color,
          lineHeight: lineHeight,
          preserveUnicodeText: preserveUnicodeText,
        );

    final content = pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < items.length; index++) ...[
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: markerSize,
                height: markerSize,
                margin: pw.EdgeInsets.only(top: fontSize * 0.42),
                decoration: pw.BoxDecoration(
                  color: markerColor ?? color,
                  shape: pw.BoxShape.circle,
                ),
              ),
              pw.SizedBox(width: markerGap),
              pw.Expanded(child: BanglaText(items[index], style: textStyle)),
            ],
          ),
          if (index != items.length - 1) pw.SizedBox(height: spacing),
        ],
      ],
    );

    if (indent == 0) {
      return content;
    }

    return pw.Padding(
      padding: pw.EdgeInsets.only(left: indent),
      child: content,
    );
  }
}
