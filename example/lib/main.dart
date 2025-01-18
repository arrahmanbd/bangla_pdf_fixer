import 'package:bangla_pdf_fixer/bangla_pdf_fixer.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF Invoice Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PdfInvoiceDemo(),
    );
  }
}

///
/// PDF Demo Code
///

class PdfInvoiceDemo extends StatelessWidget {
  const PdfInvoiceDemo({super.key});

  Future<void> generateAndOpenInvoice() async {
    // 1. Create a PDF document
    final pdf = pw.Document();
    // 2. Set Bangla Font for pdf
    final loadFont = await FontManager.loadFont(GetFonts.kalpurush);
    final useFont = pw.Font.ttf(loadFont);
    // 2. Add content to the PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('INVOICE',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                )),
            pw.SizedBox(height: 20),
            pw.Text('গ্রাহকের নাম: হিমু'.fix(),
                style: pw.TextStyle(font: useFont)),
            pw.Text('চালান নম্বর: #12345'.fix(),
                style: pw.TextStyle(font: useFont)),
            pw.Text('তারিখঃ ${DateTime.now().toLocal()}'.fix(),
                style: pw.TextStyle(font: useFont)),
            pw.SizedBox(height: 20),
            pw.Table(
              defaultVerticalAlignment:pw.TableCellVerticalAlignment.middle,
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  verticalAlignment: pw.TableCellVerticalAlignment.middle,
                  children: [
                    pw.Text(
                      'পণ্য'.fix(),
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, font: useFont),
                    ),
                    pw.Text('পরিমাণ'.fix(),
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, font: useFont)),
                    pw.Text('মূল্য'.fix(),
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, font: useFont)),
                    pw.Text('মোট'.fix(),
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, font: useFont)),
                  ],
                ),
                ...[
                  ['কফি', '2', '\$10', '\$20'],
                  ['চা', '1', '\$15', '\$15'],
                  ['স্বর্ণপত্র', '3', '\$5', '\$15'],
                ].map(
                  (item) => pw.TableRow(
                    verticalAlignment: pw.TableCellVerticalAlignment.middle,
                    children: item
                        .map(
                          (cell) => pw.Text(cell.fix(),
                              style: pw.TextStyle(
                                font: useFont,
                              )),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text('মোট \$50'.fix(),
                style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                    font: useFont)),
          ],
        ),
      ),
    );

    // 3. Save the PDF to a file
    final outputDir = await getTemporaryDirectory();
    final filePath = '${outputDir.path}/invoice.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    // 4. Open the PDF file
    OpenFile.open(filePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'ইনভয়েস তৈরী করুণ ',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          onPressed: generateAndOpenInvoice,
          child: const Text('তৈরী করে দেখুন ',
              style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
