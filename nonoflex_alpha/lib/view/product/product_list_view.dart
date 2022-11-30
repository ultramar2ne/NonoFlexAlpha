import 'package:flutter/material.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/view/product/product_list_viewmodel.dart';

import 'package:get/get.dart';

class ProductListView extends BaseGetView<ProductListViewModel> {
  @override
  Widget drawHeader() => drawMainPageTitle('ProductListViewTitle'.tr);
}

extension MainPageCommonWidget on ProductListView {
  Widget drawMainPageTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 82,
      width: Get.width,
      child: Row(
        children: [
          Text(
            title,
            style: theme.title.copyWith(
              color: theme.textColoredDark,
              fontWeight: FontWeight.w600,
              fontSize: 26,
            ),
          ),
        ],
      ),
    );
  }
}

