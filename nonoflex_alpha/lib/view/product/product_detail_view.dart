import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/cmm/ui/dialog.dart';
import 'package:nonoflex_alpha/cmm/utils.dart';
import 'package:nonoflex_alpha/conf/ui/base_widgets.dart';
import 'package:nonoflex_alpha/conf/ui/widgets.dart';
import 'package:nonoflex_alpha/gen/assets.gen.dart';
import 'package:nonoflex_alpha/model/data/document.dart';
import 'package:nonoflex_alpha/model/data/product.dart';
import 'package:nonoflex_alpha/view/product/product_detail_viewmodel.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart' as scanner;
import 'package:barcode_widget/barcode_widget.dart' as viewer;

import '../../model/data/record.dart';

class ProductDetailView extends BaseGetView<ProductDetailViewModel> {
  @override
  Widget drawHeader() {
    final button = controller.configs.isAdminMode
        ? BNIconButton(
            onPressed: () => controller.goEditProductInfo(),
            icon: Assets.icons.icEdit.image(width: 24, height: 24),
          )
        : BNIconButton(
            onPressed: () => showProductSummaryInfo(),
            icon: Assets.icons.icInfo.image(width: 24, height: 24),
          );
    return drawSubPageTitle('ProductDetailViewTitle'.tr, button1: button);
  }

  @override
  Widget drawBody() {
    if (controller.productItem == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          drawProductBasicInfo(controller.productItem!),
          if (controller.configs.isAdminMode) drawProductDetailInfo(controller.productItem!),
          const SizedBox(height: 8),
          drawProductRecords(controller.currentRecords),
        ],
      ),
    );
  }
}

