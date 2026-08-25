import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf_text_shaper/pdf_text_shaper.dart';

import 'bangla_text.dart';

/// A table whose cells use HarfBuzz-shaped Unicode text.
final class BanglaTable extends pw.StatelessWidget {
  BanglaTable({
    required this.data,
    required this.font,
    this.headerFont,
    this.fallbackFonts = const <ShapedFont>[],
    this.headerFallbackFonts,
    this.fontSize = 11,
    this.headerFontSize = 11,
    this.lineHeight = 1.2,
    this.headerLineHeight = 1.2,
    this.cellPadding = const pw.EdgeInsets.all(6),
    this.headerColor,
    this.alternateRowColor,
    this.textColor = PdfColors.black,
    this.headerTextColor = PdfColors.black,
    this.headerAlignment = pw.Alignment.center,
    this.cellAlignment = pw.Alignment.centerLeft,
    this.textAlign = ShapedTextAlign.start,
    this.headerTextAlign = ShapedTextAlign.start,
    this.borderColor = PdfColors.grey400,
    this.borderWidth = 1,
    this.columnWidths,
    this.headerRows = 1,
    this.repeatHeaderRows = true,
    this.preserveUnicodeText = true,
  }) : assert(headerRows >= 0),
       assert(borderWidth >= 0);

  BanglaTable.fromRows({
    required List<String> headers,
    required List<List<String>> rows,
    required this.font,
    this.headerFont,
    this.fallbackFonts = const <ShapedFont>[],
    this.headerFallbackFonts,
    this.fontSize = 11,
    this.headerFontSize = 11,
    this.lineHeight = 1.2,
    this.headerLineHeight = 1.2,
    this.cellPadding = const pw.EdgeInsets.all(6),
    this.headerColor,
    this.alternateRowColor,
    this.textColor = PdfColors.black,
    this.headerTextColor = PdfColors.black,
    this.headerAlignment = pw.Alignment.center,
    this.cellAlignment = pw.Alignment.centerLeft,
    this.textAlign = ShapedTextAlign.start,
    this.headerTextAlign = ShapedTextAlign.start,
    this.borderColor = PdfColors.grey400,
    this.borderWidth = 1,
    this.columnWidths,
    this.repeatHeaderRows = true,
    this.preserveUnicodeText = true,
  }) : data = <List<String>>[headers, ...rows],
       headerRows = headers.isEmpty ? 0 : 1,
       assert(borderWidth >= 0);

  /// Table rows. By default the first row is styled as a header.
  final List<List<String>> data;
  final ShapedFont font;
  final ShapedFont? headerFont;
  final List<ShapedFont> fallbackFonts;
  final List<ShapedFont>? headerFallbackFonts;

  final double fontSize;
  final double headerFontSize;
  final double lineHeight;
  final double headerLineHeight;
  final pw.EdgeInsets cellPadding;

  /// Header row background.
  final PdfColor? headerColor;

  /// Background used for every second non-header row.
  final PdfColor? alternateRowColor;

  final PdfColor textColor;
  final PdfColor headerTextColor;
  final pw.Alignment headerAlignment;
  final pw.Alignment cellAlignment;
  final ShapedTextAlign textAlign;
  final ShapedTextAlign headerTextAlign;
  final PdfColor borderColor;
  final double borderWidth;
  final Map<int, pw.TableColumnWidth>? columnWidths;
  final int headerRows;
  final bool repeatHeaderRows;
  final bool preserveUnicodeText;

  @override
  pw.Widget build(pw.Context context) {
    if (data.isEmpty) {
      return pw.SizedBox.shrink();
    }

    final columnCount = data.first.length;
    if (columnCount == 0) {
      return pw.SizedBox.shrink();
    }

    if (headerRows > data.length) {
      throw ArgumentError.value(
        headerRows,
        'headerRows',
        'Cannot exceed the number of table rows (${data.length}).',
      );
    }

    if (data.any((row) => row.length != columnCount)) {
      throw ArgumentError(
        'Every BanglaTable row must contain exactly $columnCount cells.',
      );
    }

    return pw.Table(
      columnWidths: columnWidths,
      border: pw.TableBorder.all(color: borderColor, width: borderWidth),
      children: [
        for (var rowIndex = 0; rowIndex < data.length; rowIndex++)
          _buildRow(rowIndex),
      ],
    );
  }

  pw.TableRow _buildRow(int rowIndex) {
    final isHeader = rowIndex < headerRows;
    final bodyIndex = rowIndex - headerRows;
    final useAlternate =
        !isHeader && alternateRowColor != null && bodyIndex.isOdd;

    return pw.TableRow(
      repeat: isHeader && repeatHeaderRows,
      decoration: isHeader && headerColor != null
          ? pw.BoxDecoration(color: headerColor)
          : useAlternate
          ? pw.BoxDecoration(color: alternateRowColor)
          : null,
      children: [
        for (final value in data[rowIndex])
          _cell(
            value,
            font: isHeader ? headerFont ?? font : font,
            fallbackFonts: isHeader
                ? headerFallbackFonts ?? fallbackFonts
                : fallbackFonts,
            size: isHeader ? headerFontSize : fontSize,
            color: isHeader ? headerTextColor : textColor,
            lineHeight: isHeader ? headerLineHeight : this.lineHeight,
            alignment: isHeader ? headerAlignment : cellAlignment,
            textAlign: isHeader ? headerTextAlign : this.textAlign,
          ),
      ],
    );
  }

  pw.Widget _cell(
    String value, {
    required ShapedFont font,
    required List<ShapedFont> fallbackFonts,
    required double size,
    required PdfColor color,
    required double lineHeight,
    required pw.Alignment alignment,
    required ShapedTextAlign textAlign,
  }) {
    return pw.Container(
      alignment: alignment,
      padding: cellPadding,
      child: BanglaText(
        value,
        font: font,
        fallbackFonts: fallbackFonts,
        fontSize: size,
        color: color,
        lineHeight: lineHeight,
        align: textAlign,
        preserveUnicodeText: preserveUnicodeText,
      ),
    );
  }
}
