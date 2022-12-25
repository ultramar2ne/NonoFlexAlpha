import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/model/data/user.dart';
import 'package:nonoflex_alpha/model/repository/auth/auth_repository.dart';
import 'package:nonoflex_alpha/model/repository/user/user_repository.dart';

class ParticipantListViewModel extends BaseController {
  AuthRepository _authRepository;
  UserRepository _userRepository;

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
      final userList = await _userRepository.getUserList();
      userItems.addAll(userList.items.where((element) => element.userType != UserType.admin));
      update();
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> addNewParticipant() async {

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
