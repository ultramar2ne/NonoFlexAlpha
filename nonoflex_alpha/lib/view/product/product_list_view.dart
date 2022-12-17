import 'package:flutter/material.dart';
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
        button1: BNIconButton(
          onPressed: () => controller.onClickedAddButton(),
          icon: Assets.icons.icAdd.image(width: 24, height: 24),
        ),
        button2: BNIconButton(
          onPressed: () {},
          icon: Assets.icons.icSearch.image(width: 24, height: 24),
        ),
      );

  @override
  Widget drawBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ProductListViewLabelProductList'.tr,
                style: theme.label,
              ),
              BNIconButton(
                onPressed: () => showProductListSortMenu(),
                icon: Assets.icons.icListMenu.image(width: 24, height: 24),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Obx(
            () => drawProductList(controller.productItems),
          ),
        ),
        // drawProductListItem(null),
        // drawTempDocumentInfoItem()
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
        return drawProductListItem(item, onClicked: () => controller.onClcikedProductItem(item));
      },
    );
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

    Widget productListSortMenu = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              // width: ,
              decoration: BoxDecoration(
                color: theme.baseDark,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: DropdownButton(
                value: 'a',
                elevation: 1,
                underline: const SizedBox.shrink(),
                dropdownColor: theme.base,
                icon: Assets.icons.icExpandOn.image(width: 24, height: 24),
                isExpanded: true,
                borderRadius: BorderRadius.circular(8.0),
                items: [
                  DropdownMenuItem<String>(
                    onTap: () {},
                    value: 'a',
                    child: Container(
                      // color: theme.secondaryLight,
                      child: Text('a'),
                    ),
                  ),
                  DropdownMenuItem<String>(
                    onTap: () {},
                    value: 'b',
                    child: Container(
                      color: theme.baseDark,
                      child: Text('b'),
                    ),
                  ),
                  DropdownMenuItem<String>(
                    onTap: () {},
                    value: 'c',
                    child: Container(
                      color: theme.baseDark,
                      child: Text('c'),
                    ),
                  ),
                ],
                onChanged: (value) {},
              ),
            ),
          ),
        ),
      ],
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
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: bottomSheetHandle,
                  ),
                ),
                productListSortMenu,
              ],
            ),
          ),
        ),
      ),
      // isScrollControlled: true,
      // ignoreSafeArea: true,
    );
  }
}
