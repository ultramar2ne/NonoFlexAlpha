import 'package:flutter/material.dart';
import 'package:nonoflex_alpha/gen/colors.gen.dart';

/// 앱 내에서 사용될 공통 위젯들
/// 다음과 같은 항목들이 구현되어 있다.
///  - BNColoredButton
///  - BNTextButton
///  - BNOutlinedBtton
///
///

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
  BNIconButton({required VoidCallback? onPressed, required Widget icon})
      : super(
          onPressed: onPressed,
          icon: icon,
          iconSize: 24,
        );
}

class BNInputBox extends EditableText {
  BNInputBox(
      {required TextEditingController controller,
      required FocusNode focusNode,
      required TextStyle style,
      required Color cursorColor,
      required Color backgroundCursorColor})
      : super(
            controller: controller,
            focusNode: focusNode,
            style: style,
            cursorColor: cursorColor,
            backgroundCursorColor: backgroundCursorColor);
}

class BNCheckBox extends Checkbox {
  BNCheckBox({required bool? value, required ValueChanged<bool?>? onChanged})
      : super(value: value, onChanged: onChanged);
}
