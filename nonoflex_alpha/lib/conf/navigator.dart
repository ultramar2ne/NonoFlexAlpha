import 'package:get/get.dart';
import 'package:nonoflex_alpha/view/login/login_view.dart';
import 'package:nonoflex_alpha/view/notice/add_notice_view.dart';
import 'package:nonoflex_alpha/view/notice/notice_detail_view.dart';
import 'package:nonoflex_alpha/view/notice/notice_list_view.dart';
import 'package:nonoflex_alpha/view/notice/notice_list_viewmodel.dart';
import 'package:nonoflex_alpha/view/splash/splash_view.dart';

class NonoNavigatorManager {

  Future<dynamic> goSplashPage() async {
    const path = '/';

    return await Get.to(SplashView(), routeName: path, transition: Transition.fade);
  }

  Future<dynamic> goLoginPage() async {
    const path = '/login';

    return await Get.to(LoginView(), routeName: path, transition: Transition.fade);
  }

  Future<dynamic> goNoticeListPage() async {
    const path = '/notice';

    return await Get.to(NoticeListView(), routeName: path, transition: Transition.rightToLeft);
  }

  Future<dynamic> goAddNoticePage() async {
    const path = '/notice/add';

    return await Get.to(AddNoticeView(), routeName: path, transition: Transition.downToUp);
  }

  Future<dynamic> goNoticeDetailPage(int noticeId) async {
    const path = '/notice/detail';

    return await Get.to(
      NoticeDetailView(),
      routeName: path,
      arguments: {'noticeId': noticeId.toString()},
    );
  }
}
