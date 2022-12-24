import 'package:flutter/material.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/conf/ui/base_widgets.dart';
import 'package:nonoflex_alpha/conf/ui/widgets.dart';
import 'package:nonoflex_alpha/gen/assets.gen.dart';
import 'package:nonoflex_alpha/model/data/document.dart';
import 'package:nonoflex_alpha/view/document/document_list_viewmodel.dart';

import 'package:get/get.dart';

class DocumentListView extends BaseGetView<DocumentListViewModel> {
  @override
  Widget drawHeader() => drawMainPageTitle('DocumentListViewTitle'.tr);

  @override
  Widget drawBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: drawBaseLabel(
            'DocumentListViewLabelDocumentList'.tr,
            item1: BNIconButton(
              onPressed: () => {},
              icon: Assets.icons.icListMenu.image(width: 24, height: 24),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [_drawYearSelector(), _drawMonthChanger()],
          ),
        ),
        const SizedBox(height: 12),
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
        if (index == count - 1 && !controller.isLastPage) {
          controller.getDocumentList();
        }

        final item = list[index];
        return drawDocumentListItem(item, onClicked: () => controller.goDocumentDetailInfo(item));
      },
    );
  }

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
              yearList[i].toString(),
              style: theme.listSubBody,
            ),
          ),
        ),
      );
    }

    return Obx(
      () => DropdownButton<int>(
        value: controller.currentYear.value,
        items: menuItems,
        onChanged: (value) => value != null ? controller.onSelectedYear(value) : {},
        elevation: 1,
        underline: const SizedBox.shrink(),
        dropdownColor: theme.base,
        icon: Assets.icons.icExpandOn.image(width: 24, height: 24, color: theme.nonoOrange),
        // isExpanded: true,
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  Widget _drawMonthChanger() {
    return Obx(
      () => Row(
        children: [
          BNIconButton(
              onPressed: () => controller.onChangeMonth(false),
              icon: Assets.icons.icArrowBack.image(width: 16, height: 16)),
          Text(
            '${controller.currentMonth.value.toString()} 월',
            style: theme.normal,
          ),
          BNIconButton(
              onPressed: () => controller.onChangeMonth(true),
              icon: Assets.icons.icArrowForward.image(width: 16, height: 16)),
        ],
      ),
    );
  }
}
