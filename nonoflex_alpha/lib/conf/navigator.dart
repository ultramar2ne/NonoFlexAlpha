import 'package:get/get.dart';
import 'package:nonoflex_alpha/view/login/login_view.dart';
import 'package:nonoflex_alpha/view/login/login_viewmodel.dart';
import 'package:nonoflex_alpha/view/notice/add_notice_view.dart';
import 'package:nonoflex_alpha/view/notice/notice_detail_view.dart';
import 'package:nonoflex_alpha/view/notice/notice_list_view.dart';
import 'package:nonoflex_alpha/view/splash/splash_view.dart';
import 'package:nonoflex_alpha/view/splash/splash_viewmodel.dart';
import 'package:nonoflex_alpha/view/util/scanner_view.dart';

class NonoNavigatorManager {

  // ==== Splash ====
  Future<dynamic> goSplashPage() async {
    const path = '/';

    Get.put(SplashViewModel());
    return await Get.to(SplashView(), routeName: path, transition: Transition.fade);
  }

  // ==== Login ====
  Future<dynamic> goLoginPage() async {
    const path = '/login';

    Get.put(LoginViewModel());
    return await Get.off(LoginView(), routeName: path, transition: Transition.fade);
  }

  // ==== Main ====
  Future<dynamic> goMainPage() async {
    const path = '/main';

    Get.put(LoginViewModel());
    return await Get.off(LoginView(), routeName: path, transition: Transition.fade);
  }

  Future<dynamic> goAdminMainPage() async {
    const path = '/admin/main';

    Get.put(LoginViewModel());
    return await Get.off(LoginView(), routeName: path, transition: Transition.fade);
  }

  // ==== Notice ====
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

  // ==== Utils ====
  Future<dynamic> goScannerPage() async {
    const path = '/app/scanner';

    return await Get.to(ScannerView(), routeName: path, transition: Transition.downToUp);
  }
}
