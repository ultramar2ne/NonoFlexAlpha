import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/conf/ui/base_widgets.dart';
import 'package:nonoflex_alpha/conf/ui/widgets.dart';
import 'package:nonoflex_alpha/gen/assets.gen.dart';
import 'package:nonoflex_alpha/model/data/document.dart';
import 'package:nonoflex_alpha/view/document/document_list_viewmodel.dart';

import 'package:get/get.dart';

class DocumentListView extends BaseGetView<DocumentListViewModel> {
  @override
  Widget drawHeader() => drawMainPageTitle(
        'DocumentListViewTitle'.tr,
        buttonList: [
          if (controller.configs.isAdminMode) ...[
            BNIconButton(
              onPressed: () => showDocumentAddMenu(),
              icon: Assets.icons.icAdd.image(width: 24, height: 24),
            ),
            const SizedBox(width: 8)
          ],
          BNIconButton(
            onPressed: () => showDocumentListSortMenu(),
            icon: Assets.icons.icSort.image(width: 24, height: 24),
          ),
        ],
        showBackButton: !controller.configs.isAdminMode,
      );

  @override
  Widget drawBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!controller.configs.isAdminMode) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: drawBaseLabel('문서 작성'.tr),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 64,
                  child: BNTextButton(
                    '',
                    onPressed: () => controller.goAddDocument(DocumentType.input),
                    item: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Assets.icons.icInput.image(width: 24, height: 24, color: theme.primary),
                        const SizedBox(width: 8),
                        Text(
                          '입고서 작성',
                          style: theme.button.copyWith(color: theme.textDark),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 64,
                  child: BNTextButton(
                    '',
                    onPressed: () => controller.goAddDocument(DocumentType.output),
                    item: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Assets.icons.icInput.image(width: 24, height: 24, color: theme.error),
                        const SizedBox(width: 8),
                        Text(
                          '출고서 작성',
                          style: theme.button.copyWith(color: theme.textDark),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          const SizedBox(height: 12),
        ],
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: drawBaseLabel(
            'DocumentListViewLabelDocumentList'.tr,
            item1: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (controller.configs.isAdminMode) ...[
                  _drawYearSelector(),
                  const SizedBox(width: 12),
                ],
                _drawMonthSelector(),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
        Expanded(
          child: Obx(
            () => drawDocumentList(controller.documentItems),
          ),
        ),
      ],
    );
  }
}

