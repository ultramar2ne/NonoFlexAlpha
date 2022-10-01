// 서버 기본 정보
class ServerConfig {}

enum TokenRequestType { authorization, refresh }

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
}

// {
// "token_type": "bearer",
// "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJST0xFIjoiUk9MRV9BRE1JTiIsImlzcyI6ImJ1ZGR5IiwiZXhwIjoxNjY0MTIzMzMzLCJpYXQiOjE2NjQxMTYxMzMsInVzZXJJZCI6MSwidXNlcm5hbWUiOiLstIjsoIjsoJXqt4Dsl7zrkaXsnbTsnqXtg5ztmZgifQ.EE2FalkL7eSlZPTwC6UM0yY8U61Nva6BAL3gW0E5368",
// "expires_in": 1664123333000,
// "refresh_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJST0xFIjoiUk9MRV9BRE1JTiIsImlzcyI6ImJ1ZGR5IiwiZXhwIjoxNjk1NjUyMTMzLCJpYXQiOjE2NjQxMTYxMzMsInVzZXJJZCI6MSwidXNlcm5hbWUiOiLstIjsoIjsoJXqt4Dsl7zrkaXsnbTsnqXtg5ztmZgifQ.u_fUHQuVw45BsEuBdq8NxWKSy8qrtMGLIOg9w_b9NuE",
// "refresh_token_expires_in": 1695652133000
// }
