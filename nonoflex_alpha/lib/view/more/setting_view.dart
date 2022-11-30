import 'package:flutter/material.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/view/more/setting_viewmodel.dart';

import 'package:get/get.dart';

class SettingView extends BaseGetView<SettingViewModel> {

  @override
  Widget drawHeader() => drawMainPageTitle('SettingViewTitle'.tr);
}

extension MainPageCommonWidget on SettingView {
  Widget drawMainPageTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 82,
      width: Get.width,
      child: Row(
        children: [
          Text(
            title,
            style: theme.title.copyWith(
              color: theme.textColoredDark,
              fontWeight: FontWeight.w600,
              fontSize: 26,
            ),
          ),
        ],
      ),
    );
  }
}

