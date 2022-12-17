import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nonoflex_alpha/conf/ui/base_widgets.dart';
import 'package:nonoflex_alpha/conf/ui/widgets.dart';
import 'package:nonoflex_alpha/gen/assets.gen.dart';
import 'package:nonoflex_alpha/model/data/notice.dart';
import 'package:nonoflex_alpha/view/notice/notice_list_viewmodel.dart';

import '../../cmm/base.dart';

class NoticeListView extends BaseGetView<NoticeListViewModel> {
  @override
  Widget drawHeader() => drawSubPageTitle(
        'NoticeListViewTitle'.tr,
        button1: BNIconButton(
          onPressed: () => controller.onClickedAddNotice(),
          icon: Assets.icons.icAdd.image(width: 24, height: 24),
        ),
      );

  @override
  Widget drawBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: drawBaseLabel(
            'NoticeListViewLabelNoticeList'.tr,
            item1: BNIconButton(
              onPressed: () {},
              icon: Assets.icons.icListMenu.image(width: 24, height: 24),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Obx(() => _drawNoticeList(controller.noticeItems)),
        ),
      ],
    );
  }

  /// 공지사항 목록 위젯
  Widget _drawNoticeList(List<Notice>? items) {
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
