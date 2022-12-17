import 'package:flutter/material.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/conf/ui/base_widgets.dart';
import 'package:nonoflex_alpha/conf/ui/widgets.dart';
import 'package:nonoflex_alpha/gen/assets.gen.dart';
import 'package:nonoflex_alpha/model/data/notice.dart';
import 'package:nonoflex_alpha/view/main/main_admin_home_viewmodel.dart';

import 'package:get/get.dart';

class AdminHomeView extends BaseGetView<AdminHomeViewModel> {
  @override
  Widget drawHeader() => drawMainPageTitle('AdminHomeViewTitle'.tr);

  @override
  Widget drawBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          drawRecentNoticeItem(null),
          const SizedBox(height: 32),
          drawTempDocumentInfoItem()
        ],
      ),
    );
  }
}

/// Home 화면의 위젯
extension MainPageWidget on AdminHomeView {
  // 최근 공지사항
  Widget drawRecentNoticeItem(Notice? notice) {
    // 최근 공지사항에 나타날 정보
    late final item;
    if (notice != null && notice.content != null) {
      item = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notice.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          SingleChildScrollView(child: Text(notice.content!)),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(notice.writer),
          ),
        ],
      );
    } else {
      item = Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'AdminHomeViewMessageAddNotice'.tr,
            style: theme.subTitle.copyWith(color: theme.textHint),
          ),

          /// 버튼 ...?
        ],
      ));
    }

    return Column(
      children: [
        drawBaseLabel(
          'AdminHomeViewLabelNoticeArea'.tr,
          item1: BNIconButton(
            onPressed: () => controller.goNoticeListPage(),
            icon: Assets.icons.icListMenu.image(width: 24, height: 24),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            // border: Border.all(color: theme.shadow.withOpacity(0.1)),
            color: theme.secondary,
          ),
          padding: const EdgeInsets.all(12),
          child: item,
        )
      ],
    );
  }

  // 예정서 현황 정보
  Widget drawTempDocumentInfoItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        drawBaseLabel('AdminHomeViewLabelTempDocumentArea'.tr),
        const SizedBox(height: 6),
        Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: theme.baseDark,
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(child: SizedBox()),
              BNIconButton(
                onPressed: () {},
                icon: Assets.icons.icAdd.image(width: 32, height: 32),
              ),
            ],
          ),
        )
      ],
    );
  }
}
