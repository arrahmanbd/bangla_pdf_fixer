 > Correct Bangla/Bengali Unicode rendering in PDFs generated with Flutter's `pdf` package.

![Bangla PDF Fixer](https://github.com/ardevcraft/bangla_pdf_fixer/raw/master/images/pdf_fixer.png)
Version 3 is a full architectural reset. It uses [`pdf_text_shaper`](https://pub.dev/packages/pdf_text_shaper) + HarfBuzz for proper OpenType shaping instead of translating Bangla Unicode into legacy ANSI font codes.

## What changed in 3.0

### Before

```text
Bangla Unicode
→ handwritten rearrangement rules
→ ANSI/legacy character mapping
→ bundled legacy font
→ PDF
```

### Now

```text
Bangla Unicode
→ HarfBuzz GSUB/GPOS shaping
→ positioned glyph IDs
→ vector glyph rendering
→ invisible Unicode extraction layer
→ PDF
```

Benefits:

- conjuncts and vowel signs are driven by the font's real OpenType rules;
- original Unicode is never destroyed;
- multiline input stays multiline;
- no giant replacement map;
- no package-bundled third-party fonts;
- PDFs can retain useful copy/search text;
- See the [demo document](https://github.com/ardevcraft/bangla_pdf_fixer/blob/master/demo/doc.pdf) for more.


## Platforms

Android, iOS, Linux, macOS and Windows.

Web is not currently supported because the shaping backend uses native
HarfBuzz FFI.

### Legacy ANSI fonts

Do not use a legacy ```Bijoy/ANSI``` font with the Unicode shaper. Use a proper Unicode OpenType Bengali font.

## Installation

```yaml
dependencies:
  bangla_pdf_fixer: ^3.1.0
  pdf: ^3.13.0
```

Add a Unicode Bengali OpenType font to your app:

```yaml
flutter:
  assets:
    - assets/fonts/NotoSansBengali-Regular.ttf
    - assets/fonts/NotoSansBengali-Bold.ttf
```

The package intentionally does not bundle fonts. Make sure the font license
permits your use.

## Load fonts

```dart
final regular = await BanglaFontManager.instance.loadAsset(
  'assets/fonts/NotoSansBengali-Regular.ttf',
  name: 'Noto Sans Bengali Regular',
);

final bold = await BanglaFontManager.instance.loadAsset(
  'assets/fonts/NotoSansBengali-Bold.ttf',
  name: 'Noto Sans Bengali Bold',
);
```

Repeated/concurrent requests for the same asset share the cache. A failed load
is evicted automatically so it can be retried.

## BanglaText

Use the concise font API:

```dart
BanglaText(
  'আমি বাংলায় লিখছি।',
  font: regular,
  fontSize: 16,
)
```

Or pass the underlying shaping style directly:

```dart
BanglaText(
  'Invoice ১২৩ — মোট ৳৫০০',
  style: ShapedTextStyle(
    font: regular,
    fallbackFonts: [latinFont],
    fontSize: 14,
    preserveUnicodeText: true,
  ),
)
```

## Reusable typography

For larger documents, define the font/fallback family once:

```dart
final typography = BanglaTypography(
  regularFont: regular,
  boldFont: bold,
  fallbackFonts: [latinRegular],
  boldFallbackFonts: [latinBold],
);
```

Then reuse it:

```dart
BanglaHeader(
  'ফলাফল প্রতিবেদন',
  style: typography.heading(fontSize: 24),
),

BanglaParagraph(
  'বাংলা অনুচ্ছেদ এখন আসল Unicode হিসেবেই থাকে।',
  style: typography.body(fontSize: 12),
),
```

## Bullet list

```dart
BanglaBulletList(
  font: regular,
  fontSize: 13,
  lineHeight: 1.3,
  markerGap: 8,
  items: const [
    'প্রথম বিষয়',
    'দ্বিতীয় বিষয়',
    'তৃতীয় বিষয়',
  ],
)
```

You can also pass a complete `ShapedTextStyle` instead of separate font/style
arguments.

## Rich text

`BanglaRichText` is intended for short mixed-style labels/headings. Each run is
independently shaped so it can flow through `pw.Wrap`.

```dart
BanglaRichText(
  font: regular,
  fallbackFonts: [latinRegular],
  spans: [
    const BanglaTextSpan('মোট: '),
    BanglaTextSpan(
      '৳১২,৫০০',
      style: typography.style(bold: true, fontSize: 14),
    ),
  ],
)
```

For long flowing body text, prefer `BanglaText` or `BanglaParagraph` so the
shaping engine owns the complete paragraph layout.

## Table

```dart
BanglaTable.fromRows(
  font: regular,
  headerFont: bold,
  headerColor: PdfColors.blueGrey50,
  alternateRowColor: PdfColors.grey50,
  headers: const ['নাম', 'শ্রেণি', 'ফলাফল'],
  rows: const [
    ['আরিফ', 'দশম', 'A+'],
    ['নাবিলা', 'নবম', 'A'],
  ],
)
```

Or use `BanglaTable(data: ...)` when you already have a complete matrix. The
first row is treated as a header by default; set `headerRows: 0` for a table
without headers. Header rows repeat automatically when a table spans pages; set
`repeatHeaderRows: false` to disable that behavior.

## Text detection

```dart
'Invoice ১২৩'.containsBangla; // true
'আমি বাংলা লিখি'.isBanglaOnly; // true
```

`isBanglaText` remains available as a compatibility alias for
`containsBangla`.


## Mixed Bangla + English

Use the universal style's fallback support:

```dart
BanglaText(
  'Invoice ১২৩ — মোট ৳৫০০',
  style: ShapedTextStyle(
    font: banglaFont,
    fallbackFonts: [latinFont],
    fontSize: 14,
  ),
)
```

## Migration from 2.x

### `.fix`

You no longer need:

```dart
'বাংলা'.fix
```

The deprecated getter remains as an identity operation for migration only.
Pass the original Unicode string directly to `BanglaText`.

## Font lifecycle

The singleton manager is designed for long-running Flutter apps. Keep commonly
used fonts cached while generating PDFs and dispose them when the font service
is genuinely being torn down:

```dart

await document.save();
await BanglaFontManager.instance.dispose();
```

You can evict one asset when needed:

```dart
await BanglaFontManager.instance.evict(
  'assets/fonts/NotoSansBengali-Regular.ttf',
);
```

## Author

Maintained by **AR Rahman**
GitHub: [@ardevcraft](https://github.com/ardevcraft)

Crafted with ❤️ for **Bangla** and the open-source community. 🇧🇩

[![Stand With Palestine](https://github.com/ardevcraft/bangla_pdf_fixer/raw/master/images/stand_with_plastine.svg)](https://pub.dev/packages/bangla_pdf_fixer)


## Repository

https://github.com/ardevcraft/bangla_pdf_fixer

Contributions, bug reports, feature requests, and pull requests are welcome.

## License

Licensed under the **Apache License 2.0**.
