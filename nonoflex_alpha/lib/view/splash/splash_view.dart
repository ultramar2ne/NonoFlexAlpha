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
          Expanded(child: Assets.icons.icSncLogo.image(width: 120, height: 120)),
          Visibility(
            visible: controller.errorMessage == null,
            child: Text(
              'team ${'teamName'.tr}',
              style: theme.subTitle
                  .copyWith(color: theme.secondaryDark, fontWeight: FontWeight.w500, fontSize: 12),
            ),
          ),
          if (controller.errorMessage != null) drawErrorContents(),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget drawErrorContents({String? errorMessage}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Text(
            errorMessage ?? 'SplashViewMessageErrorContents'.tr,
            style: theme.listSubBody,
          ),
          const SizedBox(height: 8),
          OutlinedButton(
              onPressed: () => controller.onClickRetry(),
              child: Text(
                '다시 시도',
                style: theme.normal,
              ))
        ],
      ),
    );
  }
}
