import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/cmm/ui/dialog.dart';
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

  final emailErrorMessage = ''.obs;

  // 관리자 비밀번호
  final TextEditingController passwordEditingController = TextEditingController();

  final passwordErrorMessage = ''.obs;

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
    final result = await baseNavigator.goScannerPage();
    if (result.runtimeType == Barcode) {
      final code = int.tryParse((result as Barcode).code ?? '');
      if (code == null || code
          .toString()
          .length != 6) {
        Get.toast('정보가 올바르지 않습니다.\n다시 확인해주세요.');
      } else {
        loginWidthCode(result.code!);
      }
    }
  }

  void insertUserCode() {
    final code = [0, 0, 0, 0, 0, 0];
    for (int i = 0; i < codeInputControllerList.length; i++) {
      final num = int.tryParse(codeInputControllerList[i].text);
      if (num == null || codeInputControllerList[i].text.length > 2) {
        Get.alertDialog('입력된 정보가 유효하지 않습니다.\n숫자 6자리가 입력되었는지 확인 해 주세요.');
        return;
      }
      code[i] = num;
    }
    loginWidthCode(code.join(''));

  }
}

extension LoginViewModelForPartic on LoginViewModel {
  // 인증코드를 활용한 참여자 로그인
  void loginWidthCode(String value) async {
    changeViewState(TaskState.doing);
    try {
      await _authRepository.getAuthToken(loginCode: value);
      changeViewState(TaskState.success);
      final user = await _authRepository.getCurrentUserInfo();
      if (user != null){
        Get.toast('${user.userName} 님 환영합니다!');
      }
      if (configs.isAdminMode) {
        baseNavigator.goAdminMainPage();
      } else {
        baseNavigator.goParticMainPage();
      }
    } on APIException catch (e) {
      Get.toast('회원정보가 올바르지 않습니다. 다시 시도해주세요.');
      logger.e(e);
      changeViewState(TaskState.success);
    } catch (e) {
      Get.toast('회원정보가 올바르지 않습니다. 다시 시도해주세요.');
      logger.e(e);
      changeViewState(TaskState.success);
    }
  }
}

extension LoginViewModelForAdmin on LoginViewModel {
  void onChangedUserEmail(String value) {
    // if (value.contains(' ')) {
    //   emailEditingController.text = emailEditingController.text.replaceAll(' ', '');
    // }
    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value) ||
        value.contains(' ')) {
      emailErrorMessage.value = '이메일 형식이 아닙니다.';
    } else {
      emailErrorMessage.value = '';
    }
  }

  void onChangedUserPassword(String value) {
    passwordErrorMessage.value = '';
    // if (value.length < 10) {
    //   emailErrorMessage.value = '';
    // }
  }

  // 아이디, 비밀번호를 활용한 관리자 로그인
  void loginWidthId() async {
    if (emailEditingController.text.isEmpty) {
      emailErrorMessage.value = '아이디를 입력 해 주세요!';
      return;
    }

    if (passwordEditingController.text.isEmpty) {
      passwordErrorMessage.value = '비밀번호를 입력 해 주세요!';
      return;
    }

    if (emailErrorMessage.value.isNotEmpty || passwordErrorMessage.value.isNotEmpty) {
      Get.toast('입력된 정보가 올바르지 않습니다.');
      return;
    }

    changeViewState(TaskState.doing);
    try {
      final id = emailEditingController.value.text.replaceAll(' ', '');
      final pw = passwordEditingController.value.text.replaceAll(' ', '');
      final loginCode = await _authRepository.getAdminLoginCode(email: id, password: pw);
      await _authRepository.getAuthToken(loginCode: loginCode);

      changeViewState(TaskState.success);
      final user = await _authRepository.getCurrentUserInfo();
      if (user != null){
        Get.toast('${user.userName} 님 환영합니다!');
      }
      baseNavigator.goAdminMainPage();
    } on APIException catch (e) {
      //TODO: 에러처리
      logger.e(e);
      changeViewState(TaskState.success);
      Get.toast('회원정보가 올바르지 않습니다. 다시 시도해주세요.');
    } catch (e) {
      logger.e(e);
      changeViewState(TaskState.success);
      Get.toast('회원정보가 올바르지 않습니다. 다시 시도해주세요.');
    }
  }
}
