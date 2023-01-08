import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/conf/ui/widgets.dart';
import 'package:nonoflex_alpha/gen/assets.gen.dart';
import 'package:nonoflex_alpha/model/repository/document/document_repository.dart';
import 'package:nonoflex_alpha/view/util/make_excel_viewmodel.dart';

class MakeExcelView extends BaseGetView<MakeExcelViewModel> {
  @override
  AppBar? defaultAppBar() {
    return BNDefaultAppBar();
  }

  @override
  Widget drawBody() {
    return Container(
      width: Get.width,
      margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        color: theme.baseDark,
        // border: Border.all(
        //   color: theme.primary,
        //   width: 2.5,
        // ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Text(
                  '입/출고 데이터 엑셀파일을 메일로 전송합니다.\n\n원하시는 연/월 데이터를 선택 후 [자료 만들기] 버튼을 선택 해 주세요! \n\n요청 후 파일 생성까지 최소 몇 초 에서 최대 10분의 시간이 걸릴 수 있습니다. \n\n이 점 참고하시어 확인부탁드립니다.',
                  style: theme.listSubBody.copyWith(color: theme.textDark, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 36),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '연도 선택',
                    style: theme.label.copyWith(fontSize: 16, color: theme.primaryDark),
                  ),
                ),
                const SizedBox(height: 12),
                _drawYearSelector(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 36),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '월 선택',
                    style: theme.label.copyWith(fontSize: 16, color: theme.primaryDark),
                  ),
                ),
                const SizedBox(height: 12),
                _drawMonthSelector(),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  @override
  Widget drawFooter() {
    return Container(
      margin: const EdgeInsets.only(bottom: 30, top: 12),
      width: Get.width,
      height: 76,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: BNColoredButton(
        child: Text(
          '자료 만들기',
          style: theme.button.copyWith(color: theme.base),
        ),
        onPressed: () => controller.requestMakeExcelDocument(),
      ),
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
        value: controller.year.value,
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
    final monthList = controller.selectableMonthList;
    List<DropdownMenuItem<int>> menuItems = [];

    for (int i = 0; i < monthList.length; i++) {
      menuItems.add(
        DropdownMenuItem<int>(
          onTap: () {},
          value: monthList[i],
          child: Container(
            child: Text(
              monthList[i].toString(),
              style: theme.listSubBody,
            ),
          ),
        ),
      );
    }

    return Obx(
      () => DropdownButton<int>(
        value: controller.month.value,
        items: menuItems,
        onChanged: (value) => value != null ? controller.onSelectedMonth(value) : {},
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

  Widget _drawMonthChanger() {
    return Obx(
      () => Row(
        children: [
          BNIconButton(
              onPressed: () => controller.onChangeMonth(false),
              icon: Assets.icons.icArrowBack.image(width: 16, height: 16)),
          Text(
            '${controller.month.value.toString()} 월',
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
