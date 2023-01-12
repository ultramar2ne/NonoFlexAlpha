import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/cmm/ui/dialog.dart';
import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/conf/manager/auth_manager.dart';
import 'package:nonoflex_alpha/model/data/user.dart';
import 'package:nonoflex_alpha/model/repository/auth/auth_repository.dart';

class SettingViewModel extends BaseController {
  final AuthRepository _authRepository;
  final AuthManager _authManager;

  // 현재 유저 정보
  User? userInfo;

  SettingViewModel({AuthManager? authManager, AuthRepository? authRepository})
      : _authManager = authManager ?? locator.get<AuthManager>(),
        _authRepository = authRepository ?? locator.get<AuthRepository>() {
    userInfo = _authManager.currentUser;
  }

  init() async {
    userInfo = await _authRepository.getCurrentUserInfo();
    update();
  }

  void onClickedLogoutButton() async {
    if (!await Get.confirmDialog('정말 로그아웃 하시겠습니까?')) return;
    await _authManager.clearAuthInfo();
    baseNavigator.goLoginPage();
  }

  void goUserManagePage(UserType userType) {
    switch (userType) {
      case UserType.none:
        return;
      case UserType.admin:
        baseNavigator.goUserListPage();
        break;
      case UserType.participant:
        baseNavigator.goParticipantListPage();
        break;
    }
  }

  void goAddNewProductPage() {
    baseNavigator.goAddProductPage();
  }

  void goBarcodeSettingPage() {
    baseNavigator.goManageProductBarcodePage();
  }

  void goDocumentPrintPage() {
    baseNavigator.goMakeExcelPage();
  }

  void goCompanyManagePage() {
    baseNavigator.goCompanyListPage();
  }

  void goAskToDeveloperPage() {
    baseNavigator.goDeveloperInfoPage();
  }

  void goPowerUpPage() {
    Get.toast('힘내라 얍얍 페이지는 준비중입니다!');
  }
}
