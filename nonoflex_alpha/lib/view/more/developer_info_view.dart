import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/conf/ui/widgets.dart';
import 'package:nonoflex_alpha/gen/assets.gen.dart';
import 'package:nonoflex_alpha/view/more/developer_info_viewmodel.dart';

class DeveloperInfoView extends BaseGetView<DeveloperInfoViewModel> {
  @override
  AppBar? defaultAppBar() {
    return BNDefaultAppBar();
  }

  @override
  Widget drawBody() {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Assets.images.logo.logoTeam.image(width: 300, height: 300),
          ),
        ),
        Container(
          width: 3,
          height: 100,
          margin: EdgeInsets.only(bottom: 50),
          decoration: BoxDecoration(
            color: theme.primary,
            border: Border.all(
              color: theme.primary,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        drawInfo(),
        const SizedBox(height: 8),
        Obx(() => Text('v${controller.version.value}',style: theme.hint,)),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget drawInfo() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, top: 12, right: 20, left: 20),
      width: Get.width,
      height: 160,
      decoration: BoxDecoration(
        color: theme.baseDark,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '최진욱',
            style: theme.listTitle,
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => Clipboard.setData(const ClipboardData(text: 'cornflo3er@gmail.com')),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 24),
                Text(
                  'cornflo3er@gmail.com',
                  style: theme.listBody,
                ),
                const SizedBox(width: 8),
                Assets.icons.icCopy.image(width: 16, height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
