import 'package:nonoflex_alpha/model/data/server.dart';

abstract class AuthRepository {
  // 로그인 코드를 통한 토큰 발급
  Future<AuthToken> getAuthToken({required String loginCode});

  // refresh token을 통한 토큰 정보 갱신
  Future<AuthToken> refreshAuthToken({required String refreshToken});

  // 관리자 로그인을 위한 로그인 코드 요청
  Future<String> getAdminLoginCode({required String email, required String password});

  // 참여자 로그인을 위한 로그인 코드 요청
  Future<String> getParticipantLoginCode({required String userCode});
}
