import 'package:flutter/material.dart';
import 'services/pdf_demo.dart';

class PdfInvoicePage extends StatelessWidget {
  const PdfInvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('ইনভয়েস জেনারেটর'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.picture_as_pdf,
                    size: 80, color: Colors.redAccent),
                const SizedBox(height: 20),
                const Text(
                  'একটি প্রফেশনাল ইনভয়েস তৈরি করুন',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: PdfDemoData.generateAndOpenInvoice,
                  icon: const Icon(Icons.download, color: Colors.white),
                  label: const Text('ইনভয়েস তৈরি করুন',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