extension ProductDetailViewItems on ProductDetailView {
  /// 물품 기본 정보 영역
  Widget drawProductBasicInfo(Product item) {
    final emptyImageBackground = Container(
      width: 60,
      height: 60,
      color: theme.baseDark,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (!item.isActive) ...[
                  Text(
                    '* 현재 비활성화 되어있는 물품입니다.',
                    maxLines: 2,
                    overflow: TextOverflow.visible,
                    style: theme.small.copyWith(
                      fontSize: 12,
                      color: theme.error,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                Text(
                  item.prdName,
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                  style: theme.large.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
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
          const SizedBox(width: 8),
          // image
          InkWell(
            onTap: () => Get.dialog(
                Material(
                  color: theme.base,
                  child: Column(
                    children: [
                      Expanded(
                        child: Hero(
                          tag: item.productId,
                          child: CachedNetworkImage(
                            httpHeaders: {
                              'Authorization': 'Bearer ${controller.configs.accessToken ?? ''}'
                            },
                            imageUrl: item.imageData?.imageUrl ?? '',
                            errorWidget: (BuildContext context, String url, dynamic error) {
                              return emptyImageBackground;
                            },
                            placeholder: (BuildContext context, String url) {
                              return emptyImageBackground;
                            },
                          ),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: BNIconButton(
                            onPressed: () => Get.back(),
                            icon: Assets.icons.icCancelCircle
                                .image(width: 50, height: 50, color: theme.primary),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                barrierDismissible: true),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              child: Hero(
                tag: item.productId,
                child: CachedNetworkImage(
                  width: 60,
                  height: 60,
                  httpHeaders: {'Authorization': 'Bearer ${controller.configs.accessToken ?? ''}'},
                  imageUrl: item.imageData?.imageUrl ?? '',
                  fit: BoxFit.fill,
                  errorWidget: (BuildContext context, String url, dynamic error) {
                    return emptyImageBackground;
                  },
                  placeholder: (BuildContext context, String url) {
                    return emptyImageBackground;
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 물품 정보 영역
  Widget drawProductDetailInfo(Product item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        children: [
          drawBaseLabel('ProductDetailViewLabelInfo'.tr,
              item1: controller.configs.isAdminMode
                  ? BNIconButton(
                      onPressed: () => showProductSetting(item),
                      icon: Assets.icons.icNaviSetting.image(width: 16, height: 16),
                    )
                  : null),
          const SizedBox(height: 8),
          Container(
            width: Get.width,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: theme.baseDark,
            ),
            child: Column(
              children: [
                _drawDetailInfoItem('ProductDetailViewLabelPrdName'.tr, item.prdName),
                if (item.description != null &&
                    item.description != '' &&
                    item.description != item.prdName)
                  _drawDetailInfoItem('물품 설명'.tr, item.description!),
                if (item.barcode != null && item.barcode != '')
                  _drawDetailInfoItem('ProductDetailViewLabelBarcode'.tr, item.barcode ?? ''),
                _drawDetailInfoItem('ProductDetailViewLabelPrdCode'.tr, item.productCode),
                _drawDetailInfoItem('ProductDetailViewLabelCategory'.tr, item.category.displayName),
                _drawDetailInfoItem(
                    'ProductDetailViewLabelStorageMethod'.tr, item.storageType.displayName),
                _drawDetailInfoItem('ProductDetailViewLabelStandard'.tr, item.unit),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.baseDark,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '입고 금액',
                        style: theme.listBody.copyWith(color: theme.primary),
                      ),
                      Text(
                        '${item.price} 원',
                        style: theme.listTitle,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.baseDark,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('출고 금액', style: theme.listBody.copyWith(color: theme.error)),
                      Text(
                        '${item.marginPrice} 원',
                        style: theme.listTitle,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _drawDetailInfoItem(String title, String content, {Widget? item}) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          SizedBox(
            width: Get.width / 4,
            child: Text(
              title,
              style: theme.normal.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: item ??
                Text(
                  content,
                  style: theme.normal.copyWith(fontSize: 14),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
          ),
        ],
      ),
    );
  }

  /// 물품 입출고 기록 영역
  Widget drawProductRecords(List<RecordOfProduct> recordList) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: drawBaseLabel(
            'ProductDetailViewLabelRecords'.tr,
            // item1: _drawMonthChanger(),
            item1: controller.configs.isAdminMode
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _drawYearSelector(),
                      const SizedBox(width: 12),
                      _drawMonthSelector(),
                      const SizedBox(height: 12),
                    ],
                  )
                : _drawMonthChanger(),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: recordList.length * 90,
          constraints: BoxConstraints(minHeight: Get.width / 3),
          child: recordList.isEmpty
              ? Center(
                  child: Text(
                  'ProductDetailViewPlaceHolderEmptyRecords'.tr,
                  style: theme.hint,
                ))
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  // physics: const NeverScrollableScrollPhysics(),
                  itemCount: recordList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = recordList[index];
                    return drawRecordOfProductListItem(
                      item,
                      onClicked: () async {
                        final documentInfo =
                            await controller.getDocumentDetailInfo(item.documentId);
                        if (documentInfo != null) showDocumentSummaryInfo(documentInfo);
                      },
                    );
                  },
                ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  // 물품 추가 설정 영역
  Future<void> showProductSetting(Product product) {
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

    // 활성화, 비활성화
    final RxList<bool> isSelected = [false].obs;
    isSelected.value.insert(product.isActive ? 0 : 1, true);

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
                  drawBaseLabel('바코드'),
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
                              : Column(
                                  children: [
                                    const Text('바코드 형식을 확인할 수 없습니다.'),
                                    Text(barcode.value.code!),
                                  ],
                                ),
                      // : QrImage(data: controller.barcode.value.code!,)
                    ),
                  ),
                  const SizedBox(height: 20),
                  drawBaseLabel('물품 활성 상태'),
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
                  const SizedBox(height: 36),
                  Container(
                    height: 60,
                    width: Get.width,
                    // margin: const EdgeInsets.all(12),
                    child: BNColoredButton(
                      child: const Text('저장하기'),
                      onPressed: () {
                        if (product.isActive == isSelected.value[0] &&
                            product.barcode == barcode.value.code &&
                            product.barcodeType == barcode.value.format.formatName) {
                          Get.toast('수정된 내용이 없습니다.');
                        } else {
                          final productForUpdate = product.copyWith(
                            barcode: barcode.value.code,
                            barcodeType: barcode.value.format.formatName,
                            isActive: isSelected.value[0],
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

  // 문서 정보 요약 표시
  Future<void> showDocumentSummaryInfo(DocumentDetail document) {
    final badge = Container(
      width: 120,
      height: 30,
      decoration: BoxDecoration(
        color: document.docType == DocumentType.input ? theme.nonoBlue : theme.error,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: Text(
          document.docType.displayName,
          style: theme.small.copyWith(color: theme.base, fontSize: 14, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
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
                    child: badge,
                  ),
                ),
                drawDocumentBasicInfo(document),
                const SizedBox(height: 8),
                Container(
                  height: 60,
                  width: Get.width,
                  margin: const EdgeInsets.all(12),
                  child: BNColoredButton(
                    child: Text('더보기'),
                    onPressed: () {
                      Get.back();
                      controller.goDocumentDetailPage(document.documentId);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  // 물품 정보 요약 표시
  Future<void> showProductSummaryInfo() async {
    if (controller.productItem == null) return;
    final product = controller.productItem!;
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
                drawProductDetailInfo(product),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}

extension ProductDetailViewDocumentSummary on ProductDetailView {
  /// 문서 기본 정보 영역
  Widget drawDocumentBasicInfo(DocumentDetail item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        children: [
          drawBaseLabel('DocumentDetailViewLabelInfo'.tr),
          const SizedBox(height: 6),
          Container(
            width: Get.width,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: theme.baseDark,
            ),
            child: Column(
              children: [
                _drawDetailInfoItem('DocumentDetailViewLabelDocumentCode'.tr, '${item.documentId}'),
                _drawDetailInfoItem('DocumentDetailViewLabelCompanyName'.tr, item.companyName),
                _drawDetailInfoItem('DocumentDetailViewLabelWriter'.tr, item.writer),
                _drawDetailInfoItem(
                    item.docType == DocumentType.input
                        ? 'DocumentDetailViewLabelDateInput'.tr
                        : 'DocumentDetailViewLabelDateOutput'.tr,
                    formatDateYMDE(item.date)),
                _drawDetailInfoItem('DocumentDetailViewLabelPrice'.tr, '${item.totalPrice} ￦'),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _drawDetailInfoItem(String title, String content) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Row(
        children: [
          SizedBox(
            width: Get.width / 4,
            child: Text(
              title,
              style: theme.normal,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              content,
              style: theme.normal,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

extension DateSelectExt on ProductDetailView {
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

  Widget _drawMonthChanger() {
    return Obx(
      () => Row(
        children: [
          BNIconButton(
              onPressed: () => controller.onChangeMonth(false),
              icon: Assets.icons.icArrowBack.image(width: 16, height: 16)),
          Text(
            '${controller.selectedMonth.value.toString()} 월',
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
