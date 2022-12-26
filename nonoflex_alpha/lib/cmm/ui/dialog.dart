import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nonoflex_alpha/conf/ui/theme.dart';

extension BNDialog on GetInterface {
  // /// confirm 다이얼로그로 확인/취소 버튼 동작에 따라 true/false를 반환한다.
  Future<bool> alert(
    String message, {
    String? title,
    String? noButtonTitle,
    String? yesButtonTitle,
    String? subMessage,
    Color? yesButtonTitleColor,
    double maxWidth = 500.0,
  }) async {
    final theme = LightTheme();

    final titleItem = title != null
        ? Text(
            title,
            style: theme.listTitle,
          )
        : Text('!');

    final dialogWidget = Center(
      child: Material(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          // margin: const EdgeInsets.symmetric(horizontal: 16),
          constraints: BoxConstraints(maxWidth: 500, maxHeight: 350,minWidth: 300),
          decoration: BoxDecoration(
            // color: theme.base,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleItem,
              const SizedBox(height: 8),
              Text(message, style: theme.listBody),
              const SizedBox(height: 8),
              Container(
                height: 52,
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => Get.back(result: true),
                        child: Center(
                            child: Text(
                          'commonDialogButtonCancel'.tr,
                          style: theme.button.copyWith(color: theme.textDark),
                        )),
                      ),
                    ),
                    Container(width: 1, color: theme.baseDark),
                    Expanded(
                      child: InkWell(
                        onTap: () => Get.back(result: true),
                        child: Center(child: Text('commonDialogButtonOk'.tr)),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );

    final result = await dialog<bool>(dialogWidget) ?? false;

    return result;
  }

  /// 단순 메시지 표시를 위한 다이얼로그를 띄운다.
  Future<bool> confirm(
    String message, {
    String? title,
    BuildContext? context,
    double maxWidth = 500.0,
  }) async {
    return false;
  }

  /// 단순 메세지를 토스트 형식으로 제공
  void toast(String message) {}

  Future<void> alertDialog(
    String message, {
    String? title,
    String? confirmButtonText,
  }) {
    final theme = LightTheme();

    final dialogWidget = Container(
      constraints: BoxConstraints(maxWidth: 360, maxHeight: 300),
      child: Text(message),
    );

    return Get.dialog(dialogWidget);
  }

  // Future<bool> confirmDialog(
  //   String message, {
  //   String? title,
  //   String? confirmButtonText,
  // }) {
  //   final theme = LightTheme();
  // }

  // Future<bool> confirmDialog() {
  //   return generalDialog(
  //     pageBuilder: (buildContext, animation, secondaryAnimation) {
  //       final pageChild = widget;
  //       Widget dialog = Builder(builder: (context) {
  //         return Theme(data: theme, child: pageChild);
  //       });
  //       if (useSafeArea) {
  //         dialog = SafeArea(child: dialog);
  //       }
  //       return dialog;
  //     },
  //     barrierDismissible: barrierDismissible,
  //     barrierLabel: MaterialLocalizations.of(context!).modalBarrierDismissLabel,
  //     barrierColor: barrierColor ?? Colors.black54,
  //     transitionDuration: transitionDuration ?? defaultDialogTransitionDuration,
  //     transitionBuilder: (context, animation, secondaryAnimation, child) {
  //       return FadeTransition(
  //         opacity: CurvedAnimation(
  //           parent: animation,
  //           curve: transitionCurve ?? defaultDialogTransitionCurve,
  //         ),
  //         child: child,
  //       );
  //     },
  //     navigatorKey: navigatorKey,
  //     routeSettings: routeSettings ?? RouteSettings(arguments: arguments, name: name),
  //   );
  // }

  void generalToas() {}
}

class BlueDialog {
  final BuildContext _context;

  // final theme;

  BlueDialog(BuildContext context) : _context = context;

  // theme = BlueBoardTheme();

  // /// confirm 다이얼로그로 확인/취소 버튼 동작에 따라 true/false를 반환한다.
  Future<void> alert(
    String message, {
    String? title,
    String? noButtonTitle,
    String? yesButtonTitle,
    String? subMessage,
    Color? yesButtonTitleColor,
    double maxWidth = 500.0,
  }) async {}

  /// 단순 메시지 표시를 위한 다이얼로그를 띄운다.
  Future<bool> confirm(
    String message, {
    String? title,
    BuildContext? context,
    double maxWidth = 500.0,
  }) async {
    return false;
  }

  /// 단순 메세지를 토스트 형식으로 제공
  void toast(String message) {}
}
