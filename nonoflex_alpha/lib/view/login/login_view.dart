import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/conf/widgets.dart';
import 'package:nonoflex_alpha/gen/colors.gen.dart';
import 'package:nonoflex_alpha/gen/fonts.gen.dart';
import 'package:nonoflex_alpha/view/login/login_viewmodel.dart';

class LoginView extends BaseFormatView {
  LoginViewModel viewModel = LoginViewModel();

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
          // crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '로그인',
                  style: TextStyle(
                    color: ColorName.textColorDark,
                    fontFamily: FontFamily.notoSansKR,
                    fontWeight: FontWeight.w700,
                    fontSize: 38,
                  ),
                ),
                // Assets.images.logo.appIcon.image(width: 100),
                Container(
                  decoration: BoxDecoration(
                    color: ColorName.base,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const TabBar(
                    labelPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    isScrollable: true,
                    indicatorColor: ColorName.primary,
                    indicator: BoxDecoration(
                        color: ColorName.baseDark,
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    tabs: <Widget>[
                      Expanded(
                        child: Text(
                          '참여자',
                          style: TextStyle(color: ColorName.primary),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          '관리자',
                          style: TextStyle(color: ColorName.primary),
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

  // @override
  // Widget drawFooter() {
  //   // TODO: implement drawFooter
  //   return Container(
  //     height: 80,
  //     width: double.infinity,
  //     constraints: const BoxConstraints(maxWidth: 500),
  //     padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
  //     child: BNColoredButton(
  //       child: Text('로그인'),
  //       onPressed: () {},
  //     ),
  //   );
  // }

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
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text(
                '아이디',
                style: TextStyle(
                    fontFamily: FontFamily.notoSansKR,
                    fontSize: 12,
                    color: ColorName.textHint
                ),
              ),
            ),
            BNInputBox(
              controller: TextEditingController(),
              onChanged: (value) {},
              hintText: 'e-mail을 입력해주세요.',
              showClearButton: true,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text(
                '비밀번호',
                style: TextStyle(
                  fontFamily: FontFamily.notoSansKR,
                  fontSize: 12,
                  color: ColorName.textHint
                ),
              ),
            ),
            BNInputBox(
              controller: TextEditingController(),
              onChanged: (value) {},
              hintText: '비밀번호를 입력해주세요.',
              obscureText: true,
              showClearButton: true,
            ),
            const SizedBox(height: 50),
            Container(
              height: 52,
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 500),
              child: BNColoredButton(
                child: Text('로그인'),
                onPressed: () {
                  stateController.updateLoadingState(!stateController.isLoading.value);
                },
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

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
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text(
                '인증코드',
                style: TextStyle(
                    fontFamily: FontFamily.notoSansKR,
                    fontSize: 12,
                    color: ColorName.textHint
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: _drawAuthCodePanel(),
                decoration: const BoxDecoration(
                  color: ColorName.baseDark,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                )),
            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: BNOutlinedButton(
                onPressed: () => viewModel.scanUserCode(),
                child: Text('바코드로 인증하기'),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 52,
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 500),
              child: BNColoredButton(
                child: Text('로그인'),
                onPressed: () {
                  stateController.updateLoadingState(!stateController.isLoading.value);
                },
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

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
                FocusScope.of(context).requestFocus(nextNode);
              } else {
                FocusScope.of(context).unfocus();
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
          viewModel.codeInputNodeList[0],
          viewModel.codeInputControllerList[0],
          nextNode: viewModel.codeInputNodeList[1],
        ),
        codeInputBox(
          viewModel.codeInputNodeList[1],
          viewModel.codeInputControllerList[1],
          nextNode: viewModel.codeInputNodeList[2],
        ),
        codeInputBox(
          viewModel.codeInputNodeList[2],
          viewModel.codeInputControllerList[2],
          nextNode: viewModel.codeInputNodeList[3],
        ),
        const SizedBox(width: 8),
        codeInputBox(
          viewModel.codeInputNodeList[3],
          viewModel.codeInputControllerList[3],
          nextNode: viewModel.codeInputNodeList[4],
        ),
        codeInputBox(
          viewModel.codeInputNodeList[4],
          viewModel.codeInputControllerList[4],
          nextNode: viewModel.codeInputNodeList[5],
        ),
        codeInputBox(
          viewModel.codeInputNodeList[5],
          viewModel.codeInputControllerList[5],
          isLast: true,
        ),
      ],
    );
  }
}
