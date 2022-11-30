import 'package:nonoflex_alpha/model/data/server.dart';

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
    this.isActive = false,
  });

  User copyWith({
    String? userName,
    UserType? userType,
    bool? isActive,
    AuthToken? token,
  }) {
    return User(
      userCode: userCode,
      id: id,
      userName: userName ?? this.userName,
      userType: userType ?? this.userType,
      isActive: isActive ?? this.isActive,
    );
  }

  factory User.fromJson(Map<dynamic, dynamic> data) {
    return User(
      userCode: data['userCode'] ?? -1,
      id: data['email'] ?? '',
      userName: data['userName'] ?? '',
      userType: UserTypeExt.fromData(data['userType'] ?? ''),
      isActive: data['active'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userCode': userCode,
      'email': id,
      'userName': userName,
      'userType': UserTypeExt.toData(userType),
      'active': isActive,
    };
  }
}

enum UserType { admin, participant }

extension UserTypeExt on UserType {
  static UserType fromData(String type) {
    if (type == 'ROLE_ADMIN') {
      return UserType.admin;
    } else if (type == 'ROLE_PARTICIPANT') {
      return UserType.participant;
    } else {
      return UserType.participant;
    }
  }

  static String toData(UserType type) {
    switch (type) {
      case UserType.admin:
        return 'ROLE_ADMIN';
      case UserType.participant:
        return 'ROLE_PARTICIPANT';
    }
  }
}

class UserList {


  factory UserList.fromJson(Map<dynamic, dynamic> data) {
    throw('일해라 최진욱..');
    // return User(
    //   userCode: data['userCode'] ?? -1,
    //   id: data['email'] ?? '',
    //   userName: data['userName'] ?? '',
    //   userType: UserTypeExt.fromData(data['userType'] ?? ''),
    //   isActive: data['active'] ?? false,
    // );
  }
}
