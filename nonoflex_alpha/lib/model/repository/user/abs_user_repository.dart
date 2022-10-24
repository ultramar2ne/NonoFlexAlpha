import 'package:nonoflex_alpha/model/data/user.dart';

abstract class UserRepository {
  // 참여자 등록
  Future<User> registerParticipant({required String name});

  // 사용자 목록 조회
  Future<UserList> getUserList({String? searchValue});

  // 사용자 상세 정보 조회
  Future<User> getUserDetailInfo(String userCode);

  // 사용자 정보 수정
  Future<void> updateUserInfo(User user);

  // 사용자 정보 삭제
  Future<void> deleteUserData(String userCode);
}