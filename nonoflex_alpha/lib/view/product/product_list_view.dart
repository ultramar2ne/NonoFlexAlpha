import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/conf/ui/widgets.dart';
import 'package:nonoflex_alpha/gen/assets.gen.dart';
import 'package:nonoflex_alpha/model/data/product.dart';
import 'package:nonoflex_alpha/view/product/product_list_viewmodel.dart';

import 'package:get/get.dart';

class ProductListView extends BaseGetView<ProductListViewModel> {
  @override
  Widget drawHeader() => drawMainPageTitle('ProductListViewTitle'.tr);

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

extension MainPageCommonWidget on ProductListView {
  /// 메인 화면 타이틀
  Widget drawMainPageTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 82,
      width: Get.width,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: theme.title.copyWith(
                color: theme.textDark,
                fontWeight: FontWeight.w600,
                fontSize: 26,
              ),
            ),
          ),
          BNIconButton(
            onPressed: () => controller.onClickedAddButton(),
            icon: Assets.icons.icAdd.image(width: 24, height: 24),
          ),
          const SizedBox(width: 4),
          BNIconButton(
            onPressed: () {},
            icon: Assets.icons.icSearch.image(width: 24, height: 24),
          ),
        ],
      ),
    );
  }
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
        return _drawProductListItemNormal(list[index]);
      },
    );
  }

  /// 물품 목록 항목 위젯
  Widget _drawProductListItemNormal(Product item) {
    final emptyImageBackground = Container(
      width: 50,
      height: 50,
      color: theme.baseDark,
    );

    final listItemStyle = ButtonStyle(
      padding: MaterialStateProperty.all<EdgeInsets>(
        const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      shape: MaterialStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      elevation: MaterialStateProperty.all<double>(0),
      overlayColor: MaterialStateProperty.all<Color>(theme.secondary),
      backgroundColor: MaterialStateProperty.all<Color>(theme.base),
    );

    return TextButton(
      onPressed: () => controller.onClcikedProductItem(item),
      style: listItemStyle,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // image
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            child: CachedNetworkImage(
              width: 50,
              height: 50,
              imageUrl: item.imageData?.thumbnailImageUrl ?? '',
              fit: BoxFit.fill,
              errorWidget: (BuildContext context, String url, dynamic error) {
                return emptyImageBackground;
              },
              placeholder: (BuildContext context, String url) {
                return emptyImageBackground;
              },
            ),
          ),
          const SizedBox(width: 12),
          // product name, more info ..?
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.prdName,
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                  style: theme.listTitle,
                ),
                Text(
                  '${item.stock} ${item.unit}',
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                  style: theme.listBody.copyWith(
                    color: theme.nonoOrange,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
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
