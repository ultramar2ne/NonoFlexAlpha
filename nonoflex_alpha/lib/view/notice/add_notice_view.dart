import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nonoflex_alpha/conf/ui/base_widgets.dart';
import 'package:nonoflex_alpha/conf/ui/widgets.dart';
import 'package:nonoflex_alpha/gen/assets.gen.dart';
import 'package:nonoflex_alpha/view/notice/add_notice_viewmodel.dart';

import 'package:get/get.dart';
import '../../cmm/base.dart';

class AddNoticeView extends BaseGetView<AddNoticeViewModel> {
  @override
  Widget drawHeader() => drawActionPageTitle(
        '',
        titleItem: TextField(
          controller: controller.titleEditingController,
          onChanged: (value) {},
          style: theme.title.copyWith(
            color: theme.textDark,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          decoration: noticeTitleInputDecoration,
        ),
      );

  @override
  Widget drawBody() {
    return Container(
        width: Get.width,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                expands: true,
                controller: controller.contentsEditingController,
                decoration: noticeContentsInputDecoration,
                selectionHeightStyle: BoxHeightStyle.strut,
                maxLines: null,
                maxLength: 500,
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
            Row(
              children: [
                Obx(
                  () => Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      value: controller.isImportantNotice.value,
                      onChanged: (value) => controller.isImportantNotice.toggle(),
                      fillColor: MaterialStateProperty.resolveWith<Color>(
                        (states) => states.contains(MaterialState.selected)
                            ? theme.primary
                            : theme.secondary,
                      ),
                      checkColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
                    ),
                  ),
                ),
                Text('AddNoticeViewLabelImportantNotice'.tr),
              ],
            )
          ],
        ));
  }

  @override
  Widget drawFooter() {
    return SizedBox(
      height: 82,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Expanded(
          child: BNColoredButton(
            child: Text('AddNoticeViewButtonAddNotice'.tr),
            onPressed: () => controller.submit(),
          ),
        ),
      ),
    );
  }
}

extension themeInfo on AddNoticeView {
  /// 공지사항 제목 입력 테마
  InputDecoration get noticeTitleInputDecoration => InputDecoration(
        isDense: true,
        hintText: 'AddNoticeViewHintTitleField'.tr,
        hintStyle: theme.hint.copyWith(color: theme.textHint),
        errorText: controller.titleErrorText,
        errorMaxLines: 2,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: theme.base)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: theme.primary)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: theme.error)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: theme.error)),
      );

  /// 공지사항 내용 입력 테마
  InputDecoration get noticeContentsInputDecoration => InputDecoration(
        isDense: true,
        hintText: 'AddNoticeViewHintContentsField'.tr,
        hintStyle: theme.hint.copyWith(color: theme.textHint),
        errorText: controller.contentErrorText,
        errorMaxLines: 2,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: theme.base)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: theme.primary)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: theme.error)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: theme.error)),
      );
}
