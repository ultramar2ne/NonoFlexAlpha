import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/conf/exception/api_excetion.dart';
import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/model/repository/auth/auth_repository.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class LoginViewModel extends BaseController {
  AuthRepository _authRepository;

  List<FocusNode> codeInputNodeList = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode()
  ];

  List<TextEditingController> codeInputControllerList = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  /// 자동 로그인 여부
  bool checkedAutoLogin = true;

  // 관리자 이메일
  final TextEditingController emailEditingController = TextEditingController();

  // 관리자 비밀번호
  final TextEditingController passwordEditingController = TextEditingController();

  /// 인증번호 입력 controller
  final authCodeInputcontroller = TextEditingController();

  LoginViewModel({AuthRepository? authRepository})
      : _authRepository = authRepository ?? locator.get<AuthRepository>() {
    _init();
  }

  void _init() {
    completeInitialize();
  }

  bool isValidLoginData({required String id, required String pw}) {
    /// id가 email 형식이 맞는지 확인
    /// pw가 비밀번호 기준에 맞는지 확인
    return true;
  }

  // QR 코드 스캔으로 로그인
  void scanUserCode() async {
    final result = await baseNavigator.goAdminMainPage();
    if (result.runtimeType == Barcode) {
      final code = int.tryParse((result as Barcode).code ?? '');
      if (code == null || code.toString().length != 6) {
        Fluttertoast.showToast(msg: '정보가 올바르지 않습니다.\n다시 확인해주세요.');
      } else {}
    }
  }
}

extension LoginViewModelForPartic on LoginViewModel {
  // 인증코드를 활용한 참여자 로그인
  void loginWidthCode() {}
}

extension LoginViewModelForAdmin on LoginViewModel {
  void onChangedUserEmail(String value) {}

  void onChangedUserPassword(String value) {}

  // 아이디, 비밀번호를 활용한 관리자 로그인
  void loginWidthId() async {
    changeViewState(TaskState.doing);
    try {
      final loginCode = await _authRepository.getAdminLoginCode(
          email: emailEditingController.value.text, password: passwordEditingController.value.text);
      await _authRepository.getAuthToken(loginCode: loginCode);

      changeViewState(TaskState.success);
      baseNavigator.goAdminMainPage();
    } on APIException catch (e) {
      changeViewState(TaskState.success);
    } catch (e){
      changeViewState(TaskState.success);
    }
  }
}
