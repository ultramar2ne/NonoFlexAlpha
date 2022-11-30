import 'package:nonoflex_alpha/model/data/server.dart';

class Configs {
  // 서버 설정 정보
  static const serverAddress = '3.39.53.3';
  static const portNum = '3000';
  static const version = 'v1';

  // 토큰 정보
  String? accessToken;
  String? refreshToken;

  updateTokenInfo(AuthToken authToken) {
    accessToken = authToken.accessToken;
    refreshToken = authToken.refreshToken;
  }
}
