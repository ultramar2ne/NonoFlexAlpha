/// 서버 기본 정보
class ServerConfig {}

/// 인증 토큰
class AuthToken {
  // 인증 토큰 : access_token
  final String accessToken;

  // 인증 토큰 만료 시간 : expires_in
  final DateTime accessExpiredAt;

  // refresh 토큰 : refresh_token
  final String refreshToken;

  // refresh 토큰 만료 시간 : refresh_token_expires_in
  final DateTime refreshExpiredAt;

  AuthToken(
      {required this.accessToken,
      required this.accessExpiredAt,
      required this.refreshToken,
      required this.refreshExpiredAt});

  AuthToken copyWith({
    String? accessToken,
    DateTime? accessExpiredAt,
    String? refreshToken,
    DateTime? refreshExpiredAt,
  }) {
    return AuthToken(
      accessToken: accessToken ?? this.accessToken,
      accessExpiredAt: accessExpiredAt ?? this.accessExpiredAt,
      refreshToken: refreshToken ?? this.refreshToken,
      refreshExpiredAt: refreshExpiredAt ?? this.refreshExpiredAt,
    );
  }

  factory AuthToken.fromJson(Map<dynamic, dynamic> data) {
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
      'expires_in': accessExpiredAt.microsecondsSinceEpoch,
      'refresh_token': refreshToken,
      'refresh_token_expires_in': refreshExpiredAt.microsecondsSinceEpoch,
    };
    return data;
  }
}

/// 토큰 발급 또는 갱신 타입
/// 로그인 코드를 통한 토큰 발급 시 [authorization_code] ,
/// refresh token을 통한 갱신 시 [refresh_token] 을 토큰 발급 요청 시
/// parameter로 포함시켜야 한다.
enum TokenType {
  authorization('auth', 'authorization_code'),
  refresh('refresh', 'refresh_token');

  const TokenType(this.code, this.serverValue);

  final String code;
  final String serverValue;

  factory TokenType.fromServer(String serverValue) {
    return TokenType.values.firstWhere((value) => value.serverValue == serverValue,
        orElse: () => TokenType.authorization);
  }
}
