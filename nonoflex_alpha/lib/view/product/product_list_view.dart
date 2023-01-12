import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/conf/ui/base_widgets.dart';
import 'package:nonoflex_alpha/conf/ui/widgets.dart';
import 'package:nonoflex_alpha/gen/assets.gen.dart';
import 'package:nonoflex_alpha/model/data/product.dart';
import 'package:nonoflex_alpha/view/product/product_list_viewmodel.dart';

import 'package:get/get.dart';

class ProductListView extends BaseGetView<ProductListViewModel> {
  @override
  Widget drawHeader() => drawMainPageTitle(
        'ProductListViewTitle'.tr,
        buttonList: [
          if (controller.configs.isAdminMode)
            BNIconButton(
              onPressed: () => controller.onClickedAddButton(),
              icon: Assets.icons.icAdd.image(width: 24, height: 24),
            ),
          const SizedBox(width: 8),
          BNIconButton(
            onPressed: () => showProductListSortMenu(),
            icon: Assets.icons.icSort.image(width: 24, height: 24),
          ),
          const SizedBox(width: 8),
          Obx(
            () => BNIconButton(
              onPressed: () => controller.toggleVisibilitySearchBar(),
              icon: controller.searchVarVisible.value
                  ? Assets.icons.icCancel.image(width: 24, height: 24)
                  : Assets.icons.icSearch.image(width: 24, height: 24),
            ),
          ),
        ],
        showBackButton: !controller.configs.isAdminMode,
      );

  @override
  Widget drawBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          if (!controller.searchVarVisible.value) {
            FocusScope.of(currentContext!).unfocus();
          }
          return AnimatedContainer(
            duration: const Duration(seconds: 1),
            curve: Curves.fastLinearToSlowEaseIn,
            height: controller.searchVarVisible.value ? 80 : 0,
            alignment: Alignment.center,
            child: AnimatedOpacity(
              opacity: controller.searchVarVisible.value ? 1 : 0,
              duration: const Duration(milliseconds: 500),
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                child: BNInputBox(
                  controller: controller.searchValue,
                  onChanged: (value) => controller.onChangedSearchValue(value),
                  onSubmitted: (value) => controller.onSearch(value),
                  showSearchButton: true,
                  hintText: '물품 이름을 입력 해 주세요.',
                ),
              ),
            ),
          );
        }),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: drawBaseLabel(
            'ProductListViewLabelProductList'.tr,
            item1: Obx(
              () => BNIconButton(
                onPressed: () {
                  controller.isGridMode.toggle();
                  controller.updateListLayout();
                },
                icon: controller.isGridMode.value
                    ? Assets.icons.icListview.image(width: 20, height: 20)
                    : Assets.icons.icGridview.image(width: 20, height: 20),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Obx(
            () => drawProductList(controller.productItems),
          ),
        ),
      ],
    );
  }

  /// TODO
  /// 항목 추가, 항목 검색 버튼
  /// 검색 알고리즘 구체화

}

extension ProductListViewItems on ProductListView {
  /// 물품 목록 위젯
  Widget drawProductList(List<Product>? items) {
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
    if (controller.isGridMode.value) {
      // grid view
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childAspectRatio: 0.8,
          ),
          itemCount: count,
          itemBuilder: (BuildContext context, int index) {
            if (index == count - 1 && !controller.isLastPage) {
              controller.getProductList();
            }

            final item = list[index];
            return drawProductGridItem(item,
                onClicked: () => controller.onClcikedProductItem(item));
          },
        ),
      );
    } else {
      // list view
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: count,
        itemBuilder: (BuildContext context, int index) {
          if (index == count - 1 && !controller.isLastPage) {
            controller.getProductList();
          }

          final item = list[index];
          return drawProductListItem(item, onClicked: () => controller.onClcikedProductItem(item));
        },
      );
    }
  }

  Future<void> showProductListSortMenu() {
    Widget bottomSheetHandle = Container(
      width: 52,
      height: 6,
      decoration: BoxDecoration(
        color: theme.baseDark,
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      ),
    );

    // 비활성물품 포함

    // 정렬 기준
    const sortList = ProductListSortType.values;
    List<DropdownMenuItem<ProductListSortType>> menuItems = [];

    for (int i = 0; i < sortList.length; i++) {
      menuItems.add(
        DropdownMenuItem<ProductListSortType>(
          onTap: () {
            controller.sortTypeValue.value = sortList[i].serverValue;
          },
          value: sortList[i],
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              sortList[i].displayName,
              style: theme.listSubBody,
            ),
          ),
        ),
      );
    }

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
                  drawBaseLabel('정렬 기준'),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                      decoration: BoxDecoration(
                        color: theme.baseDark,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Obx(
                        () => DropdownButton<ProductListSortType>(
                          value: ProductListSortType.fromServer(controller.sortTypeValue.value),
                          items: menuItems,
                          onChanged: (value) {},
                          elevation: 1,
                          menuMaxHeight: 300,
                          underline: const SizedBox.shrink(),
                          dropdownColor: theme.base,
                          icon: Assets.icons.icExpandOn
                              .image(width: 24, height: 24, color: theme.nonoOrange),
                          // isExpanded: true,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
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
                  if (controller.configs.isAdminMode) ...[
                    const SizedBox(height: 20),
                    drawBaseLabel('비활성 물품'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Spacer(),
                        Text(
                          '비 활성 물품 포함하여 보기',
                          style: theme.listBody,
                        ),
                        Obx(
                          () => Transform.scale(
                            scale: 1.2,
                            child: Checkbox(
                              value: !controller.onlyActiveItem.value,
                              onChanged: (value) => controller.onlyActiveItem.toggle(),
                              fillColor: MaterialStateProperty.resolveWith<Color>(
                                (states) => states.contains(MaterialState.selected)
                                    ? theme.primary
                                    : theme.secondary,
                              ),
                              checkColor: Colors.transparent,
                              shape:
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 50),
                  Container(
                    height: 60,
                    width: Get.width,
                    // margin: const EdgeInsets.all(12),
                    child: BNColoredButton(
                      child: const Text('정렬 기준 적용하기'),
                      onPressed: () {
                        controller.updateSortType(isSelected[0]);
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
        isScrollControlled: true);
  }
}
