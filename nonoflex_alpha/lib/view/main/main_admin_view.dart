import 'package:flutter/material.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/cmm/ui/dialog.dart';
import 'package:nonoflex_alpha/gen/assets.gen.dart';
import 'package:nonoflex_alpha/view/main/main_admin_home_view.dart';
import 'package:nonoflex_alpha/view/main/main_admin_home_viewmodel.dart';
import 'package:nonoflex_alpha/view/main/main_admin_viewmodel.dart';

import 'package:get/get.dart';

class MainForAdminView extends BaseGetView<MainForAdminViewModel> {
  @override
  Future<bool>? willPopCallback() => Get.confirmDialog('정말 종료하시겠습니까?');

  @override
  Widget drawBody() {
    return Navigator(
      key: Get.nestedKey(1),
      initialRoute: '/home',
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          return GetPageRoute(
            page: () => AdminHomeView(),
            binding: BindingsBuilder(() => Get.lazyPut(() => AdminHomeViewModel())),
          );
        }
      },
    );
  }

  @override
  Widget bottomNavigationBar() {
    double displayWidth = Get.width;

    List<AssetGenImage> listOfIcons = [
      Assets.icons.icNaviHome,
      Assets.icons.icNaviProducts,
      Assets.icons.icNaviDocuments,
      Assets.icons.icNaviSetting,
    ];

    List<String> listOfStrings = [
      'MainForAdminViewBottomNavHome'.tr,
      'MainForAdminViewBottomNavProducts'.tr,
      'MainForAdminViewBottomNavDocuments'.tr,
      'MainForAdminViewBottomNavSetting'.tr,
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: displayWidth * .05),
      height: 82,
      decoration: BoxDecoration(
        color: theme.base,
        boxShadow: [
          BoxShadow(
            color: theme.base,
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
        // borderRadius: BorderRadius.circular(50),
      ),
      child: ListView.builder(
        itemCount: 4,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: displayWidth * .02),
        itemBuilder: (context, index) => InkWell(
          onTap: () => controller.updateTabState(index),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Obx(
            () => Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  curve: Curves.fastLinearToSlowEaseIn,
                  width:
                      index == controller.tabIndex.value ? displayWidth * .32 : displayWidth * .18,
                  alignment: Alignment.center,
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    curve: Curves.fastLinearToSlowEaseIn,
                    height: index == controller.tabIndex.value ? displayWidth * .12 : 0,
                    width: index == controller.tabIndex.value ? displayWidth * .32 : 0,
                    decoration: BoxDecoration(
                      color:
                          index == controller.tabIndex.value ? theme.secondary : Colors.transparent,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(seconds: 1),
                  curve: Curves.fastLinearToSlowEaseIn,
                  width:
                      index == controller.tabIndex.value ? displayWidth * .31 : displayWidth * .18,
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastLinearToSlowEaseIn,
                            width: index == controller.tabIndex.value ? displayWidth * .13 : 0,
                          ),
                          AnimatedOpacity(
                            opacity: index == controller.tabIndex.value ? 1 : 0,
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastLinearToSlowEaseIn,
                            child: Text(
                              index == controller.tabIndex.value ? listOfStrings[index] : '',
                              style: TextStyle(
                                color: theme.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastLinearToSlowEaseIn,
                            width: index == controller.tabIndex.value ? displayWidth * .03 : 20,
                          ),
                          listOfIcons[index].image(
                            width: displayWidth * .076,
                            color: index == controller.tabIndex.value
                                ? theme.primary
                                : theme.secondaryDark,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
