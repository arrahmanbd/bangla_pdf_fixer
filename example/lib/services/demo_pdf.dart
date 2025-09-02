import 'package:bangla_pdf_fixer/bangla_pdf_fixer.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Service class for generating Bangla PDFs.
class BanglaPdfService {
  /// Generates a sample PDF document demonstrating all Bangla widgets.
  ///
  /// Features included:
  /// - BanglaText
  /// - BanglaRichText
  /// - BanglaHeader
  /// - BanglaParagraph
  /// - BanglaBulletList
  /// - BanglaTable
  ///
  /// Returns a [pw.Document] that can be saved or previewed.
  static Future<pw.Document> generateSamplePdf() async {
    // Initialize all Bangla fonts
    await BanglaFontManager().initialize();

    final pdf = pw.Document();

    // Sample table data for BanglaTable
    final tableData = [
      ['পণ্য', 'পরিমাণ', 'মূল্য', 'মোট'], // Header
      ['কফি', '2', '\$10', '\$20'],
      ['চা', '1', '\$15', '\$15'],
      ['বিস্কুট', '3', '\$5', '\$15'],
      ['মোট', '', '', '\$50'], // Footer
    ];

    // Add a page to the PDF
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            /// Custom text using BanglaFontManager directly
            pw.Text(
              'বাংলা'.fix,
              style: pw.TextStyle(
                fontSize: 24,
                font: BanglaFontManager().getFont(BanglaFontType.redJuly),
              ),
            ),

            /// Simple Bangla text
            BanglaText(
              'বাংলা সাধারণ টেক্সট',
              fontType: BanglaFontType.kalpurush,
              fontSize: 20,
            ),

            pw.SizedBox(height: 20),

            /// Bangla rich text with multiple fonts and styles
            BanglaRichText(
              spans: [
                BanglaTextSpan(
                  'বাংলা বোল্ড ',
                  fontType: BanglaFontType.openSans,
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 20,
                  color: PdfColors.red,
                ),
                BanglaTextSpan(
                  'এবং ইটালিক',
                  fontType: BanglaFontType.julyItalic,
                  fontSize: 18,
                  color: PdfColors.blue,
                ),
              ],
            ),

            pw.SizedBox(height: 20),

            /// Bangla header
            BanglaHeader('বাংলা শিরোনাম'),
            pw.SizedBox(height: 10),

            /// Bangla paragraph
            BanglaParagraph('বাংলা অনুচ্ছেদ এখানে লেখা হবে।'),

            pw.SizedBox(height: 20),

            /// Another rich text example
            BanglaRichText(
              spans: [
                BanglaTextSpan('বাংলা বোল্ড ', fontWeight: pw.FontWeight.bold),
                BanglaTextSpan(
                  'এবং ইটালিক',
                  fontType: BanglaFontType.julyItalic,
                ),
              ],
            ),

            /// Bangla bullet list
            BanglaHeader('বাংলা বুলেট লিস্ট'),
            pw.SizedBox(height: 10),
            BanglaBulletList(
              items: [
                'প্রথম আইটেম',
                'দ্বিতীয় আইটেম',
                'তৃতীয় আইটেম',
              ],
            ),

            pw.SizedBox(height: 20),

            /// Bangla table
            BanglaHeader('বাংলা টেবিল'),
            pw.SizedBox(height: 10),
            BanglaTable(
              data: tableData,
              fontType: BanglaFontType.tomalicca,
              fontSize: 16,
              fontWeight: pw.FontWeight.normal,
              headerColor: PdfColors.blue,
              borderColor: PdfColors.grey200,
              cellAlignment: pw.Alignment.center,
              cellPadding: const pw.EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 6,
              ),
            ),
          ],
        ),
      ),
    );

    return pdf;
  }
}
