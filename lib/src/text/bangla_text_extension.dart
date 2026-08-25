extension BanglaTextExtension on String {
  /// Whether the string contains at least one character from the Bengali
  /// Unicode block (U+0980–U+09FF).
  bool get containsBangla => runes.any(_isBanglaRune);

  /// Backwards-compatible name for [containsBangla].
  bool get isBanglaText => containsBangla;

  /// Whether every non-whitespace rune belongs to the Bengali Unicode block.
  ///
  /// This is intentionally strict: Latin punctuation/digits make the result
  /// false. Use [containsBangla] when detecting mixed-script content.
  bool get isBanglaOnly {
    var foundBangla = false;

    for (final rune in runes) {
      if (_isWhitespace(rune)) {
        continue;
      }

      if (!_isBanglaRune(rune)) {
        return false;
      }

      foundBangla = true;
    }

    return foundBangla;
  }

  /// Migration bridge from bangla_pdf_fixer 2.x.
  ///
  /// Version 3+ uses real Unicode shaping, so no ANSI conversion is needed and
  /// the original Unicode string is returned unchanged.
  @Deprecated(
    'Bangla PDF Fixer 3+ uses Unicode shaping. Pass the original string '
    'directly to BanglaText instead.',
  )
  String get fix => this;

  static bool _isBanglaRune(int rune) => rune >= 0x0980 && rune <= 0x09FF;

  static bool _isWhitespace(int rune) =>
      rune == 0x09 || rune == 0x0A || rune == 0x0D || rune == 0x20;
}
