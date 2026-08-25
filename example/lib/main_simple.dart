import 'dart:io';

import 'package:bangla_pdf_fixer/bangla_pdf_fixer.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

void main() {
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Bangla PDF Fixer Test')),
        body: const Center(child: GeneratePdfButton()),
      ),
    );
  }
}

class GeneratePdfButton extends StatefulWidget {
  const GeneratePdfButton({super.key});

  @override
  State<GeneratePdfButton> createState() => _GeneratePdfButtonState();
}

class _GeneratePdfButtonState extends State<GeneratePdfButton> {
  bool _loading = false;
  String? _result;

  Future<void> _generatePdf() async {
    setState(() {
      _loading = true;
      _result = null;
    });

    try {
      final banglaFont = await BanglaFontManager.instance.loadAsset(
        'assets/fonts/NotoSansBengali-Regular.ttf',
        name: 'Noto Sans Bengali',
      );

      final latinFont = await BanglaFontManager.instance.loadAsset(
        'assets/fonts/NotoSans-Regular.ttf',
        name: 'Noto Sans',
      );

      final document = pw.Document();

      document.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (context) {
            return [
              //
              // Header
              //
              BanglaHeader(
                'বাংলা পিডিএফ ফিক্সার',
                font: banglaFont,
                fontSize: 26,
              ),

              pw.SizedBox(height: 20),

              //
              // Normal Bangla paragraph
              //
              BanglaParagraph(
                'এটি বাংলা পিডিএফ ফিক্সার ব্যবহার করে তৈরি করা একটি '
                'পরীক্ষামূলক পিডিএফ। এখানে বাংলা ইউনিকোড টেক্সট '
                'সঠিকভাবে শেপ হওয়ার কথা।',
                font: banglaFont,
                fontSize: 14,
              ),

              pw.SizedBox(height: 24),

              //
              // Complex Bangla shaping
              //
              BanglaHeader(
                'যুক্তাক্ষর পরীক্ষা',
                font: banglaFont,
                fontSize: 18,
              ),

              pw.SizedBox(height: 8),

              BanglaParagraph(
                'বাংলাদেশ শিক্ষার্থী রাষ্ট্র প্রজ্ঞাপন ক্ষুদ্র দায়িত্ব '
                'যুক্তরাষ্ট্র পরীক্ষা শ্রেণি কার্যক্রম স্বাধীনতা '
                'প্রশ্নপত্র কর্তৃপক্ষ সংস্কৃতি সম্পূর্ণ',
                font: banglaFont,
                fontSize: 16,
              ),

              pw.SizedBox(height: 24),

              //
              // Bangla numbers + currency
              //
              BanglaHeader('সংখ্যা ও মুদ্রা', font: banglaFont, fontSize: 18),

              pw.SizedBox(height: 8),

              BanglaText(
                'বাংলা সংখ্যা: ১২৩৪৫৬৭৮৯০',
                style: ShapedTextStyle(font: banglaFont, fontSize: 16),
              ),

              pw.SizedBox(height: 8),

              BanglaText(
                'মোট মূল্য: ৳১২,৫০০',
                style: ShapedTextStyle(font: banglaFont, fontSize: 16),
              ),

              pw.SizedBox(height: 24),

              //
              // Mixed Bangla + English
              //
              BanglaHeader(
                'মিশ্র ভাষা পরীক্ষা',
                font: banglaFont,
                fontSize: 18,
              ),

              pw.SizedBox(height: 8),

              BanglaText(
                'Bangla PDF Fixer 3.1 — বাংলা Unicode Text — Total ৳১২,৫০০',
                style: ShapedTextStyle(
                  font: banglaFont,
                  fallbackFonts: [latinFont],
                  fontSize: 15,
                ),
              ),

              pw.SizedBox(height: 8),

              BanglaText(
                'Student: আরিফ রহমান — Class 10 — Roll 12 — Result A+',
                style: ShapedTextStyle(
                  font: banglaFont,
                  fallbackFonts: [latinFont],
                  fontSize: 15,
                ),
              ),

              pw.SizedBox(height: 24),

              //
              // Multiline
              //
              BanglaHeader('একাধিক লাইন', font: banglaFont, fontSize: 18),

              pw.SizedBox(height: 8),

              BanglaParagraph(
                '''
প্রথম লাইন ঠিক আছে।
দ্বিতীয় লাইনও ঠিক আছে।
তৃতীয় লাইনে যুক্তাক্ষর: শিক্ষার্থী, রাষ্ট্র, প্রজ্ঞাপন।
চতুর্থ লাইনে সংখ্যা: ১২৩৪৫।
পঞ্চম লাইনে মুদ্রা: ৳৫০০।
''',
                font: banglaFont,
                fontSize: 14,
              ),

              pw.SizedBox(height: 24),

              //
              // Long wrapping paragraph
              //
              BanglaHeader(
                'লাইন মোড়ানো পরীক্ষা',
                font: banglaFont,
                fontSize: 18,
              ),

              pw.SizedBox(height: 8),

              BanglaParagraph(
                'বাংলা ভাষায় দীর্ঘ অনুচ্ছেদ লিখলে সেটি নির্ধারিত জায়গার '
                'মধ্যে স্বয়ংক্রিয়ভাবে একাধিক লাইনে ভাগ হয়ে প্রদর্শিত হওয়ার '
                'কথা। একই সঙ্গে প্রতিটি শব্দের যুক্তাক্ষর, স্বরচিহ্ন এবং '
                'অন্যান্য ইউনিকোড বৈশিষ্ট্য সঠিকভাবে সংরক্ষিত থাকবে। '
                'এই পরীক্ষাটি দীর্ঘ বাংলা অনুচ্ছেদের লাইন মোড়ানো এবং '
                'শেপিং দুটোই যাচাই করার জন্য ব্যবহার করা হচ্ছে।',
                font: banglaFont,
                fontSize: 14,
              ),

              pw.SizedBox(height: 24),

              //
              // Bullet list
              //
              BanglaHeader('বৈশিষ্ট্য পরীক্ষা', font: banglaFont, fontSize: 18),

              pw.SizedBox(height: 8),

              BanglaBulletList(
                font: banglaFont,
                fontSize: 14,
                items: const [
                  'বাংলা ইউনিকোড ঠিক রাখতে হবে',
                  'যুক্তাক্ষর সঠিকভাবে দেখাতে হবে',
                  'লাইন ব্রেক ঠিক রাখতে হবে',
                  'পিডিএফ থেকে বাংলা সার্চ করা সম্ভব হওয়া উচিত',
                  'কপি করলে আসল বাংলা ইউনিকোড পাওয়া উচিত',
                ],
              ),

              pw.SizedBox(height: 24),

              //
              // Table
              //
              BanglaHeader('টেবিল পরীক্ষা', font: banglaFont, fontSize: 18),

              pw.SizedBox(height: 8),

              BanglaTable(
                font: banglaFont,
                data: const [
                  ['নাম', 'শ্রেণি', 'রোল', 'ফলাফল'],
                  ['আরিফ রহমান', 'দশম', '১২', 'অতি উত্তম'],
                  ['নাবিলা ইসলাম', 'নবম', '২৫', 'উত্তম'],
                  ['সাদিয়া আক্তার', 'অষ্টম', '৩১', 'অতি উত্তম'],
                ],
              ),

              pw.SizedBox(height: 24),

              //
              // Search/copy verification text
              //
              BanglaHeader(
                'কপি ও সার্চ পরীক্ষা',
                font: banglaFont,
                fontSize: 18,
              ),

              pw.SizedBox(height: 8),

              BanglaParagraph(
                'এই বাক্যটি পিডিএফ থেকে কপি করুন এবং '
                'প্রজ্ঞাপন শব্দটি সার্চ করে দেখুন। '
                'কপি করার পর বাংলা ইউনিকোড অপরিবর্তিত থাকা উচিত।',
                font: banglaFont,
                fontSize: 14,
              ),
            ];
          },
        ),
      );

      final bytes = await document.save();

      final file = File(
        '${Directory.systemTemp.path}/bangla_pdf_fixer_test.pdf',
      );

      await file.writeAsBytes(bytes, flush: true);

      debugPrint('PDF GENERATED: ${file.path}');

      if (!mounted) {
        return;
      }

      setState(() {
        _result = file.path;
      });

      if (Platform.isMacOS) {
        await Process.run('open', [file.path]);
      }
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
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FilledButton.icon(
            onPressed: _loading ? null : _generatePdf,
            icon: _loading
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.picture_as_pdf),
            label: Text(_loading ? 'Generating...' : 'Generate Bangla PDF'),
          ),

          if (_result != null) ...[
            const SizedBox(height: 20),
            SelectableText(_result!, textAlign: TextAlign.center),
          ],
        ],
      ),
    );
  }
}
