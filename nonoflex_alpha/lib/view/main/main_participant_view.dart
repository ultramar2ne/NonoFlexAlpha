import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/cmm/ui/dialog.dart';
import 'package:nonoflex_alpha/conf/ui/base_widgets.dart';
import 'package:nonoflex_alpha/conf/ui/widgets.dart';
import 'package:nonoflex_alpha/gen/assets.gen.dart';
import 'package:nonoflex_alpha/model/data/document.dart';
import 'package:nonoflex_alpha/model/data/user.dart';
import 'package:nonoflex_alpha/view/main/main_participant_viewmodel.dart';

class MainForParticView extends BaseGetView<MainForParticViewModel> {
  @override
  Future<bool>? willPopCallback() => Get.confirmDialog('정말 종료하시겠습니까?');

  @override
  Widget drawHeader() => drawMainPageTitle(
        '노노유통'.tr,
        buttonList: [
          // user 버튼
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: theme.primaryLight,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              BNIconButton(
                onPressed: () => showUserInfo(),
                icon: Assets.icons.icUser.image(color: theme.base, width: 24, height: 24),
              ),
            ],
          ),
        ],
      );

  @override
  Widget drawBody() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            if (controller.noticeItem != null) drawRecentNoticeItem(),
            const SizedBox(height: 24),
            drawProductArea(),
            const SizedBox(height: 24),
            drawDocumentArea(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // 최근 공지사항
  Widget drawRecentNoticeItem() {
    final notice = controller.noticeItem;
    if (notice == null || notice.content == null) return const SizedBox.shrink();

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
            height: 240,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: theme.secondary,
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
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
            ),
          ),
        )
      ],
    );
  }

  Widget drawProductArea() {
    return Column(
      children: [
        drawBaseLabel('물품 관리'),
        const SizedBox(height: 6),
        _drawMainMenuListItem('물품 목록',
            onPressed: () => controller.goProductListPage(),
            icon: Assets.icons.icItemCart.image(color: theme.nonoOrange)),
      ],
    );
  }

  Widget drawDocumentArea() {
    return Column(
      children: [
        drawBaseLabel('문서 관리'),
        const SizedBox(height: 6),
        _drawMainMenuListItem('문서 목록',
            onPressed: () => controller.goDocumentListPage(),
            icon: Assets.icons.icNaviDocuments.image(color: theme.primaryDark)),
        _drawMainMenuListItem('입고서 작성',
            onPressed: () => controller.goAddDocumentPage(DocumentType.input),
            icon: Assets.icons.icInput.image(color: theme.primary)),
        _drawMainMenuListItem('출고서 작성',
            onPressed: () => controller.goAddDocumentPage(DocumentType.output),
            icon: Assets.icons.icOutput.image(color: theme.error)),
      ],
    );
  }

  /// 공통으로 사용되는 설정 항목 항목
  Widget _drawMainMenuListItem(String title, {required VoidCallback? onPressed, Widget? icon}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      overlayColor: MaterialStateProperty.all<Color>(theme.baseDark),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        width: double.infinity,
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: icon != null
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: icon,
                    )
                  : SizedBox(
                      width: 24,
                      height: 24,
                      child: icon,
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: theme.listTitle,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 사용자 정보
  Future<void> showUserInfo() async {
    final userInfo = controller.getUserInfo();
    if (userInfo == null) return;

    Widget bottomSheetHandle = Container(
      width: 52,
      height: 6,
      decoration: BoxDecoration(
        color: theme.baseDark,
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      ),
    );

    return Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: theme.base,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12.0), topRight: Radius.circular(12.0)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: bottomSheetHandle,
                  ),
                ),
                drawCurrentUserInfo(userInfo),
                const SizedBox(height: 12),
                SizedBox(
                  height: 60,
                  width: Get.width,
                  // margin: const EdgeInsets.all(12),
                  child: BNColoredButton(
                    child: const Text('로그아웃'),
                    onPressed: () {
                      Get.back();
                      controller.onClickedLogoutButton();
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 사용자 정보
  Widget drawCurrentUserInfo(User user) {
    Widget userAvatar = Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: theme.nonoBlue,
        borderRadius: const BorderRadius.all(Radius.circular(50.0)),
      ),
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      height: 100,
      decoration: BoxDecoration(
        color: theme.baseDark,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          userAvatar,
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.userName,
                  style: theme.listTitle,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  user.id,
                  style: theme.listSubTitle.copyWith(
                    color: theme.textHint,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
