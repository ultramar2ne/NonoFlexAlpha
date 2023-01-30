import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/cmm/ui/dialog.dart';
import 'package:nonoflex_alpha/conf/ui/base_widgets.dart';
import 'package:nonoflex_alpha/conf/ui/widgets.dart';
import 'package:nonoflex_alpha/gen/assets.gen.dart';
import 'package:nonoflex_alpha/gen/colors.gen.dart';
import 'package:nonoflex_alpha/model/data/company.dart';
import 'package:nonoflex_alpha/view/more/company_list_viewmodel.dart';

class CompanyListView extends BaseGetView<CompanyListViewModel> {
  @override
  Widget drawHeader() {
    return drawSubPageTitle(
      'CompanyListViewTitle'.tr,
      button1: BNIconButton(
        onPressed: () => showAddCompany(),
        icon: Assets.icons.icAdd.image(),
      ),
    );
  }

  @override
  Widget drawBody() {
    final inputCompanyList =
        controller.companyItems.where((el) => el.companyType == CompanyType.input).toList();
    final outputCompanyList =
        controller.companyItems.where((el) => el.companyType == CompanyType.output).toList();

    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      constraints: const BoxConstraints(maxWidth: 500, maxHeight: 800),
      child: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            TabBar(
              labelPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              isScrollable: true,
              indicatorColor: ColorName.primary,
              indicator: BoxDecoration(
                color: theme.baseDark,
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
              tabs: <Widget>[
                Text(
                  '입고처',
                  style: theme.button.copyWith(color: theme.primary),
                  textScaleFactor: 1.0,
                ),
                Text(
                  '출고처',
                  style: theme.button.copyWith(color: theme.error),
                  textScaleFactor: 1.0,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: ColorName.base,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TabBarView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Tab(child: drawCompanyList(inputCompanyList)),
                    Tab(child: drawCompanyList(outputCompanyList)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension CompanyListViewExt on CompanyListView {
  /// 거래처 목록 위젯
  Widget drawCompanyList(List<Company>? items) {
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
        return drawCompanyListItem(item, onClicked: () => showCompanyInfo(item));
      },
    );
  }

  /// 거래처 정보 요약
  Future<void> showCompanyInfo(Company company) {
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
                drawCompanyListItem(company),
                const SizedBox(height: 8),
                SizedBox(
                  height: 60,
                  width: Get.width,
                  child: BNOutlinedButton(
                    child: Text('삭제하기'),
                    onPressed: () {
                      Get.back();
                      controller.deleteCompnayInfo(company);
                    },
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 60,
                  width: Get.width,
                  // margin: const EdgeInsets.all(12),
                  child: BNColoredButton(
                    child: Text('수정하기'),
                    onPressed: () {
                      Get.back();
                      showCompanyInfoEdit(company);
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

  Future<void> showCompanyInfoEdit(Company company) {
    Widget bottomSheetHandle = Container(
      width: 52,
      height: 6,
      decoration: BoxDecoration(
        color: theme.baseDark,
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      ),
    );

    final nameController = TextEditingController();
    final descController = TextEditingController();
    nameController.text = company.name;
    descController.text = company.description ?? '';
    bool isActive = true;
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
                drawBaseLabel('거래처 이름'),
                const SizedBox(height: 8),
                BNInputBox(
                  controller: nameController,
                  onChanged: (value) {},
                ),
                const SizedBox(height: 12),
                drawBaseLabel('설명'),
                const SizedBox(height: 8),
                BNInputBox(
                  controller: descController,
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
                    child: const Text('수정하기'),
                    onPressed: () {
                      if (nameController.text.isEmpty) {
                        Get.toast('거래처 이름을 입력 해 주세요.');
                        return;
                      }
                      final updatedCompany = company.copyWith(
                        name: nameController.text,
                        description: descController.text != '' ? descController.text : null,
                        isActive: isSelected[0],
                      );
                      controller.updateCompanyInfo(updatedCompany);
                      Get.back();
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

  Future<void> showAddCompany() {
    Widget bottomSheetHandle = Container(
      width: 52,
      height: 6,
      decoration: BoxDecoration(
        color: theme.baseDark,
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      ),
    );

    final nameController = TextEditingController();
    final descController = TextEditingController();
    bool isActive = true;
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
                drawBaseLabel('거래처 이름'),
                const SizedBox(height: 8),
                BNInputBox(
                  controller: nameController,
                  onChanged: (value) {},
                ),
                const SizedBox(height: 12),
                drawBaseLabel('설명'),
                const SizedBox(height: 8),
                BNInputBox(
                  controller: descController,
                  onChanged: (value) {},
                ),
                const SizedBox(height: 20),
                drawBaseLabel('거래처 활성 상태'),
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
                            '입고처',
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
                            '출고처',
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
                SizedBox(
                  height: 60,
                  width: Get.width,
                  child: BNColoredButton(
                    child: Text('저장하기'),
                    onPressed: () {
                      if (nameController.text.isEmpty) {
                        Get.toast('거래처 이름을 입력 해 주세요.');
                        return;
                      }
                      Get.back();
                      controller.addNewCompany(nameController.text, descController.text,
                          isSelected[0] ? CompanyType.input : CompanyType.output);
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
