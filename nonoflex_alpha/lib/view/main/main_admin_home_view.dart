import 'package:flutter/material.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
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
        )
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('AdminHomeViewLabelNoticeArea'.tr, style: theme.label.copyWith(color: theme.primaryDark)),
        const SizedBox(height: 6),
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: theme.shadow.withOpacity(0.1)),
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
        Text('AdminHomeViewLabelTempDocumentArea'.tr, style: theme.label.copyWith(color: theme.primaryDark)),
        const SizedBox(height: 6),
        Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: theme.primary, width: 2),
            color: theme.baseDark,
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(child: SizedBox()),
              InkWell(
                child: Assets.icons.icFlashOn.image(),
              )
            ],
          ),
        )
      ],
    );
  }
}

/// 메인 페이지에서 공통적으로 나타나는 위젯
extension MainPageCommonWidget on AdminHomeView {
  // 메인 타이틀
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
