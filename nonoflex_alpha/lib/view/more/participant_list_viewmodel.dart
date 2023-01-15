import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/cmm/ui/dialog.dart';
import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/model/data/user.dart';
import 'package:nonoflex_alpha/model/repository/auth/auth_repository.dart';
import 'package:nonoflex_alpha/model/repository/user/user_repository.dart';

class ParticipantListViewModel extends BaseController {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  List<User> userItems = [];

  final userLoginCode = ''.obs;

  ParticipantListViewModel({UserRepository? userRepository, AuthRepository? authRepository})
      : _authRepository = authRepository ?? locator.get<AuthRepository>(),
        _userRepository = userRepository ?? locator.get<UserRepository>() {
    init();
  }

  init() {
    getParticipantsList();
  }

  Future<void> getParticipantsList() async {
    try {
      userItems.clear();
      final userList = await _userRepository.getUserList();
      userItems.addAll(userList.items.where((element) => element.userType != UserType.admin));
      update();
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> addNewParticipant(String userName) async {
    if (userName.replaceAll(' ', '') == '') return;
    try {
      await _userRepository.registerParticipant(name: userName);
      Get.toast('참여자 정보가 추가되었습니다.');
      init();
    } catch (e) {
      Get.toast('오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
      logger.e(e);
    }
  }

  Future<void> updateUserInfo(User user) async {
    try {
      await _userRepository.updateUserInfo(user);
      Get.toast('참여자 정보가 수정되었습니다.');
      init();
    } catch (e) {
      Get.toast('오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
      logger.e(e);
    }
  }

  Future<void> deleteUserInfo(User user) async {
    if (!await Get.confirmDialog(
        '정말로 삭제하시겠습니까? \n삭제된 데이터는 복구할 수 없습니다.')) {
      return;
    }

    try {
      await _userRepository.deleteUserData(user.userCode);
      Get.toast('참여자 정보가 삭제되었습니다.');
      init();
    } catch (e) {
      Get.toast('오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
      logger.e(e);
    }
  }

  Future<void> getUserLoginCode(User user) async {
    try {
      userLoginCode.value = '';
      userLoginCode.value = await _authRepository.getParticipantLoginCode(userCode: user.userCode);
      logger.i(userLoginCode);
    } catch (e) {
      logger.e(e);
    }
  }
}
