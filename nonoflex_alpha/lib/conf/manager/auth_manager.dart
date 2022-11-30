import 'package:nonoflex_alpha/conf/config.dart';
import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/model/data/server.dart';
import 'package:nonoflex_alpha/model/data/user.dart';
import 'package:nonoflex_alpha/model/repository/auth/auth_repository.dart';
import 'package:nonoflex_alpha/model/repository/user/user_repository.dart';

class AuthManager {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final Configs _config;

  // 현재 로그인되어있는 유저
  User? currentUser;

  // 토큰 정보
  AuthToken? authToken;

  /// 로그인 여부
  bool get isLoggedIn => currentUser != null && authToken != null;

  AuthManager({AuthRepository? authRepository, UserRepository? userRepository, Configs? config})
      : _authRepository = authRepository ?? locator.get<AuthRepository>(),
        _userRepository = userRepository ?? locator.get<UserRepository>(),
        _config = config ?? locator.get<Configs>() {
    // init();
  }

  Future<void> initAuthInfo() async {
    // 토큰 정보
    AuthToken? token = await _authRepository.getCurrentTokeInfo();
    if (token != null) {
      if (token.refreshExpiredAt.isBefore(DateTime.now())) {
        token = await _authRepository.refreshAuthToken(refreshToken: token.refreshToken);
        _config.updateTokenInfo(token);
        authToken = token;
      }
    }

    // 현재 유저 정보
    User? user = await _authRepository.getCurrentUserInfo();
    if (user != null && _config.accessToken != null) {
      user = await _userRepository.getUserDetailInfo(user.userCode);
      if (user.isActive) {
        currentUser = user;
      }
    }

    if (currentUser == null || token == null) {
      currentUser = null;
      authToken = null;
      await _authRepository.clearCurrentAuthInfo();
    }
  }
}
