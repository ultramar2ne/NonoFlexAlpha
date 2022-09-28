import 'dart:async';

import 'package:flutter/material.dart';


class BlueDialog {
  final BuildContext _context;
  // final theme;

  BlueDialog(BuildContext context)
      : _context = context;
        // theme = BlueBoardTheme();

  // /// confirm 다이얼로그로 확인/취소 버튼 동작에 따라 true/false를 반환한다.
  Future<void> alert(String message, {
    String? title,
    String? noButtonTitle,
    String? yesButtonTitle,
    String? subMessage,
    Color? yesButtonTitleColor,
    double maxWidth = 500.0,
  }) async {

  }

  /// 단순 메시지 표시를 위한 다이얼로그를 띄운다.
  Future<bool> confirm(String message, {
    String? title,
    BuildContext? context,
    double maxWidth = 500.0,
  }) async {
    return false;
  }

  /// 단순 메세지를 토스트 형식으로 제공
  void toast(String message) {

  }
}


