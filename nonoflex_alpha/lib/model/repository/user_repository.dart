abstract class UserRepository {
  // 참여자 등록
  void registerParticipant({required String name}) {}

  // 사용자 목록 조회
  void getUserList() {}

  // 사용자 상세 정보 조회
  void getUserDetailInfo({required String userCode}) {}

  // 사용자 정보 수정
  void updateUserInfo() {}

  // 사용자 정보 삭제
  void deleteUserData() {}
}
