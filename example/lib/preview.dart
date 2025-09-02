import 'dart:io';
import 'package:bangla_pdf_fixer_example/services/demo_pdf.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class PdfPreviewScreen extends StatefulWidget {
  const PdfPreviewScreen({super.key});

  @override
  State<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  bool _isGenerating = false;

  Future<void> _generateAndOpenPdf() async {
    setState(() => _isGenerating = true);

    try {
      // Generate PDF
      final pdf = await BanglaPdfService.generateSamplePdf();
      // Save to temporary directory
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/invoice.pdf');
      await file.writeAsBytes(await pdf.save());

      // Open PDF
      await OpenFile.open(file.path);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating PDF: $e')),
      );
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bangla PDF Preview')),
      body: Center(
        child: _isGenerating
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _generateAndOpenPdf,
                child: const Text('Generate & Open PDF'),
              ),
      ),
    );
  }
}
