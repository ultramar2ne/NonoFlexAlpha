import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/model/data/product.dart';
import 'package:nonoflex_alpha/model/data/server.dart';
import 'package:nonoflex_alpha/model/source/hive/hive_adapter.dart';
import 'package:nonoflex_alpha/model/data/user.dart';

abstract class LocalDataSource {
  /// 로컬 저장소를 초기화 한다.
  // Future<void> init();

  /// ==== User ====
  /// 로컬 저장소에 유저정보를 추가한다.
  Future<void> addUserInfo(User userInfo);

  /// 로그인 된 유저가 존재할 경우 유저정보를 반환한다.
  Future<User?> getUserInfo();

  /// 로컬 저장소에 존재하는 유저정보를 수정한다.
  Future<void> updateUserInfo(User userInfo);

  // 현재 유저 정보를 초기화한다.
  Future<void> deleteUserInfo();

  /// ==== Token =====
  /// 로컬 저장소에 토큰정보를 추가한다.
  Future<void> addTokenInfo(AuthToken token);

  /// 저장되어있는 토큰 정보가 존재할 경우 반환한다.
  Future<AuthToken?> getTokenInfo();

  /// 로컬 저장소에 토큰 정보를 업데이트한다.
  Future<void> updateTokenInfo(AuthToken token);

  /// 로컬 저장소에 존재하는 토큰정보를 초기화한다.
  Future<void> deleteTokenInfo();

  /// ==== Product List ====
  /// Product List Sorting 관련 설정을 저장한다.
  Future<void> updateProductSortingSet(int userId, ProductSortingSet sortingSet);

  /// Product List 정렬 기준 정보를 불러온다.
  Future<ProductSortingSet?> getProductSortingSet(int userId);

  /// Product List 정렬 기준 정보를 초기화한다.
  Future<void> clearProductSortingSet(int userId);
}

class LocalDataSourceImpl extends LocalDataSource {
  final systemBoxName = 'system';

  final Logger _logger;

  LocalDataSourceImpl({Logger? logger}) : _logger = logger ?? locator.get<Logger>();

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(AuthTokenAdapter());
    Hive.registerAdapter(ProductSortingSetAdapter());
  }

  Future<Box<User>> get userBox async => await Hive.openBox<User>('userInfo');

  Future<Box<AuthToken>> get authTokenBox async => await Hive.openBox<AuthToken>('tokenInfo');

  Future<Box<ProductSortingSet>> get productSortingSetBox async =>
      await Hive.openBox<ProductSortingSet>('productSortingSet');

  @override
  Future<void> addUserInfo(User user) async {
    var box = await userBox;
    await box.clear();
    await box.put('userInfo', user);
    _logger.i('User Info added - ${user.id}');
  }

  @override
  Future<User?> getUserInfo() async {
    try {
      var box = await userBox;
      return box.get('userInfo', defaultValue: null);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateUserInfo(User user) async {
    var box = await userBox;
    box.put('userInfo', user);
    _logger.i('User Info updated - ${user.id}');
  }

  @override
  Future<void> deleteUserInfo() async {
    var box = await userBox;
    await box.clear();
    _logger.i('User Info delet complete');
  }

  @override
  Future<void> addTokenInfo(AuthToken token) async {
    var box = await authTokenBox;
    await box.clear();
    await box.put('tokenInfo', token);
    _logger.i('AuthToken added - expired At ${token.accessExpiredAt}');
  }

  @override
  Future<AuthToken?> getTokenInfo() async {
    try {
      var box = await authTokenBox;
      return box.get('tokenInfo', defaultValue: null);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateTokenInfo(AuthToken token) async {
    var box = await authTokenBox;
    box.put('tokenInfo', token);
    _logger.i('Token Info updated - expired At ${token.accessExpiredAt}');
  }

  @override
  Future<void> deleteTokenInfo() async {
    var box = await authTokenBox;
    await box.clear();
    _logger.i('Token Info Data deleted');
  }

  @override
  Future<void> updateProductSortingSet(int userId, ProductSortingSet sortingSet) async {
    var box = await productSortingSetBox;
    box.put(userId, sortingSet);
    _logger.i('Product 정렬 기준 업데이트 됨}');
  }

  @override
  Future<ProductSortingSet?> getProductSortingSet(int userId) async {
    var box = await productSortingSetBox;
    try {
      return box.get(userId);
    } catch (e) {
      _logger.e(e);
      return null;
    }
  }

  @override
  Future<void> clearProductSortingSet(int userId) async {
    var box = await productSortingSetBox;
    box.clear();
    _logger.i('Product Sorting Info Data deleted');
  }
}
