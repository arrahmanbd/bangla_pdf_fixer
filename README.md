
# Bangla PDF Fixer 🔧

[![Stand With Palestine](https://github.com/arrahmanbd/bangla_pdf_fixer/raw/master/images/StandWithPalestine.svg)](https://pub.dev/packages/bangla_pdf_fixer)

**Bangla PDF Fixer** is a Flutter package built to fix broken Bangla fonts in PDFs. It ensures proper rendering of Bangla characters using 15+ custom fonts. A simple solution focused solely on Bangla font issues.Nothing more, nothing less.

> **Note:** This only fixes Bangla fonts.  
> For full multilingual support and highly optimized PDF generation, use our new package [`pdf_maker`](https://pub.dev/packages/pdf_maker), which supports multiple languages and offers advanced features.

![Bangla PDF Fixer](https://github.com/arrahmanbd/bangla_pdf_fixer/raw/master/images/pdf_fixer.png)

## Features

- Includes over 15+ Bangla fonts, allowing you to easily customize the appearance of your PDF documents.
- Rearrange complex Bangla characters for correct display.
- Easy integration into Flutter projects for PDF generation and text correction.


## Installation

Add this package to your `pubspec.yaml` file:

```yaml
dependencies:
  bangla_pdf_fixer: ^2.0.0
```

Run flutter pub get to install the package.

## Usage ✨ 

  **Font Loading:**

No need to Add any font manually. use the GetFonts class to access the desired font and load it with the FontManager.

  **PDF Generation:**

Use the pdf package to create a document and add pages with Bangla text.
Use the loaded Bangla font for proper rendering of Bangla characters.

  **Saving and Opening:**

Save the generated PDF file in the device's documents directory.
Open the PDF using the open_file package to display it with the default PDF viewer on the device.


## Full Example  👨‍💻

Check out the Example app. Here's a simple explanation:

```dart
import 'package:bangla_pdf_fixer/bangla_pdf_fixer.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

Future<void> generateAndOpenInvoice() async {
  // 1. Create a PDF document
  final pdf = pw.Document();

  // 2. Load Bangla font 
  final fontData = await FontManager.loadFont(GetFonts.kalpurush);
  final ttf = pw.Font.ttf(fontData);

  // 3. Add content to the PDF
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Center(
        child: pw.Text(
          'বেঁচে থাকার মত আনন্দ আর কিছুই নেই। ',
          style: pw.TextStyle(font: ttf, fontSize: 20),
        ),
      ),
    ),
  );

  // 4. Save the PDF to a file
  final outputDir = await getApplicationDocumentsDirectory();
  final file = File("${outputDir.path}/example.pdf");
  await file.writeAsBytes(await pdf.save());

  // 5. Open the PDF
  await OpenFile.open(file.path);
}
```

## Change the Default Font 🔧

The bangla_pdf_fixer package includes over 15+ Bangla fonts, allowing you to easily customize the appearance of your PDF documents. To change the default font, use the GetFonts class to access the desired font and load it with the FontManager. Here's an example of how to change font:

```dart
final fontData = await FontManager.loadFont(GetFonts.charukola);
```


## Demo Preview 📥

[Click here to check the output file](demo/invoice.pdf)



## Contributing 🚀

We encourage contributions from developers who are passionate about improving this project. If you encounter bugs or have ideas for new features, feel free to make fixes or improvements and submit a Pull Request. Together, we can make this project even better! 💡

## License

This project is licensed under the MIT License. See the LICENSE file for details.

## Author

Bangla PDF Fixer is maintained by AR Rahman. You can contact me at [arrahman.dev@outlook.com](mailto:arrahman.dev@outlook.com).

## Special Thanks 🙏✨

I would like to extend my heartfelt thanks to the creators and contributors of the Bangla fonts included in this package. Their hard work and dedication have made it possible to offer high-quality, beautiful fonts for the community. Without their contributions, this tool wouldn't be as effective in rendering Bangla text beautifully in PDF documents.

Thank you for helping make this project a success! 💖

**If you find Bangla PDF Fixer helpful, please ⭐️ the repository!**