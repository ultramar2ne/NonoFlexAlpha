import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/cmm/ui/dialog.dart';
import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/conf/manager/auth_manager.dart';
import 'package:nonoflex_alpha/model/data/user.dart';
import 'package:nonoflex_alpha/model/repository/user/user_repository.dart';

import 'package:get/get.dart';

class UserListViewModel extends BaseController {
  UserRepository _userRepository;
  final AuthManager _authManager = locator.get<AuthManager>();

  List<User> userItems = [];

  UserListViewModel({UserRepository? userRepository})
      : _userRepository = userRepository ?? locator.get<UserRepository>() {
    init();
  }

  init() {
    getParticipantsList();
  }

  Future<void> getParticipantsList() async {
    try {
      updateLoadingState(true);
      userItems.clear();
      final userList = await _userRepository.getUserList();
      userItems.addAll(
        userList.items.where((element) =>
            element.userType == UserType.admin &&
            element.userCode != _authManager.currentUser!.userCode),
      );
      update();
      updateLoadingState(false);
    } catch (e) {
      logger.e(e);
      updateLoadingState(false);
    }
  }

  Future<void> updateUserInfo(User user) async {
    try {
      await _userRepository.updateUserInfo(user);
      Get.toast('사용자 정보가 수정되었습니다.');
      getParticipantsList();
      update();
    } catch (e) {
      Get.toast('오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
      logger.e(e);
    }
  }
}
