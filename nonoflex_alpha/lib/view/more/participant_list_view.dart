import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/conf/ui/base_widgets.dart';
import 'package:nonoflex_alpha/conf/ui/widgets.dart';
import 'package:nonoflex_alpha/gen/assets.gen.dart';
import 'package:nonoflex_alpha/model/data/user.dart';
import 'package:nonoflex_alpha/view/more/participant_list_viewmodel.dart';
// import 'package:qr_flutter/qr_flutter.dart';

class ParticipantListView extends BaseGetView<ParticipantListViewModel> {
  @override
  Widget drawHeader() {
    return drawSubPageTitle(
      'ParticListViewTitle'.tr,
      button1: BNIconButton(
        onPressed: () => showRegisterUser(),
        icon: Assets.icons.icAdd.image(),
      ),
    );
  }

  @override
  Widget drawBody() {
    final userList = controller.userItems;
    return drawUserList(userList);
  }
}

extension ParticipantListViewExt on ParticipantListView {
  /// 사용자 목록 위젯
  Widget drawUserList(List<User>? items) {
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
        final item = list[index];
        return drawUserListItem(item, onClicked: () {
          showUserInfo(item);
        });
      },
    );
  }

  // 사용자 정보
  Future<void> showUserInfo(User user) {
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
                drawUserInfo(user),
                const SizedBox(height: 12),
                drawLoginCodeInfo(user),
                // drawProductDetailInfo(product),
                const SizedBox(height: 8),
                Container(
                  height: 60,
                  width: Get.width,
                  // margin: const EdgeInsets.all(12),
                  child: BNOutlinedButton(
                    child: Text('삭제하기'),
                    onPressed: () {
                      controller.deleteUserInfo(user);
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 60,
                  width: Get.width,
                  // margin: const EdgeInsets.all(12),
                  child: BNColoredButton(
                    child: Text('수정하기'),
                    onPressed: () {
                      Get.back();
                      showUserInfoEdit(user);
                    },
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  // 사용자 정보 수정
  Future<void> showUserInfoEdit(User user) {
    Widget bottomSheetHandle = Container(
      width: 52,
      height: 6,
      decoration: BoxDecoration(
        color: theme.baseDark,
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      ),
    );

    final nameController = TextEditingController(text: user.userName);
    bool isActive = user.isActive;
    final RxList<bool> isSelected = [false].obs;
    isSelected.value.insert(isActive ? 0 : 1, true);

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
                const SizedBox(height: 12),
                drawBaseLabel('사용자 이름'),
                const SizedBox(height: 8),
                BNInputBox(
                  controller: nameController,
                  onChanged: (value) {},
                ),
                const SizedBox(height: 20),
                drawBaseLabel('사용자 활성 상태'),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Obx(
                    () => ToggleButtons(
                      isSelected: isSelected.value,
                      borderRadius: BorderRadius.circular(8.0),
                      borderColor: theme.primary,
                      borderWidth: 2,
                      selectedBorderColor: theme.primary,
                      selectedColor: theme.base,
                      disabledColor: theme.secondary,
                      fillColor: theme.primary,
                      onPressed: (index) {
                        if (index == 0) {
                          isSelected.value = [true, false];
                        } else {
                          isSelected.value = [false, true];
                        }
                      },
                      children: [
                        Container(
                          width: 100,
                          height: 42,
                          alignment: Alignment.center,
                          // color: isSelected[0] ? theme.primary : theme.secondary,
                          child: Text(
                            '활성화',
                            style: isSelected[0]
                                ? theme.listBody.copyWith(color: theme.textLight)
                                : theme.listBody.copyWith(color: theme.textColored),
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 42,
                          alignment: Alignment.center,
                          // color: isSelected[1] ? theme.primary : theme.secondary,
                          child: Text(
                            '비활성화',
                            style: isSelected[1]
                                ? theme.listBody.copyWith(color: theme.textLight)
                                : theme.listBody.copyWith(color: theme.textColored),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 60,
                  width: Get.width,
                  // margin: const EdgeInsets.all(12),
                  child: BNColoredButton(
                    child: Text('저장하기'),
                    onPressed: () {
                      if (nameController.text.isEmpty) return;
                      Get.back();
                      controller.updateUserInfo(user.copyWith(
                          userName: nameController.text, isActive: isSelected.value[0]));
                      isSelected.close();
                    },
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  // 사용자 추가
  Future<void> showRegisterUser() {
    Widget bottomSheetHandle = Container(
      width: 52,
      height: 6,
      decoration: BoxDecoration(
        color: theme.baseDark,
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      ),
    );

    final nameController = TextEditingController();

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
                const SizedBox(height: 12),
                drawBaseLabel('사용자 이름'),
                const SizedBox(height: 4),
                BNInputBox(
                  controller: nameController,
                  onChanged: (value) {},
                ),
                const SizedBox(height: 24),
                Container(
                  height: 60,
                  width: Get.width,
                  // margin: const EdgeInsets.all(12),
                  child: BNColoredButton(
                    child: Text('저장하기'),
                    onPressed: () {
                      if (nameController.text.isEmpty) return;
                      Get.back();
                      controller.addNewParticipant(nameController.text);
                    },
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}

extension UserSummary on ParticipantListView {
  /// 사용자 정보 요약
  Widget drawUserInfo(User user) {
    Widget userAvatar = Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: user.userType == UserType.admin ? theme.nonoYellow : theme.nonoBlue,
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

  Widget drawLoginCodeInfo(User user) {
    if (!user.isActive) {
      return Center(
        child: Text(
          '* 비활성 사용자는 로그인 코드 발급이 불가합니다.\n   사용자 활성 상태를 확인해주세요.',
          style: theme.hint,
        ),
      );
    }
    controller.getUserLoginCode(user);
    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(4),
            alignment: Alignment.center,
            width: 120,
            decoration: BoxDecoration(
              color: theme.secondary,
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: Text(
              controller.userLoginCode.value,
              style: theme.listSubBody,
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 200,
            width: Get.width,
            padding: const EdgeInsets.symmetric(vertical: 12),
            margin: const EdgeInsets.all(12),
            child: controller.userLoginCode.value == ''
                ? const CircularProgressIndicator()
                : BarcodeWidget(
                    data: controller.userLoginCode.value,
                    barcode: Barcode.qrCode(),
                  ),
          ),
        ],
      ),
    );
  }
}
