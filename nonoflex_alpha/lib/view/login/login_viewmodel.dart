import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/model/repository/auth/abs_auth_repository.dart';

class LoginViewModel extends BaseViewModel {
  AuthRepository _authRepository;

  /// 자동 로그인 여부
  bool checkedAutoLogin = false;
  
  /// 로그인 탭 바 컨트롤러
  final TabController controller = TabController(length: 2, vsync: this);

  LoginViewModel({AuthRepository? authRepository})
      : _authRepository = authRepository ?? locator.get(){
    _init();
  }

  void _init(){

  }

}

// 관리자 로그인 관련 기능
extension LoginViewModelExtForAdminLogin on LoginViewModel {

  bool isValidLoginData({required String id, required String pw}){
    /// id가 email 형식이 맞는지 확인
    /// pw가 비밀번호 기준에 맞는지 확인
    return true;
  }



}

// 참여자 로그인 관련 기능
extension LoginViewModelExtForParticLogin on LoginViewModel {

}
