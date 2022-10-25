import 'package:fluttertoast/fluttertoast.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/model/repository/auth/abs_auth_repository.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class LoginViewModel extends BaseViewModel {
  AuthRepository _authRepository;

  /// 자동 로그인 여부
  bool checkedAutoLogin = true;

  LoginViewModel({AuthRepository? authRepository})
      : _authRepository = authRepository ?? locator.get() {
    _init();
  }

  void _init() {}

  bool isValidLoginData({required String id, required String pw}) {
    /// id가 email 형식이 맞는지 확인
    /// pw가 비밀번호 기준에 맞는지 확인
    return true;
  }

  // QR 코드 스캔으로 로그인
  void scanUserCode() async {
    final result = await navigator.goScannerPage();
    if (result.runtimeType == Barcode) {
      final code = int.tryParse((result as Barcode).code ?? '');
      if (code == null || code.toString().length != 6) {
        Fluttertoast.showToast(msg: '정보가 올바르지 않습니다.\n다시 확인해주세요.');
      } else {
        login(code);
      }
    }
  }

  void login(int loginCode) async {
    // 참여자인 경우

    // 관리자인 경우
  }
}
