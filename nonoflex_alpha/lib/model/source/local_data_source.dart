import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nonoflex_alpha/model/source/hive/hive_adapter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:nonoflex_alpha/model/data/server.dart';
import 'package:nonoflex_alpha/model/data/user.dart';

abstract class LocalDataSource {

  /// 로컬 저장소를 초기화 한다.
  Future<void> init();

  /// 로컬 저장소에 유저정보를 추가한다.
  Future<User> addUserInfo();

  /// 로컬 저장소에 존재하는 유저정보를 수정한다.
  Future<User> updateUserInfo();

  /// 로컬 저장소에 토큰 정보를 업데이트한다.
  Future<AuthToken> updateTokenInfo(AuthToken token);

  /// 로컬 저장소에 유저 정보를 삭제한다.
  Future<void> deleteTokenInfo(String userCode);
}

class LocalDataSourceImpl extends LocalDataSource {

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserAdapter());

    // 'system'
  }

  @override
  Future<User> addUserInfo() {
    // TODO: implement addUserInfo
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTokenInfo(String userCode) {
    // TODO: implement deleteTokenInfo
    throw UnimplementedError();
  }

  @override
  Future<AuthToken> updateTokenInfo(AuthToken token) {
    // TODO: implement updateTokenInfo
    throw UnimplementedError();
  }

  @override
  Future<User> updateUserInfo() {
    // TODO: implement updateUserInfo
    throw UnimplementedError();
  }
}