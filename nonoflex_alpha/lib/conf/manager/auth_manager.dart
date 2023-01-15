import 'package:nonoflex_alpha/cmm/utils.dart';
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
    try {
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
        final payload = Utils.parseJwt(_config.accessToken!);
        if (payload['userId'] != null && payload['username'] != null && payload['ROLE'] != null) {
          final userCode = payload['userId'];
          final userName = payload['username'];
          final userType = payload['ROLE'];

          final loggedInUser = User(
              userCode: userCode,
              id: '',
              userName: userName,
              userType: UserType.fromServer(userType));
          currentUser = loggedInUser;
        }

        if (user.isActive) {
          _config.updateUserInfo(user);
          currentUser = user;
        }
      }

      if (currentUser == null || authToken == null) {
        currentUser = null;
        authToken = null;
        await _authRepository.clearCurrentAuthInfo();
      }
    } catch (e) {
      currentUser = null;
      authToken = null;
      await _authRepository.clearCurrentAuthInfo();
    }
  }

  Future<void> refreshTokenInfo() async {
    AuthToken? token = authToken ?? await _authRepository.getCurrentTokeInfo();
    final currentDate = DateTime.now();
    if (token != null) {
      if (token.accessExpiredAt.isBefore(currentDate)) return;
      if (token.accessExpiredAt.isAfter(currentDate) &&
          token.refreshExpiredAt.isBefore(currentDate)) {
        token = await _authRepository.refreshAuthToken(refreshToken: token.refreshToken);
        _config.updateTokenInfo(token);
        authToken = token;
      }
    } else {
      throw ('토큰 정보가 존재하지 않습니다.');
    }
  }

  Future<void> clearAuthInfo() async {
    currentUser = null;
    authToken = null;
    await _authRepository.clearCurrentAuthInfo();
  }
}
