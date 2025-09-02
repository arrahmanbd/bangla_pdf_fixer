# 2.0

## Whats New?

### Font Management

- `BanglaFontManager` for asynchronous font loading and caching.
- `BanglaFontType` enum listing 22+ Bangla fonts.
- `BanglaFontTypeExtension`:
  - `ts()` – returns ready-to-use `pw.TextStyle`.
  - `text()` – returns ready-to-use `pw.Text` widget.
- `BanglaTextExtension` on String:
  - `isBanglaText` – detects Bangla characters.
  - `fix` – auto-fixes Bangla text to ANSI if needed.

### Widgets

- `BanglaText` – simple Bangla text widget for PDFs.
- `BanglaRichText` – rich text with multiple Bangla spans.
- `BanglaTextSpan` – span object for `BanglaRichText`.
- `BanglaHeader` – PDF header widget with Bangla font.
- `BanglaParagraph` – paragraph widget supporting Bangla text.
- `BanglaBulletList` – bullet list widget supporting Bangla text.
- `BanglaTable` – table widget with Bangla headers and cells.

### Features

- Automatic Bangla font assignment for all widgets.
- Supports font size, font weight, color, and text alignment.
- Reduces boilerplate: no need to call `BanglaFontManager().getFont(...)` repeatedly.
- Fully compatible with `pdf` and `printing` packages for Flutter.

## 2.0.0-rc.1

- Refactored the codebase in preparation for the final release.  
- Added a plan to implement a custom component for Bangla text rendering.  
- Prepared staging environment to officially support the PDF package. 

## 2.0.0-dev.1

- Migrated into latest SDK
- Updated Documentation
- Added cleaner example
- Added New Fonts..
  - 36th July
  - Mayaboti and 5 new fonts
- Upgrade Code for cleaner approach
- Staging for 2.0 release
- Implemeting own component based on pdf package

## 1.0.2

- Improved Documentation.
- Added more Bangla fonts.

## 1.0.0

- Initial release of the **Bangla PDF Fixer** package 2024-01-18.
- Added support for multiple Bangla fonts.
- Implemented font fixing for PDFs with broken fonts.
- Fixed various issues with font rendering.
