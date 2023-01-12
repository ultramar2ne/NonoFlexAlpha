import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/conf/ui/base_widgets.dart';
import 'package:nonoflex_alpha/conf/ui/widgets.dart';
import 'package:nonoflex_alpha/model/data/user.dart';
import 'package:nonoflex_alpha/view/more/user_list_viewmodel.dart';

class UserListView extends BaseGetView<UserListViewModel> {
  @override
  Widget drawHeader() {
    return drawSubPageTitle(
      'UserListViewTitle'.tr,
    );
  }

  @override
  Widget drawBody() {
    final userList = controller.userItems;
    return drawUserList(userList);
  }
}

extension UserListViewExt on UserListView {
  /// 확인서 목록 위젯
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
        return drawUserListItem(item, onClicked: () => showUserInfo(item));
      },
    );
  }

  // 사용자 정보 바텀시트
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
                const SizedBox(height: 8),
                Container(
                  height: 60,
                  width: Get.width,
                  // margin: const EdgeInsets.all(12),
                  child: BNColoredButton(
                    child: Text('수정하기'),
                    onPressed: () async {
                      Get.back();
                      await showUserInfoEdit(user);
                      // showUserInfo(changedUser != nul);
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

  // 사용자 정보 바텀시트
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
                // const SizedBox(height: 20),
                // drawBaseLabel('사용자 이름'),
                // const SizedBox(height: 8),
                // BNInputBox(
                //   controller: nameController,
                //   onChanged: (value) {},
                // ),
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
                          height: 32,
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
                          height: 38,
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
                    child: const Text('저장하기'),
                    onPressed: () {
                      if (nameController.text.isEmpty) return;
                      Get.back();
                      controller.updateUserInfo(user.copyWith(
                          userName: nameController.text, isActive: isSelected.value[0]));
                      isSelected.close();
                      // Get.back();
                      // controller.loadProductDetailInfo(product);
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

extension UserSummary on UserListView {
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
}
