import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/conf/ui/widgets.dart';
import 'package:nonoflex_alpha/gen/colors.gen.dart';
import 'package:nonoflex_alpha/gen/fonts.gen.dart';
import 'package:nonoflex_alpha/view/login/login_viewmodel.dart';

import 'package:get/get.dart';

class LoginView extends BaseGetView<LoginViewModel> {
  @override
  Widget drawBody() {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      constraints: const BoxConstraints(maxWidth: 500, maxHeight: 800),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 50),
      child: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'LoginViewTitle'.tr,
                  style: theme.title,
                ),
                // Assets.images.logo.appIcon.image(width: 100),
                Container(
                  decoration: BoxDecoration(
                    color: ColorName.base,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TabBar(
                    labelPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    isScrollable: true,
                    indicatorColor: ColorName.primary,
                    indicator: BoxDecoration(
                      color: theme.baseDark,
                      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                    ),
                    tabs: <Widget>[
                      Expanded(
                        child: Text(
                          'LoginViewLabelParticMode'.tr,
                          style: theme.normal.copyWith(color: theme.primary),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'LoginViewLabelAdminMode'.tr,
                          style: theme.normal.copyWith(color: theme.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: ColorName.base,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TabBarView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Tab(child: drawParticLoginBody()),
                    Tab(child: drawAdminLoginBody()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 관리자 로그인 관련 ui
extension LoginViewExtForAdminMode on LoginView {
  // 관리자 영역 body 부분 ui
  Widget drawAdminLoginBody() {
    /// 관리자 로그인 body
    /// email, pw를 통한 입력
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        margin: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                'LoginViewLabelEmailField'.tr,
                style: theme.label,
              ),
            ),
            BNInputBox(
              controller: controller.emailEditingController,
              onChanged: (value) {},
              hintText: 'LoginViewHintEmailField'.tr,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                'LoginViewLabelPasswordField'.tr,
                style: theme.label,
              ),
            ),
            BNInputBox(
              controller: controller.passwordEditingController,
              onChanged: (value) => controller.onChangedUserPassword(value),
              hintText: 'LoginViewHintPasswordField'.tr,
              obscureText: true,
            ),
            const SizedBox(height: 60),
            Container(
              height: 52,
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 500),
              child: BNColoredButton(
                child: Text(
                  'LoginViewButtonLogin'.tr,
                  style: theme.button.copyWith(color: theme.base),
                ),
                onPressed: () => controller.loginWidthId(),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

/// 참여자 로그인 관련 ui
extension LoginViewExtForParticMode on LoginView {
  // 참여자 로그인 body 영역 ui
  Widget drawParticLoginBody() {
    /// 참여자 로그인 body,
    /// qr코드 인식, 인증 코드로 로그인
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        margin: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(
                'LoginViewLabelAuthCodeField'.tr,
                style: theme.label,
              ),
            ),
            Container(
                padding: const EdgeInsets.symmetric(vertical: 30),
                decoration: const BoxDecoration(
                  color: ColorName.baseDark,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                child: _drawAuthCodePanel()),
            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: BNOutlinedButton(
                onPressed: () => controller.scanUserCode(),
                child: Text('LoginViewButtonLoginUseBarcode'.tr,
                    style: theme.button.copyWith(color: theme.primary)),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 52,
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 500),
              child: BNColoredButton(
                child: Text('LoginViewButtonLogin'.tr,
                    style: theme.button.copyWith(color: theme.base)),
                onPressed: () {
                  // controller.change('',status: RxStatus.loading());
                  // stateController.updateLoadingState(!stateController.isLoading.value);
                },
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  /// 6자리 인증 코드 입력 ui
  Widget _drawAuthCodePanel() {
    Widget codeInputBox(FocusNode node, TextEditingController controller,
        {bool isLast = false, FocusNode? nextNode}) {
      const inputTextStyle = TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
      );

      const boxDeco = InputDecoration(
        isDense: true,
        counterText: '',
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(color: ColorName.secondaryDark, width: 2),
        ),
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.all(Radius.circular(8.0)),
        //   borderSide: BorderSide(color: ColorName.baseDark, width: 3),
        // ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(color: ColorName.primaryDark, width: 3),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(color: ColorName.error, width: 3),
        ),
      );

      return Container(
        width: 42,
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 3),
        alignment: Alignment.center,
        child: TextField(
          maxLength: 2,
          keyboardType: TextInputType.number,
          showCursor: false,
          textAlign: TextAlign.center,
          style: inputTextStyle,
          decoration: boxDeco,
          controller: controller,
          focusNode: node,
          enableSuggestions: false,
          onChanged: (value) {
            if (value.isNotEmpty) {
              if (int.tryParse(value) == null) {
                controller.text = '';
                return;
              }
              final newValue = value.length == 2 ? value.substring(1) : value;
              controller.text = newValue;
              if (nextNode != null) {
                // FocusScope.of(this.).requestFocus(nextNode);
              } else {
                // FocusScope.of(context).unfocus();
              }
            }
          },
          onTap: () {
            controller.text = '';
          },
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        codeInputBox(
          controller.codeInputNodeList[0],
          controller.codeInputControllerList[0],
          nextNode: controller.codeInputNodeList[1],
        ),
        codeInputBox(
          controller.codeInputNodeList[1],
          controller.codeInputControllerList[1],
          nextNode: controller.codeInputNodeList[2],
        ),
        codeInputBox(
          controller.codeInputNodeList[2],
          controller.codeInputControllerList[2],
          nextNode: controller.codeInputNodeList[3],
        ),
        const SizedBox(width: 8),
        codeInputBox(
          controller.codeInputNodeList[3],
          controller.codeInputControllerList[3],
          nextNode: controller.codeInputNodeList[4],
        ),
        codeInputBox(
          controller.codeInputNodeList[4],
          controller.codeInputControllerList[4],
          nextNode: controller.codeInputNodeList[5],
        ),
        codeInputBox(
          controller.codeInputNodeList[5],
          controller.codeInputControllerList[5],
          isLast: true,
        ),
      ],
    );
  }
}
