import 'package:nonoflex_alpha/model/data/user.dart';
import 'package:nonoflex_alpha/model/repository/user/abs_user_repository.dart';

class UserRepositoryImpl extends UserRepository{
  @override
  Future<void> deleteUserData() {
    // TODO: implement deleteUserData
    throw UnimplementedError();
  }

  @override
  Future<User> getUserDetailInfo({required String userCode}) {
    // TODO: implement getUserDetailInfo
    throw UnimplementedError();
  }

  @override
  Future<UserList> getUserList() {
    // TODO: implement getUserList
    throw UnimplementedError();
  }

  @override
  Future<void> registerParticipant({required String name}) {
    // TODO: implement registerParticipant
    throw UnimplementedError();
  }

  @override
  Future<void> updateUserInfo() {
    // TODO: implement updateUserInfo
    throw UnimplementedError();
  }
}