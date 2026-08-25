import 'dart:io';

import 'package:bangla_pdf_fixer/bangla_pdf_fixer.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

void main() {
  runApp(const PdfTestApp());
}

class PdfTestApp extends StatelessWidget {
  const PdfTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const PdfTestPage(),
    );
  }
}

class PdfTestPage extends StatefulWidget {
  const PdfTestPage({super.key});

  @override
  State<PdfTestPage> createState() => _PdfTestPageState();
}

class _PdfTestPageState extends State<PdfTestPage> {
  bool _generating = false;
  String? _result;

  Future<void> _generatePdf() async {
    setState(() {
      _generating = true;
      _result = null;
    });

    try {
      final fonts = await _loadFonts();

      final document = pw.Document(
        title: 'Bangla PDF Fixer Test Report',
        author: 'ardevcraft',
        subject: 'Unicode Bangla PDF shaping test',
        creator: 'bangla_pdf_fixer + pdf_text_shaper',
      );

      document.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.fromLTRB(36, 42, 36, 42),

          header: (context) {
            return _DocumentHeader(
              fonts: fonts,
              pageNumber: context.pageNumber,
            );
          },

          footer: (context) {
            return _DocumentFooter(
              fonts: fonts,
              pageNumber: context.pageNumber,
              pagesCount: context.pagesCount,
            );
          },

          build: (context) {
            return [
              _HeroSection(fonts: fonts),

              pw.SizedBox(height: 22),

              _StudentInformation(fonts: fonts),

              pw.SizedBox(height: 24),

              _SectionTitle(
                fonts: fonts,
                title: 'শিক্ষার্থীর ফলাফল',
                subtitle: 'Academic Result',
              ),

              pw.SizedBox(height: 10),

              _ResultTable(fonts: fonts),

              pw.SizedBox(height: 24),

              _SectionTitle(
                fonts: fonts,
                title: 'শিক্ষকের মন্তব্য',
                subtitle: 'Teacher Remarks',
              ),

              pw.SizedBox(height: 10),

              _RemarksCard(fonts: fonts),

              pw.SizedBox(height: 24),

              _SectionTitle(
                fonts: fonts,
                title: 'যুক্তাক্ষর ও ইউনিকোড পরীক্ষা',
                subtitle: 'Complex Shaping Test',
              ),

              pw.SizedBox(height: 10),

              _UnicodeTestSection(fonts: fonts),

              pw.SizedBox(height: 24),

              _SectionTitle(
                fonts: fonts,
                title: 'মিশ্র ভাষা পরীক্ষা',
                subtitle: 'Mixed Script Test',
              ),

              pw.SizedBox(height: 10),

              _MixedLanguageSection(fonts: fonts),

              pw.SizedBox(height: 24),

              _SectionTitle(
                fonts: fonts,
                title: 'আর্থিক সারসংক্ষেপ',
                subtitle: 'Payment Summary',
              ),

              pw.SizedBox(height: 10),

              _PaymentSummary(fonts: fonts),

              pw.SizedBox(height: 24),

              _SearchCopyTest(fonts: fonts),
            ];
          },
        ),
      );

      final bytes = await document.save();

      final file = File(
        '${Directory.systemTemp.path}/bangla_pdf_fixer_full_test.pdf',
      );

      await file.writeAsBytes(bytes, flush: true);

      debugPrint('PDF GENERATED: ${file.path}');

