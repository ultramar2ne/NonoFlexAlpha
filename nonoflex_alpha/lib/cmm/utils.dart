import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart' as scanner;
import 'package:barcode_widget/barcode_widget.dart' as viewer;

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

  static viewer.Barcode? fromScanner(scanner.BarcodeFormat scannerformat) {
    switch (scannerformat) {
      case scanner.BarcodeFormat.aztec:
        return viewer.Barcode.aztec();
      case scanner.BarcodeFormat.codabar:
        return viewer.Barcode.codabar();
      case scanner.BarcodeFormat.code39:
        return viewer.Barcode.code39();
      case scanner.BarcodeFormat.code93:
        return viewer.Barcode.code93();
      case scanner.BarcodeFormat.code128:
        return viewer.Barcode.code128();
      case scanner.BarcodeFormat.dataMatrix:
        return viewer.Barcode.dataMatrix();
      case scanner.BarcodeFormat.ean8:
        return viewer.Barcode.ean8();
      case scanner.BarcodeFormat.ean13:
        return viewer.Barcode.ean13();
      case scanner.BarcodeFormat.itf:
        return viewer.Barcode.itf();
      case scanner.BarcodeFormat.pdf417:
        return viewer.Barcode.pdf417();
      case scanner.BarcodeFormat.qrcode:
        return viewer.Barcode.qrCode();
      case scanner.BarcodeFormat.upcA:
        return viewer.Barcode.upcA();
      case scanner.BarcodeFormat.upcE:
        return viewer.Barcode.upcE();
      case scanner.BarcodeFormat.upcEanExtension:
        return viewer.Barcode.upcE();

      case scanner.BarcodeFormat.maxicode:
      case scanner.BarcodeFormat.rss14:
      case scanner.BarcodeFormat.rssExpanded:
      case scanner.BarcodeFormat.unknown:
        return null;
    }
  }
}

extension BaseViewUtils on BaseGetView {
  String formatDateYMD(DateTime date) => DateFormat("yyyy-MM-dd").format(date);

  String formatDateYMDE(DateTime date) => DateFormat("yyyy-MM-dd (E)").format(date);

  String formatDateYMDHM(DateTime date) =>
      DateFormat("yyyy-MM-dd HH:MM").format(date);

  String formatDateMDE(DateTime date) =>
      DateFormat("MM월 dd일 (E)").format(date);

  String formatDateMD(DateTime date) =>
      DateFormat("MM월 dd일").format(date);
}
