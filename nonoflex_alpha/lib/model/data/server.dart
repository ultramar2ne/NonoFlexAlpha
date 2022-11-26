// 서버 기본 정보
class ServerConfig {}

/// 토큰 발급 또는 갱신 타입
/// 로그인 코드를 통한 토큰 발급 시 [authorization_code] ,
/// refresh token을 통한 갱신 시 [refresh_token] 을 토큰 발급 요청 시
/// parameter로 포함시켜야 한다.
enum TokenRequestType {
  authorization,
  refresh,
}

class AuthToken {
  final String accessToken;

  final DateTime accessExpiredAt;

  final String refreshToken;

  final DateTime refreshExpiredAt;

  AuthToken(
      {required this.accessToken,
      required this.accessExpiredAt,
      required this.refreshToken,
      required this.refreshExpiredAt});

  factory AuthToken.fromJson(Map<String, dynamic> data) {
    return AuthToken(
      accessToken: data['access_token'],
      accessExpiredAt: DateTime.fromMicrosecondsSinceEpoch(data['expires_in']),
      refreshToken: data['refresh_token'],
      refreshExpiredAt: DateTime.fromMicrosecondsSinceEpoch(data['refresh_token_expires_in']),
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
      'access_token': accessToken,
      'expires_in': accessExpiredAt,
      'refresh_token': refreshToken,
      'refresh_token_expires_in': refreshExpiredAt,
    };
    return data;
  }
}

// {
// "token_type": "bearer",
// "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJST0xFIjoiUk9MRV9BRE1JTiIsImlzcyI6ImJ1ZGR5IiwiZXhwIjoxNjY0MTIzMzMzLCJpYXQiOjE2NjQxMTYxMzMsInVzZXJJZCI6MSwidXNlcm5hbWUiOiLstIjsoIjsoJXqt4Dsl7zrkaXsnbTsnqXtg5ztmZgifQ.EE2FalkL7eSlZPTwC6UM0yY8U61Nva6BAL3gW0E5368",
// "expires_in": 1664123333000,
// "refresh_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJST0xFIjoiUk9MRV9BRE1JTiIsImlzcyI6ImJ1ZGR5IiwiZXhwIjoxNjk1NjUyMTMzLCJpYXQiOjE2NjQxMTYxMzMsInVzZXJJZCI6MSwidXNlcm5hbWUiOiLstIjsoIjsoJXqt4Dsl7zrkaXsnbTsnqXtg5ztmZgifQ.u_fUHQuVw45BsEuBdq8NxWKSy8qrtMGLIOg9w_b9NuE",
// "refresh_token_expires_in": 1695652133000
// }
