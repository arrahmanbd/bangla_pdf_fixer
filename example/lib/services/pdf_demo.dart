import 'dart:io';
import 'package:bangla_pdf_fixer/bangla_pdf_fixer.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfDemoData {
  /// Generates a professional invoice PDF and opens it
  static Future<void> generateAndOpenInvoice() async {
    final pdf = pw.Document();

    // Load Bangla fonts
    final julyFont = pw.Font.ttf(await FontManager.loadFont(GetFonts.july));
    final kalpurushFont =
        pw.Font.ttf(await FontManager.loadFont(GetFonts.kalpurush));

    // Dummy data
    const customerName = 'হিমু';
    const invoiceNumber = '#12345';
    final date = DateTime.now();

    // Invoice table data
    // Example product data
    final products = [
      ['কফি', '2', '\$12.50', '\$25.00'],
      ['চা', '1', '\$15.00', '\$15.00'],
      ['বিস্কুট', '5', '\$2.00', '\$10.00'],
      ['দুধ', '3', '\$4.50', '\$13.50'],
      ['জুস', '2', '\$6.00', '\$12.00'],
      ['স্যান্ডউইচ', '4', '\$5.50', '\$22.00'],
      ['স্বর্ণপত্র', '3', '\$5.00', '\$15.00'],
      ['চকলেট', '6', '\$3.00', '\$18.00'],
      ['পনির', '2', '\$7.50', '\$15.00'],
      ['সুপ', '1', '\$8.00', '\$8.00'],
    ];

    // Add content to PDF
    pdf.addPage(
      pw.Page(
        build: (_) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('INVOICE',
                style: pw.TextStyle(
                  // font: julyFont,
                  fontSize: 28,
                  fontWeight: pw.FontWeight.bold,
                )),
            pw.SizedBox(height: 20),
            pw.Text('গ্রাহকের নাম: $customerName'.fix(),
                style: pw.TextStyle(font: julyFont)),
            pw.Text('চালান নম্বর: $invoiceNumber'.fix(),
                style: pw.TextStyle(font: kalpurushFont)),
            pw.Text('তারিখ: ${date.toLocal()}'.fix(),
                style: pw.TextStyle(font: kalpurushFont)),
            pw.SizedBox(height: 20),
            _buildTable(products, kalpurushFont),
            pw.SizedBox(height: 20),
            pw.Text('মোট \$50'.fix(),
                style: pw.TextStyle(
                  font: kalpurushFont,
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                )),

            pw.Divider(color: PdfColors.grey, thickness: 1),
            pw.SizedBox(height: 10),

            // Subtotal & Tax
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      children: [
                        pw.Text('উপ-মোট: '.fix(),
                            style: pw.TextStyle(font: kalpurushFont)),
                        pw.Text('\$148.50',
                            style: pw.TextStyle(font: kalpurushFont)),
                      ],
                    ),
                    pw.Row(
                      children: [
                        pw.Text('ট্যাক্স (5%): '.fix(),
                            style: pw.TextStyle(font: kalpurushFont)),
                        pw.Text('\$7.43',
                            style: pw.TextStyle(font: kalpurushFont)),
                      ],
                    ),
                    pw.Row(
                      children: [
                        pw.Text('মোট: '.fix(),
                            style: pw.TextStyle(
                                font: kalpurushFont,
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold)),
                        pw.Text('\$155.93',
                            style: pw.TextStyle(
                                font: kalpurushFont,
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            pw.SizedBox(height: 20),

            // Notes
            pw.Text(
                'নোট: অনুগ্রহ করে বিলটি পরবর্তী 7 দিনের মধ্যে পরিশোধ করুন।'
                    .fix(),
                style: pw.TextStyle(
                    font: kalpurushFont,
                    fontSize: 12,
                    color: PdfColors.grey700)),

            pw.SizedBox(height: 30),

            // Signature placeholders
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  children: [
                    pw.Text('গ্রাহকের স্বাক্ষর'.fix(),
                        style: pw.TextStyle(font: kalpurushFont)),
                    pw.SizedBox(height: 40),
                    pw.Container(width: 150, height: 1, color: PdfColors.black),
                  ],
                ),
                pw.Column(
                  children: [
                    pw.Text('প্রদানকারী স্বাক্ষর'.fix(),
                        style: pw.TextStyle(font: kalpurushFont)),
                    pw.SizedBox(height: 40),
                    pw.Container(width: 150, height: 1, color: PdfColors.black),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );

    // Save and open
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/invoice.pdf');
    await file.writeAsBytes(await pdf.save());
    await OpenFile.open(file.path);
  }

  /// Helper: Build invoice table
  static pw.Widget _buildTable(List<List<String>> rows, pw.Font font) {
    return pw.Table(
      border: pw.TableBorder.all(width: 1),
      defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: ['পণ্য', 'পরিমাণ', 'মূল্য', 'মোট']
              .map((title) => pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Text(title.fix(),
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, font: font)),
                  ))
              .toList(),
        ),
        ...rows.map(
          (cells) => pw.TableRow(
            children: cells
                .map((text) => pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child:
                          pw.Text(text.fix(), style: pw.TextStyle(font: font)),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
