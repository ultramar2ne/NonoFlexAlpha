import 'package:nonoflex_alpha/cmm/base.dart';

import 'package:get/get.dart';

class MainForAdminViewModel extends BaseController {
  static const tabs = ['home', ' products', 'documents', 'setting'];

  final tabIndex = 0.obs;

  MainForAdminViewModel() {
    _init();
  }

  void _init() {
    // completeInitialize();
  }

  void updateTabState(int index) {
    if (tabIndex.value == index) return;
    tabIndex.value = index;
    switch(index){
      case 0:
        baseNavigator.goAdminHomePage(isNested: true);
        break;
      case 1:
        baseNavigator.goProductListPage(isNested: true);
        break;
      case 2:
        baseNavigator.goDocumentListPage(isNested: true);
        break;
      case 3:
        baseNavigator.goSettingPage(isNested: true);
        break;
      default:
        return;
    }
  }
}
