import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';

class AdminHomeViewModel extends BaseController {
  AdminHomeViewModel() {
    completeInitialize();
  }

  void goNoticeListPage() async {
    await baseNavigator.goNoticeListPage();
    // 공지사항 목록 리프레쉬
  }
}