      if (Platform.isMacOS) {
        await Process.run('open', [file.path]);
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _result = file.path;
      });
    } catch (error, stackTrace) {
      debugPrint('PDF ERROR: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) {
        return;
      }

      setState(() {
        _result = 'ERROR: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _generating = false;
        });
      }
    }
  }

  Future<_PdfFonts> _loadFonts() async {
    final banglaRegular = await BanglaFontManager.instance.loadAsset(
      'assets/fonts/NotoSansBengali-Regular.ttf',
      name: 'Noto Sans Bengali Regular',
    );

    final banglaBold = await BanglaFontManager.instance.loadAsset(
      'assets/fonts/NotoSansBengali-Bold.ttf',
      name: 'Noto Sans Bengali Bold',
    );

    final latinRegular = await BanglaFontManager.instance.loadAsset(
      'assets/fonts/NotoSans-Regular.ttf',
      name: 'Noto Sans Regular',
    );

    final latinBold = await BanglaFontManager.instance.loadAsset(
      'assets/fonts/NotoSans-Bold.ttf',
      name: 'Noto Sans Bold',
    );

    return _PdfFonts(
      banglaRegular: banglaRegular,
      banglaBold: banglaBold,
      latinRegular: latinRegular,
      latinBold: latinBold,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bangla PDF Fixer')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FilledButton.icon(
                onPressed: _generating ? null : _generatePdf,
                icon: _generating
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.picture_as_pdf_outlined),
                label: Text(
                  _generating ? 'Generating PDF...' : 'Generate Full Test PDF',
                ),
              ),

              if (_result != null) ...[
                const SizedBox(height: 24),
                SelectableText(_result!, textAlign: TextAlign.center),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PdfFonts {
  const _PdfFonts({
    required this.banglaRegular,
    required this.banglaBold,
    required this.latinRegular,
    required this.latinBold,
  });

  final ShapedFont banglaRegular;
  final ShapedFont banglaBold;

  final ShapedFont latinRegular;
  final ShapedFont latinBold;

  List<ShapedFont> get regularFallbacks => [latinRegular];

  List<ShapedFont> get boldFallbacks => [latinBold];

  List<ShapedFont> get latinRegularFallbacks => [banglaRegular];

  List<ShapedFont> get latinBoldFallbacks => [banglaBold];
}

class _DocumentHeader extends pw.StatelessWidget {
  _DocumentHeader({required this.fonts, required this.pageNumber});

  final _PdfFonts fonts;
  final int pageNumber;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 8),
      margin: const pw.EdgeInsets.only(bottom: 14),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          BanglaText(
            'শিক্ষার্থী প্রতিবেদন',
            style: ShapedTextStyle(
              font: fonts.banglaBold,
              fallbackFonts: fonts.boldFallbacks,
              fontSize: 10,
              color: PdfColors.grey700,
            ),
          ),
          BanglaText(
            'Student Report • Page $pageNumber',
            style: ShapedTextStyle(
              font: fonts.latinRegular,
              fallbackFonts: fonts.latinRegularFallbacks,
              fontSize: 9,
              color: PdfColors.grey600,
            ),
          ),
        ],
      ),
    );
  }
}

class _DocumentFooter extends pw.StatelessWidget {
  _DocumentFooter({
    required this.fonts,
    required this.pageNumber,
    required this.pagesCount,
  });

  final _PdfFonts fonts;
  final int pageNumber;
  final int pagesCount;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 14),
      padding: const pw.EdgeInsets.only(top: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: PdfColors.grey300)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          BanglaText(
            'bangla_pdf_fixer • pdf_text_shaper',
            style: ShapedTextStyle(
              font: fonts.latinRegular,
              fallbackFonts: fonts.latinRegularFallbacks,
              fontSize: 8,
              color: PdfColors.grey600,
            ),
          ),
          BanglaText(
            '$pageNumber / $pagesCount',
            style: ShapedTextStyle(
              font: fonts.latinRegular,
              fallbackFonts: fonts.latinRegularFallbacks,
              fontSize: 8,
              color: PdfColors.grey600,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSection extends pw.StatelessWidget {
  _HeroSection({required this.fonts});

  final _PdfFonts fonts;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: PdfColors.blueGrey50,
        borderRadius: pw.BorderRadius.circular(10),
        border: pw.Border.all(color: PdfColors.blueGrey100),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          BanglaText(
            'শিক্ষার্থী একাডেমিক প্রতিবেদন',
            style: ShapedTextStyle(
              font: fonts.banglaBold,
              fallbackFonts: fonts.boldFallbacks,
              fontSize: 25,
              color: PdfColors.blueGrey900,
            ),
          ),

          pw.SizedBox(height: 6),

          BanglaText(
            'Student Academic Performance Report',
            style: ShapedTextStyle(
              font: fonts.latinRegular,
              fallbackFonts: fonts.latinRegularFallbacks,
              fontSize: 11,
              color: PdfColors.blueGrey600,
            ),
          ),

          pw.SizedBox(height: 14),

          BanglaText(
            '২০২৬ শিক্ষাবর্ষ • Academic Session 2026',
            style: ShapedTextStyle(
              font: fonts.banglaRegular,
              fallbackFonts: fonts.regularFallbacks,
              fontSize: 11,
              color: PdfColors.blueGrey700,
            ),
          ),
        ],
      ),
    );
  }
}

