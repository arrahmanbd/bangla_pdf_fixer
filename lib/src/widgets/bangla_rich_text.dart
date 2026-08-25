import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf_text_shaper/pdf_text_shaper.dart';

import 'bangla_text.dart';

/// One independently shaped run inside [BanglaRichText].
final class BanglaTextSpan {
  const BanglaTextSpan(
    this.text, {
    this.style,
    this.font,
    this.fallbackFonts = const <ShapedFont>[],
    this.fontSize,
    this.color,
    this.lineHeight,
    this.preserveUnicodeText,
  });

  final String text;
  final ShapedTextStyle? style;
  final ShapedFont? font;
  final List<ShapedFont> fallbackFonts;
  final double? fontSize;
  final PdfColor? color;
  final double? lineHeight;
  final bool? preserveUnicodeText;
}

/// Lightweight rich Bangla text composed from independently shaped runs.
///
/// This widget is best for short mixed-style labels/headings. Each whitespace
/// or non-whitespace token is shaped independently so `pw.Wrap` can flow it.
/// For long body copy, use [BanglaText] or `BanglaParagraph` instead so the
/// shaping engine owns the complete paragraph layout.
final class BanglaRichText extends pw.StatelessWidget {
  BanglaRichText({
    required this.spans,
    required this.font,
    this.fallbackFonts = const <ShapedFont>[],
    this.fontSize = 14,
    this.color = PdfColors.black,
    this.lineHeight,
    this.preserveUnicodeText = true,
    this.spacing = 0,
    this.runSpacing = 2,
    this.alignment = pw.WrapAlignment.start,
    this.crossAxisAlignment = pw.WrapCrossAlignment.start,
  }) : assert(spacing >= 0),
       assert(runSpacing >= 0);

  final List<BanglaTextSpan> spans;
  final ShapedFont font;
  final List<ShapedFont> fallbackFonts;
  final double fontSize;
  final PdfColor color;
  final double? lineHeight;
  final bool preserveUnicodeText;
  final double spacing;
  final double runSpacing;
  final pw.WrapAlignment alignment;
  final pw.WrapCrossAlignment crossAxisAlignment;

  @override
  pw.Widget build(pw.Context context) {
    if (spans.isEmpty) {
      return pw.SizedBox.shrink();
    }

    final children = <pw.Widget>[];

    for (final span in spans) {
      if (span.text.isEmpty) {
        continue;
      }

      final parts = RegExp(r'\s+|\S+')
          .allMatches(span.text)
          .map((match) => match.group(0)!)
          .where((value) => value.isNotEmpty);

      final spanStyle =
          span.style ??
          ShapedTextStyle(
            font: span.font ?? font,
            fallbackFonts: span.fallbackFonts.isNotEmpty
                ? span.fallbackFonts
                : fallbackFonts,
            fontSize: span.fontSize ?? fontSize,
            color: span.color ?? color,
            lineHeight: span.lineHeight ?? lineHeight,
            preserveUnicodeText:
                span.preserveUnicodeText ?? preserveUnicodeText,
          );

      for (final part in parts) {
        children.add(BanglaText(part, style: spanStyle));
      }
    }

    if (children.isEmpty) {
      return pw.SizedBox.shrink();
    }

    return pw.Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      alignment: alignment,
      crossAxisAlignment: crossAxisAlignment,
      children: children,
    );
  }
}
