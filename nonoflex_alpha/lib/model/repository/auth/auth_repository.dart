import 'dart:convert';

import 'package:nonoflex_alpha/cmm/utils.dart';
import 'package:nonoflex_alpha/conf/config.dart';
import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/model/data/server.dart';
import 'package:nonoflex_alpha/model/data/user.dart';
import 'package:nonoflex_alpha/model/source/local_data_source.dart';
import 'package:nonoflex_alpha/model/source/remote_data_source.dart';

abstract class AuthRepository {
  /// 현재 로그인되어있는 유저의 정보를 불러온다.
  Future<User?> getCurrentUserInfo();

  /// 로컬 저장소에 존재하는 토큰 정보를 불러온다.
  Future<AuthToken?> getCurrentTokeInfo();

  /// 로컬 저장소에 존재하는 인증 관련 정보를 초기화한다.
  Future<void> clearCurrentAuthInfo();

  /// 로그인 코드를 통한 토큰 발급
  Future<AuthToken> getAuthToken({required String loginCode});

  /// refresh token을 통한 토큰 정보 갱신
  Future<AuthToken> refreshAuthToken({required String refreshToken});

  /// 관리자 로그인을 위한 로그인 코드 요청
  Future<String> getAdminLoginCode({required String email, required String password});

  /// 참여자 로그인을 위한 로그인 코드 요청
  Future<String> getParticipantLoginCode({required int userCode});
}

class AuthRepositoryImpl extends AuthRepository {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;
  Configs _config;

  AuthRepositoryImpl(
      {RemoteDataSource? remoteDataSource, LocalDataSource? localDataSource, Configs? config})
      : _remoteDataSource = remoteDataSource ?? locator.get<RemoteDataSource>(),
        _localDataSource = localDataSource ?? locator.get<LocalDataSource>(),
        _config = config ?? locator.get<Configs>();

  @override
  Future<User?> getCurrentUserInfo() async {
    return await _localDataSource.getUserInfo();
  }

  @override
  Future<AuthToken?> getCurrentTokeInfo() async {
    return await _localDataSource.getTokenInfo();
  }

  @override
  Future<void> clearCurrentAuthInfo() async {
    await _localDataSource.deleteUserInfo();
    await _localDataSource.deleteTokenInfo();
  }

  @override
  Future<AuthToken> getAuthToken({required String loginCode}) async {
    final authToken = await _remoteDataSource.getAuthToken(
        requestType: TokenRequestType.authorization, loginCode: loginCode);

    try {
      final payload = Utils.parseJwt(authToken.accessToken);
      if (payload['userId'] != null) {
        _config.updateTokenInfo(authToken);
        final userCode = payload['userId'];
        final userInfo = await _remoteDataSource.getUserDetailInfo(userCode);

        await _localDataSource.addTokenInfo(authToken);
        await _localDataSource.addUserInfo(userInfo);

        return authToken;
      }
      throw('');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthToken> refreshAuthToken({required String refreshToken}) async {
    final authToken = await _remoteDataSource.getAuthToken(
        requestType: TokenRequestType.refresh, refreshToken: refreshToken);
    await _localDataSource.updateTokenInfo(authToken);
    return authToken;
  }

  @override
  Future<String> getAdminLoginCode({required String email, required String password}) async {
    return await _remoteDataSource.getLoginCode(id: email, pw: password);
  }

  @override
  Future<String> getParticipantLoginCode({required int userCode}) async {
    return await _remoteDataSource.getLoginCodeByUserCode(userCode: userCode);
  }
}