class _StudentInformation extends pw.StatelessWidget {
  _StudentInformation({required this.fonts});

  final _PdfFonts fonts;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        children: [
          _InfoRow(
            fonts: fonts,
            banglaLabel: 'শিক্ষার্থীর নাম',
            englishLabel: 'Student',
            value: 'আরিফ রহমান • Arif Rahman',
          ),
          _divider(),
          _InfoRow(
            fonts: fonts,
            banglaLabel: 'শ্রেণি',
            englishLabel: 'Class',
            value: 'দশম • Class 10',
          ),
          _divider(),
          _InfoRow(
            fonts: fonts,
            banglaLabel: 'রোল',
            englishLabel: 'Roll',
            value: '১২ • 12',
          ),
          _divider(),
          _InfoRow(
            fonts: fonts,
            banglaLabel: 'শাখা',
            englishLabel: 'Section',
            value: 'ক • A',
          ),
        ],
      ),
    );
  }

  pw.Widget _divider() {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 8),
      child: pw.Divider(color: PdfColors.grey200),
    );
  }
}

class _InfoRow extends pw.StatelessWidget {
  _InfoRow({
    required this.fonts,
    required this.banglaLabel,
    required this.englishLabel,
    required this.value,
  });

  final _PdfFonts fonts;
  final String banglaLabel;
  final String englishLabel;
  final String value;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          width: 135,
          child: BanglaText(
            '$banglaLabel • $englishLabel',
            style: ShapedTextStyle(
              font: fonts.banglaBold,
              fallbackFonts: fonts.boldFallbacks,
              fontSize: 10,
              color: PdfColors.grey700,
            ),
          ),
        ),

        pw.Expanded(
          child: BanglaText(
            value,
            style: ShapedTextStyle(
              font: fonts.banglaRegular,
              fallbackFonts: fonts.regularFallbacks,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends pw.StatelessWidget {
  _SectionTitle({
    required this.fonts,
    required this.title,
    required this.subtitle,
  });

  final _PdfFonts fonts;
  final String title;
  final String subtitle;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Container(
          width: 4,
          height: 28,
          decoration: pw.BoxDecoration(
            color: PdfColors.indigo600,
            borderRadius: pw.BorderRadius.circular(2),
          ),
        ),

        pw.SizedBox(width: 9),

        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            BanglaText(
              title,
              style: ShapedTextStyle(
                font: fonts.banglaBold,
                fallbackFonts: fonts.boldFallbacks,
                fontSize: 16,
              ),
            ),
            BanglaText(
              subtitle,
              style: ShapedTextStyle(
                font: fonts.latinRegular,
                fallbackFonts: fonts.latinRegularFallbacks,
                fontSize: 8,
                color: PdfColors.grey600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ResultTable extends pw.StatelessWidget {
  _ResultTable({required this.fonts});

  final _PdfFonts fonts;

  static const _rows = [
    ['বাংলা', 'Bangla', '৮৮', 'A+'],
    ['ইংরেজি', 'English', '৮৪', 'A+'],
    ['গণিত', 'Mathematics', '৯৫', 'A+'],
    ['বিজ্ঞান', 'Science', '৯০', 'A+'],
    ['তথ্য প্রযুক্তি', 'ICT', '৮৭', 'A+'],
  ];

  @override
  pw.Widget build(pw.Context context) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.7),
      columnWidths: const {
        0: pw.FlexColumnWidth(2.2),
        1: pw.FlexColumnWidth(1.6),
        2: pw.FlexColumnWidth(0.8),
        3: pw.FlexColumnWidth(0.7),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.blueGrey50),
          children: [
            _headerCell(
              'বিষয়',
              font: fonts.banglaBold,
              fallbackFonts: fonts.boldFallbacks,
            ),
            _headerCell(
              'Subject',
              font: fonts.latinBold,
              fallbackFonts: fonts.latinBoldFallbacks,
            ),
            _headerCell(
              'নম্বর',
              font: fonts.banglaBold,
              fallbackFonts: fonts.boldFallbacks,
            ),
            _headerCell(
              'Grade',
              font: fonts.latinBold,
              fallbackFonts: fonts.latinBoldFallbacks,
            ),
          ],
        ),

        for (final row in _rows)
          pw.TableRow(
            children: [
              _cell(
                row[0],
                font: fonts.banglaRegular,
                fallbackFonts: fonts.regularFallbacks,
              ),
              _cell(
                row[1],
                font: fonts.latinRegular,
                fallbackFonts: fonts.latinRegularFallbacks,
              ),
              _cell(
                row[2],
                font: fonts.banglaRegular,
                fallbackFonts: fonts.regularFallbacks,
              ),
              _cell(
                row[3],
                font: fonts.latinBold,
                fallbackFonts: fonts.latinBoldFallbacks,
              ),
            ],
          ),
      ],
    );
  }

  pw.Widget _headerCell(
    String value, {
    required ShapedFont font,
    required List<ShapedFont> fallbackFonts,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: BanglaText(
        value,
        style: ShapedTextStyle(
          font: font,
          fallbackFonts: fallbackFonts,
          fontSize: 10,
        ),
      ),
    );
  }

  pw.Widget _cell(
    String value, {
    required ShapedFont font,
    required List<ShapedFont> fallbackFonts,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: BanglaText(
        value,
        style: ShapedTextStyle(
          font: font,
          fallbackFonts: fallbackFonts,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _RemarksCard extends pw.StatelessWidget {
  _RemarksCard({required this.fonts});

  final _PdfFonts fonts;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        color: PdfColors.green50,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: PdfColors.green100),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          BanglaText(
            'খুব ভালো অগ্রগতি',
            style: ShapedTextStyle(
              font: fonts.banglaBold,
              fallbackFonts: fonts.boldFallbacks,
              fontSize: 14,
              color: PdfColors.green900,
            ),
          ),

          pw.SizedBox(height: 6),

          BanglaText(
            'শিক্ষার্থী নিয়মিত পড়াশোনা করছে এবং গণিত ও বিজ্ঞানে '
            'বিশেষ দক্ষতা প্রদর্শন করেছে। ভবিষ্যতে লেখার মান এবং '
            'সময় ব্যবস্থাপনার দিকে আরও মনোযোগ দেওয়া প্রয়োজন।',
            style: ShapedTextStyle(
              font: fonts.banglaRegular,
              fallbackFonts: fonts.regularFallbacks,
              fontSize: 11,
              lineHeight: 1.35,
              color: PdfColors.green900,
            ),
          ),
        ],
      ),
    );
  }
}

class _UnicodeTestSection extends pw.StatelessWidget {
  _UnicodeTestSection({required this.fonts});

  final _PdfFonts fonts;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: BanglaText(
        'বাংলাদেশ • শিক্ষার্থী • রাষ্ট্র • প্রজ্ঞাপন • ক্ষুদ্র • '
        'দায়িত্ব • যুক্তরাষ্ট্র • শ্রেণি • কার্যক্রম • স্বাধীনতা • '
        'প্রশ্নপত্র • কর্তৃপক্ষ • সংস্কৃতি • সম্পূর্ণ • প্রযুক্তি',
        style: ShapedTextStyle(
          font: fonts.banglaRegular,
          fallbackFonts: fonts.regularFallbacks,
          fontSize: 15,
          lineHeight: 1.45,
          preserveUnicodeText: true,
        ),
      ),
    );
  }
}

