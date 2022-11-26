import 'package:flutter/material.dart';
import 'package:nonoflex_alpha/gen/assets.gen.dart';
import 'package:nonoflex_alpha/gen/colors.gen.dart';
import 'package:nonoflex_alpha/gen/fonts.gen.dart';

/// 앱 내에서 사용될 공통 위젯들
/// 다음과 같은 항목들이 구현되어 있다.
///  - BNColoredButton
///  - BNTextButton
///  - BNOutlinedBtton
///  - BNDefaultAppBar
///  - BNInputBox
///  - BNFormedInputBox

/// ColoredButton
class BNColoredButton extends ElevatedButton {
  BNColoredButton(
      {Key? key,
      required VoidCallback onPressed,
      required Widget child,
      bool onError = false,
      bool onDisable = false})
      : super(
          key: key,
          onPressed: onDisable ? null : onPressed,
          child: child,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(ColorName.primary),
            foregroundColor: MaterialStateProperty.all<Color>(ColorName.base),
            overlayColor: MaterialStateProperty.all<Color>(ColorName.primaryDark),
            elevation: MaterialStateProperty.all<double>(0),
            padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        );
}

/// TextButton
class BNTextButton extends ElevatedButton {
  // text
  BNTextButton(
    String text, {
    Key? key,
    required VoidCallback? onPressed,
    bool onError = false,
    bool onDisable = false,
  }) : super(
          key: key,
          onPressed: onDisable ? null : onPressed,
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(ColorName.base),
            foregroundColor: MaterialStateProperty.resolveWith<Color>(
              (states) {
                // if (states.contains(MaterialState.pressed)) {
                //   return ColorName.base;
                // }
                return ColorName.textDark;
              },
            ),
            overlayColor: MaterialStateProperty.resolveWith<Color>(
              (states) {
                if (states.contains(MaterialState.pressed)) {
                  return ColorName.secondary;
                } else if (states.contains(MaterialState.hovered)) {
                  return ColorName.secondaryLight;
                }
                return ColorName.base;
              },
            ),
            elevation: MaterialStateProperty.all<double>(0),
            padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        );
}

class BNOutlinedButton extends ElevatedButton {
  BNOutlinedButton({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool onError = false,
    bool onDisable = false,
  }) : super(
          key: key,
          onPressed: onDisable ? null : onPressed,
          child: child,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (states) {
                if (states.contains(MaterialState.hovered)) {
                  return ColorName.secondaryLight;
                }
                return ColorName.base;
              },
            ),
            foregroundColor: MaterialStateProperty.resolveWith<Color>(
              (states) {
                if (states.contains(MaterialState.pressed)) {
                  return ColorName.base;
                }
                return ColorName.primary;
              },
            ),
            overlayColor: MaterialStateProperty.all<Color>(ColorName.primary),
            elevation: MaterialStateProperty.all<double>(0),
            side: MaterialStateProperty.all<BorderSide>(
              const BorderSide(color: ColorName.primary, width: 1.0),
            ),
            padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        );
}

class BNIconButton extends IconButton {
  BNIconButton({required VoidCallback? onPressed, required Widget icon, double? size})
      : super(
          onPressed: onPressed,
          icon: icon,
          iconSize: size ?? 24,
          padding: EdgeInsets.all(5),
          visualDensity: VisualDensity.compact,
          style: ButtonStyle(),
        );
}

// class BNInputBox extends EditableText {
//   BNInputBox(
//       {required TextEditingController controller,
//       required FocusNode focusNode,
//       required TextStyle style,
//       required Color cursorColor,
//       required Color backgroundCursorColor})
//       : super(
//             controller: controller,
//             focusNode: focusNode,
//             style: style,
//             cursorColor: cursorColor,
//             backgroundCursorColor: backgroundCursorColor);
// }

class BNCheckBox extends Checkbox {
  BNCheckBox({required bool? value, required ValueChanged<bool?>? onChanged})
      : super(value: value, onChanged: onChanged);
}

class BNDefaultAppBar extends AppBar {
  BNDefaultAppBar({
    super.key,
    Widget? leadeing,
    String? title,
    Color? backgroundColor,
  }) : super(
          leading: leadeing,
          backgroundColor: backgroundColor ?? ColorName.base,
          foregroundColor: ColorName.primaryDark,
          elevation: 0,
        );
}

class BNInputBox extends TextField {
  BNInputBox({
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
    ValueChanged<String>? onSubmitted,
    Widget? icon,
    String? hintText,
    String? errorMessage,
    TextInputType? keyboardType,
    bool? showCursor,
    bool? expands,
    bool? enabled,
    bool showClearButton = false,
    bool showSearchButton = false,
    bool obscureText = false,
  }) : super(
            controller: controller,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            keyboardType: keyboardType,
            showCursor: showCursor,
            expands: expands ?? false,
            enabled: enabled,
            cursorColor: ColorName.secondaryDark,
            cursorWidth: 1.5,
            cursorHeight: 22,
            cursorRadius: const Radius.circular(8),
            obscureText: obscureText,
            style: TextStyle(
              fontSize: 16,
              fontFamily: FontFamily.notoSansKR,
              color: ColorName.textDark,
            ),
            decoration: InputDecoration(
              icon: icon != null ? SizedBox(width: 16, height: 16, child: icon) : null,
              iconColor: ColorName.primary,
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showClearButton)
                    BNIconButton(
                      onPressed: () => controller.clear(),
                      icon: Assets.icons.icCancel.image(),
                      size: 16,
                    ),
                  if (showSearchButton && onSubmitted != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: BNIconButton(
                        onPressed: () => onSubmitted,
                        icon: Assets.icons.icSearch.image(color: ColorName.primary),
                        size: 16,
                      ),
                    )
                ],
              ),
              hintText: hintText,
              isDense: true,
              errorText: errorMessage,
              errorMaxLines: 2,
              enabled: enabled ?? true,
              filled: true,
              fillColor: enabled ?? true ? ColorName.baseDark : ColorName.baseDark,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: ColorName.baseDark)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: ColorName.secondaryDark)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: ColorName.error)),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: ColorName.error)),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: ColorName.baseDark)),
            ));
}

class BNFormedInputBox extends TextFormField {}
