import 'package:nonoflex_alpha/cmm/base.dart';

class SplashViewModel extends BaseViewModel {

  SplashViewModel() {
    _init();
  }

  void _init() async {
    // 네트워크 연결 확인
    await Future.delayed(const Duration(milliseconds: 500));

    // 서버 정상 동작 여부 확인
    await Future.delayed(const Duration(milliseconds: 500));

    // 권한 확인 (카메라 / 저장소...? /)
    await Future.delayed(const Duration(milliseconds: 500));

    // 로그인 정보가 존재할경우
    if(false) {
      // refresh_token 만료 확인
      // 토큰 정보 갱신

    } else {
      // 로그인 정보가 존재하지 않을 경우
      navigator.goLoginPage();
    }
  }
}