class _MixedLanguageSection extends pw.StatelessWidget {
  _MixedLanguageSection({required this.fonts});

  final _PdfFonts fonts;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        BanglaText(
          'Student: আরিফ রহমান — Class 10 — Roll 12 — Result A+',
          style: ShapedTextStyle(
            font: fonts.banglaRegular,
            fallbackFonts: fonts.regularFallbacks,
            fontSize: 12,
          ),
        ),

        pw.SizedBox(height: 8),

        BanglaText(
          'Report Status: প্রকাশিত • Session: 2026 • '
          'Generated with pdf_text_shaper',
          style: ShapedTextStyle(
            font: fonts.latinRegular,
            fallbackFonts: fonts.latinRegularFallbacks,
            fontSize: 11,
          ),
        ),

        pw.SizedBox(height: 8),

        BanglaText(
          'বাংলা PDF rendering + Unicode search + HarfBuzz shaping',
          style: ShapedTextStyle(
            font: fonts.banglaBold,
            fallbackFonts: fonts.boldFallbacks,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _PaymentSummary extends pw.StatelessWidget {
  _PaymentSummary({required this.fonts});

  final _PdfFonts fonts;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Row(
      children: [
        pw.Expanded(
          child: _SummaryCard(
            fonts: fonts,
            label: 'মোট ফি',
            latinLabel: 'Total Fee',
            value: '৳২৫,০০০',
          ),
        ),
        pw.SizedBox(width: 10),
        pw.Expanded(
          child: _SummaryCard(
            fonts: fonts,
            label: 'পরিশোধিত',
            latinLabel: 'Paid',
            value: '৳২০,০০০',
          ),
        ),
        pw.SizedBox(width: 10),
        pw.Expanded(
          child: _SummaryCard(
            fonts: fonts,
            label: 'বকেয়া',
            latinLabel: 'Due',
            value: '৳৫,০০০',
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends pw.StatelessWidget {
  _SummaryCard({
    required this.fonts,
    required this.label,
    required this.latinLabel,
    required this.value,
  });

  final _PdfFonts fonts;
  final String label;
  final String latinLabel;
  final String value;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(7),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          BanglaText(
            label,
            style: ShapedTextStyle(
              font: fonts.banglaRegular,
              fallbackFonts: fonts.regularFallbacks,
              fontSize: 10,
              color: PdfColors.grey700,
            ),
          ),
          BanglaText(
            latinLabel,
            style: ShapedTextStyle(
              font: fonts.latinRegular,
              fallbackFonts: fonts.latinRegularFallbacks,
              fontSize: 7,
              color: PdfColors.grey500,
            ),
          ),
          pw.SizedBox(height: 6),
          BanglaText(
            value,
            style: ShapedTextStyle(
              font: fonts.banglaBold,
              fallbackFonts: fonts.boldFallbacks,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchCopyTest extends pw.StatelessWidget {
  _SearchCopyTest({required this.fonts});

  final _PdfFonts fonts;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        color: PdfColors.amber50,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: PdfColors.amber200),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          BanglaText(
            'কপি ও সার্চ পরীক্ষা',
            style: ShapedTextStyle(
              font: fonts.banglaBold,
              fallbackFonts: fonts.boldFallbacks,
              fontSize: 13,
            ),
          ),

          pw.SizedBox(height: 6),

          BanglaText(
            'এই বাক্য থেকে “প্রজ্ঞাপন” এবং “শিক্ষার্থী” শব্দ দুটি '
            'পিডিএফ ভিউয়ারে সার্চ করুন। এরপর সম্পূর্ণ বাক্যটি কপি করে '
            'টেক্সট এডিটরে পেস্ট করুন। মূল বাংলা ইউনিকোড অক্ষত থাকা উচিত।',
            style: ShapedTextStyle(
              font: fonts.banglaRegular,
              fallbackFonts: fonts.regularFallbacks,
              fontSize: 11,
              lineHeight: 1.4,
              preserveUnicodeText: true,
            ),
          ),
        ],
      ),
    );
  }
}
