/// 사용자 계정 정보
class User {
  // 사용자 코드 : userCode
  final int userCode;

  // 사용자 id : email
  final String id;

  // 사용자 이름 : userName
  final String userName;

  // 사용자 권한 타입 : userType (admin, partic)
  final UserType userType;

  // 사용자 활성 여부
  final bool isActive;

  User({
    required this.userCode,
    required this.id,
    required this.userName,
    required this.userType,
    this.isActive = false
  });
}

enum UserType { admin, participant }