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

  // 토큰 정보
  final AuthToken? token;

  User({
    required this.userCode,
    required this.id,
    required this.userName,
    required this.userType,
    this.isActive = false,
    this.token,
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
      token: token ?? this.token,
    );
  }

  factory User.fromJson(Map<String, dynamic> data) {
    AuthToken? token;
    if (data['token'] != null) {
      token = AuthToken.fromJson(data['token']);
    }

    return User(
      userCode: int.tryParse(data['userCode']) ?? -1,
      id: data['id'] ?? '',
      userName: data['userName'] ?? '',
      userType: UserTypeExt.fromData(data['userType'] ?? ''),
      isActive: data['isActive'] ?? false,
      token: token,
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
      'userCode': userCode,
      'id': id,
      'userName': userName,
      'userType': userType.toString(),
      'isActive': isActive,
    };

    if (token != null) {
      data['token'] = token!.toMap();
    }

    return {
      'userCode': userCode,
      'id': id,
      'userName': userName,
      'userType': userType.toString(),
      'isActive': isActive,
    };
  }
}

enum UserType { admin, participant }

extension UserTypeExt on UserType {
  static UserType fromData(String type) {
    if (type == UserType.admin.toString()) {
      return UserType.admin;
    } else {
      return UserType.participant;
    }
  }
}

class UserList {}
