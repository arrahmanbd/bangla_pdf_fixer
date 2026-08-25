/// Unicode-first Bangla/Bengali text rendering for `package:pdf`.
///
/// Text shaping and glyph rendering are delegated to `pdf_text_shaper` and
/// HarfBuzz. This package adds Flutter asset font loading, Bangla-focused
/// convenience widgets, and migration helpers.
library;

export 'package:pdf_text_shaper/pdf_text_shaper.dart'
    show
        ShapedFont,
        ShapedFontDiagnostics,
        ShapedText,
        ShapedTextAlign,
        ShapedTextDirection,
        ShapedTextStyle;

export 'src/font/bangla_font_manager.dart';
export 'src/text/bangla_text_extension.dart';
export 'src/text/bangla_typography.dart';
export 'src/widgets/bangla_bullet_list.dart';
export 'src/widgets/bangla_header.dart';
export 'src/widgets/bangla_paragraph.dart';
export 'src/widgets/bangla_rich_text.dart';
export 'src/widgets/bangla_table.dart';
export 'src/widgets/bangla_text.dart';
