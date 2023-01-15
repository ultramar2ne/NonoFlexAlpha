import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeveloperInfoViewModel extends BaseController {

  final version = ''.obs;

  DeveloperInfoViewModel(){
    init();
  }

  init() async {
    final info = await PackageInfo.fromPlatform();
    version.value = info.version;
  }
}