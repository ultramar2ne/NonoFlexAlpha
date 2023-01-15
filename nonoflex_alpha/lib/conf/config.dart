import 'package:nonoflex_alpha/model/data/server.dart';
import 'package:nonoflex_alpha/model/data/user.dart';

class Configs {
  // 서버 설정 정보
  static const serverAddress = 'nonoflex.com';
  static const portNum = '3000';
  static const version = 'v1';

  // static const serverAddress = 'santa-house.tplinkdns.com';
  // static const portNum = '3000';
  // static const version = 'v1';

  // static const serverAddress = '3.39.53.3';
  // static const portNum = '3000';
  // static const version = 'v1';

  // static const serverAddress = 'api.nonoflex.com';
  // static const portNum = '443';
  // static const version = 'v1';

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
