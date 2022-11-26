import 'package:get/get.dart';

class Resource extends Translations{


  @override
  Map<String, Map<String, String>> get keys => {
    'ko_KR': {
      // Common

      // API Exception

      // ViewControoler Exception

      // Dialog
      'commonDialogTitle' : '',
      'commonDialogButtonOk' : '확인',
      'commonDialogButtonCancel' : '취소',

      // Splash

      // Login
      'LoginViewTitle' : '로그인',
      'LoginViewLabelParticMode' : '참여자',
      'LoginViewLabelAdminMode' : '관리자',
      'LoginViewLabelEmailField' : '아이디',
      'LoginViewLabelPasswordField' : '비밀번호',
      'LoginViewHintEmailField' : 'e-mail을 입력해주세요.',
      'LoginViewHintPasswordField' : '비밀번호를 입력해주세요.',
      'LoginViewButtonLogin' : '로그인',
      'LoginViewLabelAuthCodeField' : '인증 코드',
      'LoginViewButtonLoginUseBarcode' : '바코드로 인증하기',
    },
    // 'en_US': {
    //   'hello': 'Hallo Welt',
    // }
  };
}