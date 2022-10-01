import 'package:nonoflex_alpha/model/data/user.dart';
import 'package:nonoflex_alpha/model/repository/user/abs_user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  @override
  Future<void> deleteUserData(String userCode) {
    // TODO: implement deleteUserData
    throw UnimplementedError();
  }

  @override
  Future<User> getUserDetailInfo(String userCode) {
    // TODO: implement getUserDetailInfo
    throw UnimplementedError();
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
