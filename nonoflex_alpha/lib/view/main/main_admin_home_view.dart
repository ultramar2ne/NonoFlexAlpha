import 'package:flutter/material.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/conf/ui/base_widgets.dart';
import 'package:nonoflex_alpha/conf/ui/widgets.dart';
import 'package:nonoflex_alpha/gen/assets.gen.dart';
import 'package:nonoflex_alpha/gen/colors.gen.dart';
import 'package:nonoflex_alpha/model/data/notice.dart';
import 'package:nonoflex_alpha/view/main/main_admin_home_viewmodel.dart';

import 'package:get/get.dart';

class AdminHomeView extends BaseGetView<AdminHomeViewModel> {
  @override
  Widget drawHeader() => drawMainPageTitle('AdminHomeViewTitle'.tr);

  @override
  Widget drawBody() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            drawRecentNoticeItem(controller.noticeItem),
            const SizedBox(height: 32),
            drawTempDocumentInfoItem()
          ],
        ),
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
          Row(
            children: [
              Expanded(
                child: Text(
                  notice.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.listTitle,
                ),
              ),
              if (controller.noticeItem?.isFocused ?? false)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: theme.primary,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(50.0),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Expanded(
              child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Text(
                    notice.content!,
                    style: theme.listBody,
                  ))),
          const SizedBox(height: 8),
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
            const SizedBox(height: 24),
            Text(
              'AdminHomeViewMessageAddNotice'.tr,
              style: theme.subTitle.copyWith(color: theme.textHint),
            ),
            const SizedBox(height: 12),
            BNOutlinedButton(
              onPressed: () => controller.goNoticeAddPage(),
              child: const Text('새로운 공지사항 작성하기'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        drawBaseLabel(
          'AdminHomeViewLabelNoticeArea'.tr,
          item1: BNIconButton(
            onPressed: () => controller.goNoticeListPage(),
            icon: Assets.icons.icAdd.image(width: 24, height: 24),
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: (notice != null && notice.content != null)
              ? () => controller.openNoticeDetail()
              : null,
          child: Container(
            height: 260,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: theme.secondary,
            ),
            padding: const EdgeInsets.all(20),
            child: item,
          ),
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
          // child: Row(
          //   children: [
          //     Expanded(child: SizedBox()),
          //     BNIconButton(
          //       onPressed: () {},
          //       icon: Assets.icons.icAdd.image(width: 32, height: 32),
          //     ),
          //   ],
          // ),
          child: Center(
            child: Text(
              '예정서 기능은 비활성화 되어있습니다.\n관리자에게 문의하세요.',
              style: theme.listBody.copyWith(color: theme.textHint),
            ),
          ),
        )
      ],
    );
  }
}
