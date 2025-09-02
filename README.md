
# Bangla PDF Fixer 🔧

[![Stand With Palestine](https://github.com/arrahmanbd/bangla_pdf_fixer/raw/master/images/StandWithPalestine.svg)](https://pub.dev/packages/bangla_pdf_fixer)

**Bangla PDF Fixer** is a Flutter package designed to **fix broken Bangla fonts in PDFs**, ensuring accurate rendering of Bangla characters with **22+ high-quality custom fonts**.

A lightweight, focused solution for Bangla font issues—**nothing more, nothing less**.

> **Note:** This package focuses exclusively on Bangla font correction.
> For advanced PDF generation features, consider [`pdf_maker`](https://pub.dev/packages/pdf_maker).

![Bangla PDF Fixer](https://github.com/arrahmanbd/bangla_pdf_fixer/raw/master/images/pdf_fixer.png)

---

## Features

* **22+ Bangla fonts** for effortless customization of PDF text.
* Automatically **rearranges complex Bangla characters** for correct display.
* Seamless integration with **Flutter PDF generation workflows**.
* Ready-to-use **Bangla widgets**: text, headers, paragraphs, tables, and bullet lists.

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  bangla_pdf_fixer: ^2.0.0
```

Install packages:

```bash
flutter pub get
```

---

## Usage ✨

> **[Note] BanglaFontType: 🎨**
> The `BanglaFontType` class is a centralized enum of 22+ Bangla fonts for PDF generation. It simplifies working with Bangla text in Flutter by providing **ready-to-use `pw.TextStyle` and `pw.Text` widgets**, making font assignment seamless and reducing boilerplate.

---

### Step 1: Initialize Fonts

Before using any widgets, initialize the font manager:

```dart
await BanglaFontManager().initialize();
```

This ensures all fonts are loaded and ready for use.

---

### Step 2: Fix Bangla Text in PDFs

Use the `.fix` extension to automatically correct broken Bangla text:

```dart
BanglaText(
  'বাংলা সাধারণ টেক্সট',
  fontType: BanglaFontType.kalpurush,
  fontSize: 20,
),
pw.SizedBox(height: 10),
pw.Text(
  'বেঁচে থাকার মত আনন্দ আর কিছুই নেই।'.fix,
  style: BanglaFontType.july.ts(
    fontSize: 24,
    fontWeight: pw.FontWeight.bold,
    color: PdfColors.red,
  ),
),
```

> Most widgets apply `.fix` internally, so manual usage is optional. 

---

## Example: Generate a PDF in Flutter

```dart
import 'package:bangla_pdf_fixer/bangla_pdf_fixer.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

Future<void> generateAndOpenPdf() async {
  await BanglaFontManager().initialize();

  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          BanglaText(
            'বাংলা সাধারণ টেক্সট',
            fontType: BanglaFontType.kalpurush,
            fontSize: 20,
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'বেঁচে থাকার মত আনন্দ আর কিছুই নেই।'.fix,
            style: BanglaFontType.july.ts(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.red,
            ),
          ),
        ],
      ),
    ),
  );

  final dir = await getApplicationDocumentsDirectory();
  final file = File("${dir.path}/example.pdf");
  await file.writeAsBytes(await pdf.save());
  await OpenFile.open(file.path);
}
```

---

## Step 3: Use PDF Fixer Widgets

Bangla PDF Fixer provides **ready-to-use widgets** that automatically handle font corrections:

* [**BanglaText**](#1-banglatext) – Basic Bangla text
* [**BanglaRichText**](#2-banglarichtext) – Multi-style text spans
* [**BanglaHeader**](#3-banglaheader) – Bold headers
* [**BanglaParagraph**](#4-banglaparagraph) – Properly formatted paragraphs
* [**BanglaBulletList**](#5-banglabulletlist) – Bullet lists
* [**BanglaTable**](#6-banglatable) – Tables with headers and formatted cells

These widgets integrate seamlessly with the [pdf package](https://pub.dev/packages/pdf), allowing you to **focus on content while the package handles Bangla text corrections**.

---

### 1. BanglaText

```dart
BanglaText(
  'বাংলা সাধারণ টেক্সট',
  fontType: BanglaFontType.kalpurush,
  fontSize: 18,
);
```

### 2. BanglaRichText

```dart
BanglaRichText(
  spans: [
    BanglaTextSpan('বাংলা বোল্ড ', fontWeight: pw.FontWeight.bold),
    BanglaTextSpan('এবং ইটালিক', fontType: BanglaFontType.julyItalic),
  ],
);
```

### 3. BanglaHeader

```dart
BanglaHeader('বাংলা শিরোনাম');
```

### 4. BanglaParagraph

```dart
BanglaParagraph('বাংলা অনুচ্ছেদ এখানে লেখা হবে।');
```

### 5. BanglaBulletList

```dart
BanglaBulletList(
  items: ['প্রথম আইটেম', 'দ্বিতীয় আইটেম', 'তৃতীয় আইটেম'],
  bullet: '>',
);
```

### 6. BanglaTable

```dart
BanglaTable(
  data: [
    ['নাম', 'বয়স', 'শহর'],
    ['আহমেদ', '২৫', 'ঢাকা'],
    ['সারা', '৩০', 'চট্টগ্রাম'],
    ['রাহুল', '২৮', 'সিলেট'],
  ],
  fontType: BanglaFontType.tomalicca,
  fontSize: 16,
  fontWeight: pw.FontWeight.normal,
);
```

---

## Step 4: TextStyle & Widget Shortcuts

```dart
// TextStyle shortcut
pw.Text(
  'বাংলা শিরোনাম'.fix,
  style: BanglaFontType.july.ts(
    fontSize: 24,
    fontWeight: pw.FontWeight.bold,
    color: PdfColors.red,
  ),
);

// Text widget shortcut
BanglaFontType.kalpurush.text(
  'বাংলা লেখা',
  fontSize: 18,
  color: PdfColors.black,
);
```

---

## Demo Preview 📥

View a **sample PDF output**:

[Click here to check the demo PDF](https://github.com/arrahmanbd/bangla_pdf_fixer/raw/master/demo/invoice.pdf)

---

## Contributing 🚀

Contributions are welcome! Whether you want to:

* Report a bug
* Suggest a feature
* Improve widgets or documentation

**Fork the repository, make changes, and submit a Pull Request**. Together, we can enhance Bangla PDF Fixer! 💡

---

## License

This project is licensed under the **Apache License 2.0**.
Read the full license [here](https://www.apache.org/licenses/LICENSE-2.0).

---

## Author

Maintained by **AR Rahman**
Contact: [arrahman.dev@outlook.com](mailto:arrahman.dev@outlook.com)

---

## Special Thanks 🙏✨

A big thank you to all **Bangla font creators and contributors**. Your efforts make **high-quality, beautiful Bangla PDFs** possible. 💖

---

⭐ If you find Bangla PDF Fixer helpful, please **star the repository**!
