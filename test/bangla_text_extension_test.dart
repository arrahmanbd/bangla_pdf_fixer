import 'package:bangla_pdf_fixer/bangla_pdf_fixer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BanglaTextExtension', () {
    test('detects Bangla code points in mixed content', () {
      expect('আমি বাংলা লিখি'.containsBangla, isTrue);
      expect('English only'.containsBangla, isFalse);
      expect('Invoice ১২৩'.containsBangla, isTrue);
    });

    test('keeps isBanglaText as compatibility alias', () {
      expect('বাংলা'.isBanglaText, isTrue);
      expect('English'.isBanglaText, isFalse);
    });

    test('detects strict Bangla-only content', () {
      expect('আমি বাংলা লিখি'.isBanglaOnly, isTrue);
      expect('বাংলা English'.isBanglaOnly, isFalse);
      expect('   '.isBanglaOnly, isFalse);
    });

    test('v3 migration fix getter preserves Unicode exactly', () {
      const input = 'প্রথম লাইন\nদ্বিতীয় লাইন';
      // ignore: deprecated_member_use_from_same_package
      expect(input.fix, input);
    });
  });
}
