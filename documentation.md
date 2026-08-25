# bangla_pdf_fixer 3.1 architecture

## Responsibility split

`bangla_pdf_fixer` intentionally remains a thin facade:

```text
bangla_pdf_fixer
  ├─ Flutter asset font cache
  ├─ Bangla convenience widgets
  ├─ Bangla typography presets/helpers
  ├─ migration/text-detection helpers
  └─ pdf_text_shaper
       └─ HarfBuzz shaping + PDF glyph rendering
```

There is no second Bangla shaping implementation in this package.

## Public API layers

### Core shaping

Re-exported from `pdf_text_shaper`:

- `ShapedFont`
- `ShapedFontDiagnostics`
- `ShapedText`
- `ShapedTextStyle`
- `ShapedTextAlign`
- `ShapedTextDirection`

### Bangla facade

- `BanglaFontManager`
- `BanglaTypography`
- `BanglaText`
- `BanglaParagraph`
- `BanglaHeader`
- `BanglaRichText`
- `BanglaTextSpan`
- `BanglaBulletList`
- `BanglaTable`
- `BanglaTextExtension`

## Font ownership

`BanglaFontManager` owns fonts that it creates from assets. `dispose()` or
`evict()` disposes those cached `ShapedFont` instances.

Fonts created directly with `ShapedFont.fromBytes(...)` are owned by the caller
and should be disposed by the caller.

## Font-cache behavior

The cache key is:

```text
AssetBundle identity + asset path
```

This prevents a custom bundle in tests/modules from accidentally receiving a
font loaded from another bundle with the same path.

Failed font loads are removed from the cache. This avoids permanently caching a
failed `Future` and makes asset-loading retries possible.

## Widget guidance

### Long text

Prefer `BanglaText` / `BanglaParagraph`. They delegate the complete text block
to the shaping engine.

### Short mixed styles

Use `BanglaRichText`. It shapes runs/tokens independently and composes them with
`pw.Wrap`. It is intentionally a lightweight helper, not a replacement for a
full shaped inline-span layout engine.

### Tables

`BanglaTable` validates that every row has the same cell count. `headerRows`
controls how many leading rows receive header styling. `BanglaTable.fromRows`
sets it automatically from the provided header row. Header rows repeat across
pages by default through the native `pw.TableRow.repeat` mechanism.

## Unicode extraction

`preserveUnicodeText` is enabled by default across the Bangla facade. Keep it
enabled when searchable/copyable source text is desired.

Visual glyph outlines and searchable Unicode are separate concerns: always test
both rendering and extraction with the PDF readers your application supports.

## Migration from 2.x

1. Choose a Unicode Bengali OpenType font.
2. Add it to the consuming Flutter application's assets.
3. Load it with `BanglaFontManager.instance.loadAsset`.
4. Pass the returned `ShapedFont` to Bangla widgets, or build a
   `BanglaTypography` instance.
5. Delete `.fix` calls over time.
6. Remove `BanglaFontType` and legacy bundled font assumptions.
7. Do not use legacy Bijoy/ANSI font encodings with the Unicode shaper.

## Validation checklist

Run on a machine with Flutter/Dart matching `pubspec.yaml`:

```bash
flutter pub get
dart format --set-exit-if-changed .
flutter analyze
flutter test
flutter pub publish --dry-run
```

Generate PDFs containing at least:

- `বাংলাদেশ`
- `শিক্ষার্থী`
- `রাষ্ট্র`
- `ক্ষুদ্র`
- `প্রজ্ঞাপন`
- Bangla digits
- `৳`
- ZWJ/ZWNJ cases
- multiple lines
- long wrapping paragraphs
- Bangla + English fallback runs
- tables and lists

Verify visual rendering, search, copy/paste, and output size.