extension DocumentListViewItems on DocumentListView {
  /// 확인서 목록 위젯
  Widget drawDocumentList(List<DocumentDetail>? items) {
    if (items == null || items.isEmpty) {
      return Center(
        child: Text(
          'commonEmptyListView'.tr,
          style: theme.button,
        ),
      );
    }

    final list = items;
    final count = items.length;
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        if (index == count - 1 && !controller.isLastPage) {
          controller.getDocumentList();
        }

        final item = list[index];
        return drawDocumentListItem(item, onClicked: () => controller.goDocumentDetailInfo(item));
      },
    );
  }

  Future<void> showDocumentAddMenu() {
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
                const SizedBox(height: 16),
                if (controller.configs.isAdminMode && false) ...[
                  drawBaseLabel('예정서 작성'),
                  const SizedBox(height: 8),
                  _drawSettingListItem('입고 예정서 작성',
                      icon: Assets.icons.icInput
                          .image(width: 20, height: 20, color: theme.nonoBlue), onPressed: () {
                    Get.back();
                    controller.goAddDocument(DocumentType.tempInput);
                  }),
                  _drawSettingListItem('출고 예정서 작성',
                      icon: Assets.icons.icOutput.image(width: 20, height: 20, color: theme.error),
                      onPressed: () {
                    Get.back();
                    controller.goAddDocument(DocumentType.tempOutput);
                  }),
                  const SizedBox(height: 12),
                ],

                drawBaseLabel('확인서 작성'),
                const SizedBox(height: 8),
                _drawSettingListItem('입고 확인서 작성',
                    icon: Assets.icons.icInput.image(width: 20, height: 20, color: theme.nonoBlue),
                    onPressed: () {
                  Get.back();
                  controller.goAddDocument(DocumentType.input);
                }),
                _drawSettingListItem('출고 확인서 작성',
                    icon: Assets.icons.icOutput.image(width: 20, height: 20, color: theme.error),
                    onPressed: () {
                  Get.back();
                  controller.goAddDocument(DocumentType.output);
                }),
                const SizedBox(height: 36),

                // productListSortMenu,
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  /// 공통으로 사용되는 설정 항목 항목
  Widget _drawSettingListItem(String title, {required VoidCallback? onPressed, Image? icon}) {
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
              ),
            ),
            icon ?? Assets.icons.icArrowForward.image(width: 16, height: 16),
            const SizedBox(width: 5),
          ],
        ),
      ),
    );
  }

  Future<void> showDocumentListSortMenu() {
    Widget bottomSheetHandle = Container(
      width: 52,
      height: 6,
      decoration: BoxDecoration(
        color: theme.baseDark,
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      ),
    );

    // 특정 날짜 선택
    final isSelectedDate = controller.isSelectedDate.value.obs;
    final selectedDate = controller.selectedDate.value.obs;

    // 오름차순, 내림차순
    final RxList<bool> isSelected = [false].obs;
    isSelected.value.insert(controller.isDesc ? 1 : 0, true);

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
                const SizedBox(height: 20),
                drawBaseLabel('날짜 선택하기'),
                const SizedBox(height: 8),
                Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: BNOutlinedButton(
                            onPressed: () async {
                              final currentDate = DateTime.now();
                              final date = await showDatePicker(
                                  context: Get.context!,
                                  initialDate: selectedDate.value,
                                  firstDate: controller.configs.isAdminMode
                                      ? DateTime(2022)
                                      : DateTime(DateTime.now().year),
                                  lastDate: DateTime(
                                      currentDate.year, currentDate.month, currentDate.day),
                                  helpText: '',
                                  cancelText: '취소',
                                  confirmText: '확인');
                              if (date != null) {
                                selectedDate.value = date;
                                isSelectedDate.value = true;
                              }
                            },
                            child: Text(isSelectedDate.value
                                ? DateFormat('yyyy년 MM월 dd').format(selectedDate.value).toString()
                                : '날짜를 선택 해 주세요.'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 52,
                        child: BNColoredButton(
                          onPressed: () {
                            selectedDate.value = DateTime.now();
                            isSelectedDate.value = false;
                          },
                          child: Text('초기화'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                drawBaseLabel('정렬 방향'),
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
                            '오름차순',
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
                            '내림차순',
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
                    child: const Text('정렬 기준 적용하기'),
                    onPressed: () {
                      controller.updateSortType(isSelected[0],
                          date: isSelectedDate.value ? selectedDate.value : null);
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
    );
  }
}

extension dateSelectExtension on DocumentListView {
  Widget _drawYearSelector() {
    final yearList = controller.selectableYearList;
    List<DropdownMenuItem<int>> menuItems = [];

    for (int i = 0; i < yearList.length; i++) {
      menuItems.add(
        DropdownMenuItem<int>(
          onTap: () {},
          value: yearList[i],
          child: Container(
            child: Text(
              '${yearList[i].toString()} 년',
              style: theme.listSubBody,
            ),
          ),
        ),
      );
    }

    return Obx(
      () => DropdownButton<int>(
        value: controller.selectedYear.value,
        items: menuItems,
        onChanged: (value) => value != null ? controller.onSelectedYear(value) : {},
        elevation: 1,
        menuMaxHeight: 300,
        underline: const SizedBox.shrink(),
        dropdownColor: theme.base,
        icon: Assets.icons.icExpandOn.image(width: 24, height: 24, color: theme.nonoOrange),
        // isExpanded: true,
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  Widget _drawMonthSelector() {
    controller.updateMonthList(controller.selectedYear.value);
    return Obx(() {
      final monthList = controller.monthList;
      List<DropdownMenuItem<int>> menuItems = [];

      for (int i = 0; i < monthList.length; i++) {
        menuItems.add(
          DropdownMenuItem<int>(
            onTap: () {},
            value: monthList[i],
            child: Container(
              child: Text(
                '${monthList[i].toString()} 월',
                style: theme.listSubBody,
              ),
            ),
          ),
        );
      }

      return DropdownButton<int>(
        value: controller.selectedMonth.value,
        items: menuItems,
        onChanged: (value) => value != null ? controller.onSelectedMonth(value) : {},
        elevation: 1,
        menuMaxHeight: 300,
        underline: const SizedBox.shrink(),
        dropdownColor: theme.base,
        icon: Assets.icons.icExpandOn.image(width: 24, height: 24, color: theme.nonoOrange),
        // isExpanded: true,
        borderRadius: BorderRadius.circular(8.0),
      );
    });
  }
}
