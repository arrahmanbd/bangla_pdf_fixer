part of 'package:bangla_pdf_fixer/bangla_pdf_fixer.dart';

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  Static FontAssets
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

const _package = 'packages/bangla_pdf_fixer/lib';

/// Enum for all Bangla fonts in this package.
///
/// Preview will be added in future releases.
enum BanglaFontType {
  adorOrjoma,
  charuChandan,
  charuChandanBloodDrip,
  charukola,
  kalpona,
  kalpurush,
  diproAD,
  jashirItalic,
  jashir,

  /// A font configuration used to style text elements in an italic style.
  //[July] This  font can be applied to widgets to customize their appearance.
  /// It is typically used to emphasize or differentiate text within the document.
  ///
  julyItalic,

  /// A font configuration used to style text elements.
  /// This font can be applied to widgets to customize their appearance.
  redJuly,
  lipiPadmo,
  mayabotiItalic,
  mayaboti,
  nondon,
  rajnigandha,
  ruposhiBangla,
  sonarKellaItalic,
  sonarKella,
  tomalicca,
  trinoyonItalic,
  trinoyon,
  openSans
}

/// Font registry for resolving [BanglaFontType] to asset paths.
class BanglaFonts {
  static String getPath(BanglaFontType type) {
    switch (type) {
      case BanglaFontType.adorOrjoma:
        return '$_package/fonts/AdorOrjoma/Ador_Orjoma.ttf';
      case BanglaFontType.charuChandan:
        return '$_package/fonts/CharuChandan/Charu_Chandan_Regular.ttf';
      case BanglaFontType.charuChandanBloodDrip:
        return '$_package/fonts/CharuChandanBloodDrip/Charu_Chandan_Blood_Regular.ttf';
      case BanglaFontType.charukola:
        return '$_package/fonts/Charukola/Charukola_Ansi_Regular.ttf';
      case BanglaFontType.kalpona:
        return '$_package/fonts/Default/kalpona.ttf';
      case BanglaFontType.kalpurush:
        return '$_package/fonts/Default/kalpurush.ttf';
      case BanglaFontType.diproAD:
        return '$_package/fonts/DiproAD/DiproAD_Regular.ttf';
      case BanglaFontType.jashirItalic:
        return '$_package/fonts/Jashir/jashir-italic.ttf';
      case BanglaFontType.jashir:
        return '$_package/fonts/Jashir/jashir.ttf';
      case BanglaFontType.julyItalic:
        return '$_package/fonts/July/july-italic.ttf';
      case BanglaFontType.redJuly:
        return '$_package/fonts/July/july.ttf';
      case BanglaFontType.lipiPadmo:
        return '$_package/fonts/LipiPadmo/Lipi-Padmo.ttf';
      case BanglaFontType.mayabotiItalic:
        return '$_package/fonts/Mayaboti/mayaboti-Italic.ttf';
      case BanglaFontType.mayaboti:
        return '$_package/fonts/Mayaboti/mayaboti.ttf';
      case BanglaFontType.nondon:
        return '$_package/fonts/Nondon/Nondon.ttf';
      case BanglaFontType.rajnigandha:
        return '$_package/fonts/Rajnigandha/Rajnigandha.ttf';
      case BanglaFontType.ruposhiBangla:
        return '$_package/fonts/RuposhiBangla/Ruposhi_Bangla.ttf';
      case BanglaFontType.sonarKellaItalic:
        return '$_package/fonts/SonarKella/sonarkella-italic.ttf';
      case BanglaFontType.sonarKella:
        return '$_package/fonts/SonarKella/sonarkella.ttf';
      case BanglaFontType.tomalicca:
        return '$_package/fonts/Tomalicca/TOMALICCA.ttf';
      case BanglaFontType.trinoyonItalic:
        return '$_package/fonts/Trinoyon/trinoyon-italic.ttf';
      case BanglaFontType.trinoyon:
        return '$_package/fonts/Trinoyon/trinoyon.ttf';
      case BanglaFontType.openSans:
        return '$_package/fonts/Default/OpenSans.ttf';
    }
  }
}
