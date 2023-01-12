import 'package:flutter/material.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/cmm/ui/dialog.dart';
import 'package:nonoflex_alpha/conf/ui/base_widgets.dart';
import 'package:nonoflex_alpha/conf/ui/widgets.dart';
import 'package:nonoflex_alpha/gen/assets.gen.dart';
import 'package:nonoflex_alpha/model/data/product.dart';
import 'package:nonoflex_alpha/view/more/add_barcode_viewmodel.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart' as scanner;
import 'package:barcode_widget/barcode_widget.dart' as viewer;

import 'package:get/get.dart';

class BarcodeSettingView extends BaseGetView<BarcodeSettingViewModel> {
  @override
  Widget drawHeader() {
    return drawSubPageTitle(
      '바코드 설정',
    );
  }

  @override
  Widget drawBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: drawBaseLabel(
            'ProductListViewLabelProductList'.tr,
            // item1: BNIconButton(
            //   onPressed: () => showProductListSortMenu(),
            //   icon: Assets.icons.icListMenu.image(width: 24, height: 24),
            // ),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Obx(
            () => drawProductList(controller.productItems.value),
          ),
        ),
      ],
    );
  }

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
        // if (index == count - 1 && !controller.isLastPage) {
        //   controller.getProductList();
        // }

        final item = list[index];
        return drawProductBarcodeListItem(item, onClicked: () => showProductBarcodeSetting(item));
      },
    );
  }

  // 물품 추가 설정 영역
  Future<void> showProductBarcodeSetting(Product product) {
    Widget bottomSheetHandle = Container(
      width: 52,
      height: 6,
      decoration: BoxDecoration(
        color: theme.baseDark,
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      ),
    );

    // barcode 정보
    final Rx<scanner.Barcode> barcode = scanner.Barcode(product.barcode,
            scanner.BarcodeTypesExtension.fromString(product.barcodeType ?? ''), null)
        .obs;

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
                  drawBaseLabel(
                    '바코드',
                    item1: product.barcode != null && product.barcode != ''
                        ? BNTextButton(
                            '초기화',
                            onPressed: () async {
                              if (await Get.confirmDialog('바코드 정보를 삭제하시겠습니까?')) {
                                final productForUpdate = product.clearBarcode();
                                controller.updateProductInfo(productForUpdate);
                                Get.back();
                              }
                            },
                            textColor: theme.primaryDark,
                          )
                        : const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => BNOutlinedButton(
                      onPressed: () async {
                        final barcodeForDraw = await controller.baseNavigator.goScannerPage();
                        if (barcodeForDraw is scanner.Barcode && barcodeForDraw.code != null) {
                          barcode.value = barcodeForDraw;
                        }
                      },
                      child: barcode.value.code == null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'AddProductViewPlaceHolderBarcode'.tr,
                                  style: theme.normal,
                                ),
                                const SizedBox(width: 8),
                                Assets.icons.icScan.image(
                                  width: 24,
                                  height: 24,
                                ),
                              ],
                            )
                          : controller.fromScanner(barcode.value.format) != null
                              ? viewer.BarcodeWidget(
                                  data: barcode.value.code!,
                                  barcode: controller.fromScanner(barcode.value.format)!)
                              : SizedBox(
                                  width: Get.width,
                                  child: Column(
                                    children: [
                                      const Text('바코드 형식을 확인할 수 없습니다.'),
                                      Text(barcode.value.code!),
                                    ],
                                  ),
                                ),
                      // : QrImage(data: controller.barcode.value.code!,)
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      '바코드를 선택하여 정보를 수정할 수 있습니다.',
                      style: theme.listBody.copyWith(color: theme.nonoOrange),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 60,
                    width: Get.width,
                    // margin: const EdgeInsets.all(12),
                    child: BNColoredButton(
                      child: const Text('저장하기'),
                      onPressed: () {
                        if (product.barcode == barcode.value.code &&
                            product.barcodeType == barcode.value.format.formatName) {
                          Get.toast('수정된 내용이 없습니다.');
                        } else {
                          final productForUpdate = product.copyWith(
                            barcode: barcode.value.code,
                            barcodeType: barcode.value.format.formatName,
                          );
                          controller.updateProductInfo(productForUpdate);
                        }
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
