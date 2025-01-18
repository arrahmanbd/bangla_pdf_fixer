import 'package:flutter/services.dart';
import 'unicode_mapper.dart';

extension UnicodeFixerExtension on String {
  String fix() {
    return BanglaUnicodeMapper.encodeANSI(this);
  }
}

// More Helper Methods will added Here
//
class FixingUtils {
  //Loading image as Uint8List
  static Future<Uint8List> loadImage(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    return byteData.buffer.asUint8List();
  }

// applying fonts in table data
  static List<List<String>> fixTableData(List<List<String>> tableData) {
    return tableData.map((row) {
      return row.map((cell) {
        // Apply the toFixedUnicode method to each cell if it's a Bangla text
        return cell.fix();
      }).toList();
    }).toList();
  }
}
