import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nonoflex_alpha/conf/ui/widgets.dart';
import 'package:nonoflex_alpha/gen/assets.gen.dart';
import 'package:nonoflex_alpha/model/data/notice.dart';
import 'package:nonoflex_alpha/view/notice/notice_list_viewmodel.dart';

import '../../cmm/base.dart';

class NoticeListView extends BaseGetView<NoticeListViewModel> {
  @override
  Widget drawHeader() => drawSubPageTitle('NoticeListViewTitle'.tr);

  @override
  Widget drawBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'NoticeListViewLabelNoticeList'.tr,
                style: theme.label,
              ),
              // BNIconButton(
              //   onPressed: () {},
              //   icon: Assets.icons.icListMenu.image(width: 24, height: 24),
              // ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Obx(() => drawNoticeList(controller.noticeItems)),
        ),
      ],
    );
  }
}

extension SubPageCommonwidget on NoticeListView {
  /// 서브 페이지 타이틀 및 헤더 영역, 앱바 대체 여부 확인 필요
  Widget drawSubPageTitle(String title, {bool showBackButton = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 60,
      width: Get.width,
      child: Row(
        children: [
          BNIconButton(
            onPressed: () => Get.back(),
            icon: Assets.icons.icArrowBack.image(width: 20, height: 20),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: theme.title.copyWith(
                  color: theme.textDark,
                  fontWeight: FontWeight.w500,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          BNIconButton(
            onPressed: () => controller.onClickedAddNotice(),
            icon: Assets.icons.icAdd.image(width: 24, height: 24),
          ),
        ],
      ),
    );
  }
}

extension NoticeListViewItems on NoticeListView {
  /// 공지사항 목록 위젯
  Widget drawNoticeList(List<Notice>? items) {
    if (items == null) {
      return Center(
        child: Text(
          'commonEmptyListView'.tr,
          style: theme.title,
        ),
      );
    }

    final list = items;
    final count = items.length;
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        return _drawNoticeListItemNormal(list[index]);
      },
    );
  }

  /// 공지사항 목록 항목 위젯
  Widget _drawNoticeListItemNormal(Notice item) {
    final title = item.title;
    // TODO:  수정됨 표시 여부 확인 필요
    final timeInfo = item.createdAt != item.updatedAt
        ? DateFormat('yyyy-MM-dd').format(item.createdAt).toString()
        : '${DateFormat('yyyy-MM-dd').format(item.updatedAt)}';

    final listItemStyle = ButtonStyle(
      padding: MaterialStateProperty.all<EdgeInsets>(
        const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      shape: MaterialStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      elevation: MaterialStateProperty.all<double>(0),
      overlayColor: MaterialStateProperty.all<Color>(theme.secondary),
      backgroundColor: MaterialStateProperty.all<Color>(theme.base),
    );

    return TextButton(
      onPressed: () => controller.onClickedNoticeItem(item),
      style: listItemStyle,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.visible,
                        style: theme.listTitle,
                      ),
                    ),
                    Visibility(
                      visible: item.isFocused,
                      child: Container(
                        width: 8,
                        height: 8,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: theme.primary,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(50.0),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Text(
                  timeInfo,
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                  style: theme.listBody.copyWith(
                    color: theme.nonoYellow,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
