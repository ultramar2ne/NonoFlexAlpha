import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:nonoflex_alpha/cmm/ui/dialog.dart';
import 'package:nonoflex_alpha/cmm/utils.dart';
import 'package:nonoflex_alpha/conf/ui/base_widgets.dart';
import 'package:nonoflex_alpha/conf/ui/widgets.dart';
import 'package:nonoflex_alpha/gen/assets.gen.dart';
import 'package:nonoflex_alpha/view/notice/notice_detail_viewmodel.dart';

import '../../cmm/base.dart';

class NoticeDetailView extends BaseGetView<NoticeDetailViewModel> {
  @override
  Widget drawHeader() => drawActionPageTitle(
        '',
        titleItem: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('NoticeDetailViewLabelTitle'.tr, style: theme.label.copyWith(fontSize: 12)),
            const SizedBox(height: 4),
            Text(
              controller.noticeItem.title ?? '',
              style: theme.title.copyWith(
                color: theme.textDark,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
              // decoration: noticeTitleInputDecoration,
            ),
          ],
        ),
      );

  @override
  Widget drawBody() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      width: Get.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('NoticeDetailViewLabelContents'.tr, style: theme.label.copyWith(fontSize: 12)),
              if (controller.noticeItem.isFocused)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: theme.primary,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(50.0),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          if (controller.noticeItem.content != null) ...{
            Expanded(
              child: Text(
                controller.noticeItem.content!,
                style: theme.normal,
                softWrap: true,
              ),
            ),
          } else ...{
            Expanded(
              child: Center(
                child: Text(
                  'NoticeDetailViewMessageEmptyContents'.tr,
                  style: theme.label,
                ),
              ),
            )
          },
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              controller.noticeItem.writer ?? 'NoticeDetailViewPlaceHolderUnknownUser'.tr,
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              formatDateYMDHM(controller.noticeItem.updatedAt) ??
                  'NoticeDetailViewPlaceHolderUnknownUser'.tr,
              style: theme.hint,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  Widget drawFooter() {
    return Container(
      height: 82,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 1,
            child: BNTextButton(
              'NoticeDetailViewButtonDelete'.tr,
              onPressed: () => controller.deleteNotice(),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            flex: 2,
            child: BNColoredButton(
              child: Text('NoticeDetailViewButtonEdit'.tr),
              onPressed: () async {
                final kk = await Get.alert('안녕');
              },
            ),
          ),
        ],
      ),
    );
  }
}
