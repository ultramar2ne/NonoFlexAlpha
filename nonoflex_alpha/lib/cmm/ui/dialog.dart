import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:nonoflex_alpha/conf/ui/theme.dart';
import 'package:nonoflex_alpha/gen/fonts.gen.dart';

extension BNDialog on GetInterface {
  // /// confirm 다이얼로그로 확인/취소 버튼 동작에 따라 true/false를 반환한다.
  Future<bool> confirmDialog(
    String message, {
    String? title,
    String? noButtonTitle,
    String? yesButtonTitle,
    String? subMessage,
    Color? yesButtonTitleColor,
    double maxWidth = 500.0,
  }) async {
    final theme = LightTheme();

    final titleItem = Text(
      title ?? '알림',
      style: const TextStyle(
        fontFamily: FontFamily.notoSansKR,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );

    final dialogWidget = AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: 320,
        height: 180,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleItem,
                    const SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        message,
                        style: theme.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(height: 0.5, color: theme.baseDark),
            Container(
              alignment: Alignment.bottomCenter,
              height: 52,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => Get.back(result: false),
                      child: Center(
                          child: Text(
                        'commonDialogButtonCancel'.tr,
                        style: theme.button.copyWith(color: theme.textDark),
                      )),
                    ),
                  ),
                  Container(width: 0.5, color: theme.baseDark),
                  Expanded(
                    child: InkWell(
                      onTap: () => Get.back(result: true),
                      child: Center(
                          child: Text(
                        'commonDialogButtonOk'.tr,
                        style: theme.button.copyWith(color: theme.primary),
                      )),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );

    final result = await dialog<bool>(dialogWidget) ?? false;

    return result;
  }

  /// 단순 메시지 표시를 위한 다이얼로그를 띄운다.
  Future<void> alertDialog(
    String message, {
    String? title,
    BuildContext? context,
    double maxWidth = 500.0,
  }) async {
    final theme = LightTheme();

    final titleItem = Text(
      title ?? '알림',
      style: const TextStyle(
        fontFamily: FontFamily.notoSansKR,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );

    final dialogWidget = AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: 320,
        height: 200,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleItem,
                    const SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        message,
                        style: theme.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(height: 0.5, color: theme.baseDark),
            Container(
              alignment: Alignment.bottomCenter,
              height: 52,
              child: InkWell(
                onTap: () => Get.back(result: true),
                child: Center(
                  child: Text(
                    'commonDialogButtonOk'.tr,
                    style: theme.button.copyWith(color: theme.primary),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );

    return await dialog(dialogWidget);
  }

  /// 단순 메세지를 토스트 형식으로 제공
  void toast(String message) {
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.CENTER,
    );
  }
}
