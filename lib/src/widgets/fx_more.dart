// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'package:bangla_pdf_fixer/bangla_pdf_fixer.dart';

/// Bangla Bullet List
class BanglaBulletList extends pw.StatelessWidget {
  final List<String> items;
  final double fontSize;
  final pw.FontWeight fontWeight;
  final BanglaFontType fontType;
  final pw.PdfColor color;
  final String bullet;

  BanglaBulletList({
    required this.items,
    this.fontSize = 14,
    this.fontWeight = pw.FontWeight.normal,
    this.fontType = BanglaFontType.kalpurush,
    this.color = PdfColors.black,
    this.bullet = "- ",
  });

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: items.map((item) {
        return pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              bullet,
              style: pw.TextStyle(
                // font: BanglaFontManager().getFont(fontType),
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: color,
              ),
            ),
            pw.Expanded(
              child: BanglaText(
                item,
                fontSize: fontSize,
                fontWeight: fontWeight,
                fontType: fontType,
                color: color,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

/// A reusable, customizable Bangla table widget for PDF documents.
class BanglaTable extends pw.StatelessWidget {
  final List<List<String>> data; // First row treated as header
  final double fontSize;
  final pw.FontWeight fontWeight;
  final BanglaFontType fontType;
  final pw.PdfColor headerColor;
  final pw.TextAlign headerAlignment;
  final pw.PdfColor borderColor;
  final pw.Alignment cellAlignment;
  final pw.EdgeInsets cellPadding;
  final Map<int, pw.TableColumnWidth>? columnWidths;

  BanglaTable({
    required this.data,
    this.fontSize = 14,
    this.fontWeight = pw.FontWeight.normal,
    this.fontType = BanglaFontType.kalpurush,
    this.headerColor = PdfColors.grey300,
    this.borderColor = PdfColors.grey,
    this.cellAlignment = pw.Alignment.centerLeft,
    this.cellPadding = const pw.EdgeInsets.all(6),
    this.columnWidths,
    this.headerAlignment = pw.TextAlign.center,
  });

  @override
  pw.Widget build(pw.Context context) {
    if (data.isEmpty) return pw.Container();

    final font = BanglaFontManager().getFont(fontType);

    // Build header row
    final headerRow = pw.TableRow(
      decoration: pw.BoxDecoration(color: headerColor),
      children: data.first.map((text) {
        return pw.Padding(
          padding: cellPadding,
          child: pw.Text(
            text.fix,
            textAlign: headerAlignment,
            style: pw.TextStyle(
                font: font, fontSize: fontSize, fontWeight: pw.FontWeight.bold),
          ),
        );
      }).toList(),
    );

    // Build body rows
    final bodyRows = data.sublist(1).map((row) {
      return pw.TableRow(
        children: row.map((text) {
          return pw.Padding(
            padding: cellPadding,
            child: pw.Align(
              alignment: cellAlignment,
              child: pw.Text(
                text.fix,
                style: pw.TextStyle(
                    font: font, fontSize: fontSize, fontWeight: fontWeight),
              ),
            ),
          );
        }).toList(),
      );
    }).toList();

    return pw.Table(
      border: pw.TableBorder.all(color: borderColor),
      defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
      columnWidths: columnWidths,
      children: [headerRow, ...bodyRows],
    );
  }
}
