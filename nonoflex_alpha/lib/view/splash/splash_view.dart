
import 'package:flutter/material.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/gen/assets.gen.dart';
import 'package:nonoflex_alpha/view/splash/splash_viewmodel.dart';

import 'package:get/get.dart';

class SplashView extends BaseGetView<SplashViewModel> {
  @override
  drawBody() {
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Assets.icons.icAppLogo.image(width: 120, height: 120),
        const SizedBox(height: 50),
        Text(
          'appName'.tr,
          style: theme.title
              .copyWith(color: theme.primaryDark, fontWeight: FontWeight.w700, fontSize: 38),
        ),
        Text(
          'team ${'teamName'.tr}',
          style: theme.subTitle
              .copyWith(color: theme.secondary, fontWeight: FontWeight.w500, fontSize: 12),
        ),
        const SizedBox(height: 120),
        // TODO: Error Message
      ],
    ));
  }
}
