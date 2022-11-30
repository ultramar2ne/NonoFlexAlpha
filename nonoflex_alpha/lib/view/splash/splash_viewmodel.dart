import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/conf/manager/auth_manager.dart';
import 'package:nonoflex_alpha/model/data/user.dart';

class SplashViewModel extends BaseController {
  final AuthManager _authManager;

  // 초기화 실패 시 나타날 에러 메시지
  String? errorMessage;

  SplashViewModel({AuthManager? authManager})
      : _authManager = authManager ?? locator.get<AuthManager>() {
    // completeInitialize();
    _init();
  }

  void _init() {
    confirmIsInitialized();
  }

  // 초기 정보 확인
  void confirmIsInitialized() async {
    errorMessage = null;
    try {
      await checkNetworkConnection();
      await checkPermission();
      await checkServerStatus();

      await _authManager.initAuthInfo();
      if (_authManager.isLoggedIn) {
        // 로그인 정보가 존재할경우
        if (_authManager.currentUser!.userType == UserType.admin) {
          baseNavigator.goAdminMainPage();
        } else {
          baseNavigator.goMainPage();
        }
      } else {
        // 로그인 정보가 존재하지 않을 경우
        baseNavigator.goLoginPage();
      }
    } catch (e) {
      errorMessage = e.toString();
    }
  }
}

extension Sequence on SplashViewModel {
  // 네트워크 연결 확인
  Future<void> checkNetworkConnection() async {
    await Future.delayed(Duration(milliseconds: 1000));
  }

  // 서버 정상 동작 여부 확인
  Future<void> checkPermission() async {
    await Future.delayed(Duration(milliseconds: 1000));
  }

  // 권한 확인 (카메라 / 저장소...? /)
  Future<void> checkServerStatus() async {
    await Future.delayed(Duration(milliseconds: 1000));
  }
}
