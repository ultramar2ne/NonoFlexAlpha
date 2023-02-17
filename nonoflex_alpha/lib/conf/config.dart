import 'package:nonoflex_alpha/model/data/server.dart';
import 'package:nonoflex_alpha/model/data/user.dart';

class Configs {
  // 서버 설정 정보


  // 토큰 정보
  String? accessToken;
  String? refreshToken;
  AuthToken? authToken;

  updateTokenInfo(AuthToken authToken) {
    accessToken = authToken.accessToken;
    refreshToken = authToken.refreshToken;
    this.authToken = authToken;
  }

  // 유저 정보
  bool isAdminMode = false;
  User? user;

  updateUserInfo(User user) {
    isAdminMode = user.userType == UserType.admin;
  }
}
