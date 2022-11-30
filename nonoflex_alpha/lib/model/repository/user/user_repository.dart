import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/model/data/user.dart';
import 'package:nonoflex_alpha/model/source/local_data_source.dart';
import 'package:nonoflex_alpha/model/source/remote_data_source.dart';

abstract class UserRepository {
  /// 참여자 등록
  Future<User> registerParticipant({required String name});

  /// 사용자 목록 조회
  Future<UserList> getUserList({String? searchValue});

  /// 사용자 상세 정보 조회
  Future<User> getUserDetailInfo(int userCode);

  /// 사용자 정보 수정
  Future<void> updateUserInfo(User user);

  /// 사용자 정보 삭제
  Future<void> deleteUserData(String userCode);
}

class UserRepositoryImpl extends UserRepository {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;

  UserRepositoryImpl({RemoteDataSource? remoteDataSource, LocalDataSource? localDataSource})
      : _remoteDataSource = remoteDataSource ?? locator.get<RemoteDataSource>(),
        _localDataSource = localDataSource ?? locator.get<LocalDataSource>();

  @override
  Future<void> deleteUserData(String userCode) {
    // TODO: implement deleteUserData
    throw UnimplementedError();
  }

  @override
  Future<User> getUserDetailInfo(int userCode) async {
    final userInfo = await _remoteDataSource.getUserDetailInfo(userCode);
    await _localDataSource.updateUserInfo(userInfo);
    return userInfo;
  }

  @override
  Future<UserList> getUserList({String? searchValue}) {
    // TODO: implement getUserList
    throw UnimplementedError();
  }

  @override
  Future<User> registerParticipant({required String name}) {
    // TODO: implement registerParticipant
    throw UnimplementedError();
  }

  @override
  Future<void> updateUserInfo(User user) {
    // TODO: implement updateUserInfo
    throw UnimplementedError();
  }
}
