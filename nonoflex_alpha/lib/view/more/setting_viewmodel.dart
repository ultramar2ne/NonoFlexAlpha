import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/conf/manager/auth_manager.dart';
import 'package:nonoflex_alpha/model/data/user.dart';

class SettingViewModel extends BaseController {
  final AuthManager _authManager;

  // 현재 유저 정보
  User? userInfo;

  SettingViewModel({AuthManager? authManager})
      : _authManager = authManager ?? locator.get<AuthManager>() {
    userInfo = _authManager.currentUser;
  }

  void onClickedLogoutButton() {}

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
    //
  }

  void goCompanyManagePage() {
    baseNavigator.goCompanyListPage();
  }

  void goAskToDeveloperPage() {}

  void goPowerUpPage() {}
}
