import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/model/data/server.dart';
import 'package:nonoflex_alpha/model/source/remote_data_source.dart';

abstract class AuthRepository {
  // 로그인 코드를 통한 토큰 발급
  Future<AuthToken> getAuthToken({required String loginCode});

  // refresh token을 통한 토큰 정보 갱신
  Future<AuthToken> refreshAuthToken({required String refreshToken});

  // 관리자 로그인을 위한 로그인 코드 요청
  Future<String> getAdminLoginCode({required String email, required String password});

  // 참여자 로그인을 위한 로그인 코드 요청
  Future<String> getParticipantLoginCode({required int userCode});
}

class AuthRepositoryImpl extends AuthRepository {
  final RemoteDataSource _remoteDataSource;

  AuthRepositoryImpl({RemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? locator.get<RemoteDataSource>();

  @override
  Future<AuthToken> getAuthToken({required String loginCode}) async {
    return await _remoteDataSource.getAuthToken(
        requestType: TokenRequestType.authorization, loginCode: loginCode);
  }

  @override
  Future<AuthToken> refreshAuthToken({required String refreshToken}) async {
    return await _remoteDataSource.getAuthToken(
        requestType: TokenRequestType.refresh, refreshToken: refreshToken);
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
