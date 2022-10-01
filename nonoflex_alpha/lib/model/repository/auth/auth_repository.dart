import 'package:nonoflex_alpha/model/data/server.dart';
import 'package:nonoflex_alpha/model/repository/auth/abs_auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository{
  @override
  Future<String> getAdminLoginCode({required String email, required String password}) {
    // TODO: implement getAdminLoginCode
    throw UnimplementedError();
  }

  @override
  Future<AuthToken> getAuthToken({required String loginCode}) {
    // TODO: implement getAuthToken
    throw UnimplementedError();
  }

  @override
  Future<String> getParticipantLoginCode({required String userCode}) {
    // TODO: implement getParticipantLoginCode
    throw UnimplementedError();
  }

  @override
  Future<AuthToken> refreshAuthToken({required String refreshToken}) {
    // TODO: implement refreshAuthToken
    throw UnimplementedError();
  }
}