import 'package:flutter/material.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/conf/ui/base_widgets.dart';
import 'package:nonoflex_alpha/conf/ui/widgets.dart';
import 'package:nonoflex_alpha/gen/assets.gen.dart';
import 'package:nonoflex_alpha/model/data/user.dart';
import 'package:nonoflex_alpha/view/more/setting_viewmodel.dart';

import 'package:get/get.dart';

class SettingView extends BaseGetView<SettingViewModel> {
  @override
  Widget drawHeader() => drawMainPageTitle('SettingViewTitle'.tr);

  @override
  Widget drawBody() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          if (controller.userInfo != null) drawCurrentUserInfo(controller.userInfo!),
          const SizedBox(height: 24),
          drawUserSettingList(),
          const SizedBox(height: 12),
          Container(height: 0.5, color: theme.baseDark),
          const SizedBox(height: 12),
          drawProductSettingList(),
          const SizedBox(height: 12),
          Container(height: 0.5, color: theme.baseDark),
          const SizedBox(height: 12),
          drawDocumentSettingList(),
          const SizedBox(height: 12),
          Container(height: 0.5, color: theme.baseDark),
          const SizedBox(height: 12),
          drawEtcSettingList(),
          const SizedBox(height: 12),
          Container(height: 0.5, color: theme.baseDark),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

extension SettingViewItems on SettingView {
  /// 사용자 정보
  Widget drawCurrentUserInfo(User user) {
    Widget userAvatar = Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: theme.nonoYellow,
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
          BNTextButton('SettingViewButtonLogout'.tr,
              onPressed: () => controller.onClickedLogoutButton()),
        ],
      ),
    );
  }

  /// 공통으로 사용되는 설정 항목 라벨
  Widget _drawSettingListLabel(String title) {
    return Container(
      child: Row(
        children: [
          Text(
            title,
            style: theme.label.copyWith(fontSize: 12, color: theme.nonoBlue),
          ),
        ],
      ),
    );
  }

  /// 공통으로 사용되는 설정 항목 항목
  Widget _drawSettingListItem(String title, {required VoidCallback? onPressed}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      overlayColor: MaterialStateProperty.all<Color>(theme.baseDark),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                title,
                style: theme.listTitle,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            Assets.icons.icArrowForward.image(width: 16, height: 16),
            const SizedBox(width: 5),
          ],
        ),
      ),
    );
  }

  /// 사용자 관련 설정 목록
  Widget drawUserSettingList() {
    return Column(
      children: [
        _drawSettingListLabel('SettingViewLabelUserSetting'.tr),
        const SizedBox(height: 8),
        _drawSettingListItem('SettingViewButtonManagePartic'.tr,
            onPressed: () => controller.goUserManagePage(UserType.participant)),
        _drawSettingListItem('SettingViewButtonManageAdmin'.tr,
            onPressed: () => controller.goUserManagePage(UserType.admin)),
      ],
    );
  }

  /// 물품 관련 설정 목록
  Widget drawProductSettingList() {
    return Column(
      children: [
        _drawSettingListLabel('SettingViewLabelProductSetting'.tr),
        const SizedBox(height: 8),
        _drawSettingListItem('SettingViewLabelProductSetting'.tr,
            onPressed: () => controller.goAddNewProductPage()),
        _drawSettingListItem('SettingViewButtonManageBarcode'.tr,
            onPressed: () => controller.goBarcodeSettingPage()),
      ],
    );
  }

  /// 문서 관련 설정 목록
  Widget drawDocumentSettingList() {
    return Column(
      children: [
        _drawSettingListLabel('SettingViewLabelDocumentSetting'.tr),
        const SizedBox(height: 8),
        _drawSettingListItem('SettingViewButtonPrintDocument'.tr,
            onPressed: () => controller.goDocumentPrintPage()),
        _drawSettingListItem('SettingViewButtonManageCompany'.tr,
            onPressed: () => controller.goCompanyManagePage()),
      ],
    );
  }

  /// 기타 설정 목록
  Widget drawEtcSettingList() {
    return Column(
      children: [
        _drawSettingListLabel('SettingViewLabelEtc'.tr),
        const SizedBox(height: 8),
        _drawSettingListItem('SettingViewButtonAskToDeveloper'.tr,
            onPressed: () => controller.goAskToDeveloperPage()),
        _drawSettingListItem('SettingViewButtonPowerUp'.tr,
            onPressed: () => controller.goPowerUpPage()),
      ],
    );
  }
}
