import 'package:flutter/material.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/conf/widgets.dart';
import 'package:nonoflex_alpha/gen/assets.gen.dart';
import 'package:nonoflex_alpha/gen/colors.gen.dart';
import 'package:nonoflex_alpha/view/login/login_viewmodel.dart';

class LoginView extends BaseFormatView {
  LoginViewModel viewModel = LoginViewModel();

  @override
  Color backgroundColor() => ColorName.primaryDark;

  @override
  Widget drawHeader() {
    return Container(
      height: MediaQuery.of(context).size.height / 6,
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 500),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Assets.images.logo.appIcon.image(width: 42),
      ),
    );
  }

  @override
  Widget drawBody() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: ColorName.base,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TabBar(
              labelPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              isScrollable: true,
              indicatorColor: ColorName.primary,
              tabs: <Widget>[
                Text(
                  '참여자',
                  style: TextStyle(color: ColorName.primary),
                ),
                Text(
                  '관리자',
                  style: TextStyle(color: ColorName.primary),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Tab(child: drawParticLoginBody()),
                  Tab(child: drawAdminLoginBody()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget drawFooter() {
    // TODO: implement drawFooter
    return Container(
      height: 80,
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 500),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: BNTextButton(
        '로그인',
        onPressed: () {},
      ),
    );
  }

  Widget drawAdminLoginBody() {
    /// 관리자 로그인 body
    /// email, pw를 통한 입력
    return SizedBox.shrink();
  }

  Widget drawParticLoginBody() {
    /// 참여자 로그인 body,
    /// qr코드 인식, 인증 코드로 로그인
    return Center(
      child: BNOutlinedButton(
        onPressed: () => viewModel.scanUserCode(),
        child: Text('바코드'),
      ),
    );
  }
}
