## 3.1.1

- Hardened `BanglaFontManager` caching and cleanup.
- Failed asset loads are now evicted automatically and can be retried.
- Font caching now distinguishes different `AssetBundle` instances.
- Added `preloadAssets`, `isCached`, and `evict` font-manager APIs.
- Added `BanglaTypography` for reusable regular/bold/fallback style setup.
- `BanglaHeader` and `BanglaParagraph` now accept either `style` or `font`.
- Improved `BanglaBulletList` with custom style, line height, indentation,
  marker size/gap/color, and empty-list handling.
- Improved `BanglaRichText` with reusable fallback fonts, per-span styles,
  line height, Unicode preservation, and wrap alignment controls.
- Improved `BanglaTable` with header/body text colors, line heights,
  alternating row backgrounds, multiple header rows, text alignment,
  border width, repeating header rows, and dedicated header fallback fonts.
- Fixed table cells ignoring configured text color.
- Added `containsBangla` and strict `isBanglaOnly` string helpers.
- Re-exported `ShapedText` from the package facade.

## 3.0.0

- Rebuilt Bangla rendering on top of `pdf_text_shaper`.
- Replaced legacy ANSI mapping with Unicode-first HarfBuzz shaping.
- Removed bundled fonts and `BanglaFontType`.
- Added lazy Flutter asset font loading.
- Preserved the deprecated `.fix` getter as a no-op migration bridge.
- Added Unicode-preserving PDF text mode through the universal renderer.
- Added Bangla text, header, paragraph, bullet-list, rich-text, and table
  helpers.
- Updated project links to the `ardevcraft` GitHub account.
- Raised minimum SDK to Dart 3.13 because of the native HarfBuzz backend.
