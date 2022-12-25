import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/model/data/user.dart';
import 'package:nonoflex_alpha/model/repository/user/user_repository.dart';

class UserListViewModel extends BaseController {
  UserRepository _userRepository;

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
      final userList = await _userRepository.getUserList();
      userItems.addAll(userList.items.where((element) => element.userType == UserType.admin));
      update();
    } catch (e) {
      logger.e(e);
    }
  }
}