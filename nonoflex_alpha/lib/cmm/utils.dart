import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:nonoflex_alpha/cmm/base.dart';

class Utils {
  /// Decode JWT 토큰
  static Map<String, dynamic> parseJwt(String token) {
    String _decodeBase64(String str) {
      String output = str.replaceAll('-', '+').replaceAll('_', '/');

      switch (output.length % 4) {
        case 0:
          break;
        case 2:
          output += "==";
          break;
        case 3:
          output += '=';
          break;
        default:
          throw Exception('Illegal base64 string.');
      }

      return utf8.decode(base64Url.decode(output));
    }

    final parts = token.split('.');
    if (parts.length != 3) {
      throw FormatException('Invalid token.');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw FormatException('Invalid payload.');
    }

    return payloadMap;
  }
}

extension BaseViewUtils on BaseGetView {
  String formatDateYMD(DateTime date) => DateFormat("yyyy-MM-dd").format(date);

  String formatDateYMDHM(DateTime date) =>
      DateFormat("yyyy-MM-dd HH:MM").format(date);
}
