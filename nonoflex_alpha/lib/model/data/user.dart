import 'package:flutter/cupertino.dart';
import 'package:nonoflex_alpha/model/data/server.dart';

/// 사용자 계정 정보
@immutable
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
      userType: UserType.fromServer(data['userType'] ?? ''),
      isActive: data['active'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userCode': userCode,
      'email': id,
      'userName': userName,
      'userType': userType.serverValue,
      'active': isActive,
    };
  }
}

/// 사용자 권한 정보
enum UserType {
  none('none', ''),
  admin('admin', 'ROLE_ADMIN'),
  participant('admin', 'ROLE_PARTIC');

  const UserType(this.code, this.serverValue);

  final String code;
  final String serverValue;

  factory UserType.fromServer(String serverValue) {
    return UserType.values
        .firstWhere((value) => value.serverValue == serverValue, orElse: () => UserType.none);
  }
}

/// 사용자 목록
@immutable
class UserList {
  // 현재 페이지 : page
  final int page;

  // ?? : count
  final int count;

  // 전체 페이지 개수 : totalPages
  final int totalPages;

  // 전체 목록 개수 : totalCount
  final int totalCount;

  // 마지막 페이지 여부 : lastPage
  final bool isLastPage;

  // 사용자 목록 : UserList
  final List<User> items;

  UserList({
    required this.page,
    required this.count,
    required this.totalPages,
    required this.totalCount,
    required this.isLastPage,
    required this.items,
  });

  factory UserList.fromJson(Map<dynamic, dynamic> data) {
    return UserList(
        page: data['page'],
        count: data['count'],
        totalPages: data['totalPages'],
        totalCount: data['totalCount'],
        isLastPage: data['isLastPage'],
        items: data['userItems'].map((element) => User.fromJson(element)).toList());
  }

  Map<String, dynamic> toMap() {
    return {
      'page': page,
      'count': count,
      'totalPages': totalPages,
      'islastPage': isLastPage,
      'userItems': items.map((e) => e.toMap())
    };
  }
}
