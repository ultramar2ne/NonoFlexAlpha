import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/conf/ui/base_widgets.dart';
import 'package:nonoflex_alpha/view/product/add_product_viewmodel.dart';

class AddProductView extends BaseGetView<AddProductViewModel> {

  Widget drawHeader() {
    final title = controller.viewMode == ViewMode.add
        ? 'AddProductViewTitleAdd'.tr
        : 'AddProductViewTitleAdd'.tr;
    return drawActionPageTitle(title);
  }


}