import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/conf/ui/base_widgets.dart';
import 'package:nonoflex_alpha/conf/ui/widgets.dart';
import 'package:nonoflex_alpha/gen/assets.gen.dart';
import 'package:nonoflex_alpha/model/data/product.dart';
import 'package:nonoflex_alpha/view/product/add_product_viewmodel.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart' as scanner;
import 'package:barcode_widget/barcode_widget.dart' as viewer;

class AddProductView extends BaseGetView<AddProductViewModel> {
  Widget drawHeader() {
    final title = controller.viewMode == ViewMode.add
        ? 'AddProductViewTitleAdd'.tr
        : 'AddProductViewTitleEdit'.tr;
    return drawActionPageTitle(title);
  }

  @override
  Widget drawBody() {
    if (controller.viewMode == ViewMode.edit && controller.currentProduct == null) {
      return const SizedBox.shrink();
    }

    final isEditMode = controller.viewMode == ViewMode.edit;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Obx(
        () => Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              const SizedBox(height: 16),
              drawBaseActionLabel('AddProductViewLabelImage'.tr),
              const SizedBox(height: 8),
              drawImagePickerItem(),
              // image item

              // 물품 이름
              const SizedBox(height: 16),
              drawBaseActionLabel('AddProductViewLabelName'.tr, isRequired: true),
              const SizedBox(height: 8),
              BNInputBox(
                controller: controller.name,
                onChanged: (value) => controller.updateIdField(value),
                hintText: 'AddProductViewPlaceHolderName'.tr,
                errorMessage: controller.nameErrorMessage.value != ''
                    ? controller.nameErrorMessage.value
                    : null,
              ),

              // 물품 설명
              const SizedBox(height: 16),
              drawBaseActionLabel('AddProductViewLabelDescription'.tr),
              const SizedBox(height: 8),
              BNInputBox(
                controller: controller.description,
                onChanged: (value) {},
                hintText: 'AddProductViewPlaceHolderDescription'.tr,
                errorMessage: controller.descriptionErrorMessage.value != ''
                    ? controller.descriptionErrorMessage.value
                    : null,
                maxLines: 3,
              ),

              // 물품 코드
              const SizedBox(height: 16),
              drawBaseActionLabel('AddProductViewLabelCode'.tr, isRequired: true),
              const SizedBox(height: 8),
              BNInputBox(
                controller: controller.code,
                onChanged: (value) => controller.updateIdField(value),
                hintText: 'AddProductViewPlaceHolderCode'.tr,
                errorMessage: controller.codeErrorMessage.value != ''
                    ? controller.codeErrorMessage.value
                    : null,
              ),

              // 물품 바코드
              const SizedBox(height: 16),
              drawBaseActionLabel('AddProductViewLabelBarcode'.tr),
              const SizedBox(height: 8),
              BNOutlinedButton(
                onPressed: () async {
                  final barcode = await controller.baseNavigator.goScannerPage();
                  if (barcode is scanner.Barcode && (barcode).code != null) {
                    controller.barcode.value = barcode;
                  }
                },
                child: controller.barcode.value.code == null
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
                    : controller.fromScanner(controller.barcode.value.format) != null
                        ? viewer.BarcodeWidget(
                            data: controller.barcode.value.code!,
                            barcode: controller.fromScanner(controller.barcode.value.format)!)
                        : Column(
                            children: [
                              const Text('바코드 형식을 확인할 수 없습니다.'),
                              Text(controller.barcode.value.code!),
                            ],
                          ),
                // : QrImage(data: controller.barcode.value.code!,)
              ),

              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        // 물품 분류
                        drawBaseActionLabel('AddProductViewLabelCategory'.tr, isRequired: true),
                        const SizedBox(height: 8),
                        drawProductCategoryData(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      children: [
                        // 물품 보관 방법
                        drawBaseActionLabel('AddProductViewLabelStorageMethod'.tr,
                            isRequired: true),
                        const SizedBox(height: 8),
                        drawStorageTypeData(),
                      ],
                    ),
                  ),
                ],
              ),

              // 규격
              const SizedBox(height: 16),
              drawBaseActionLabel('AddProductViewLabelStandard'.tr, isRequired: true),
              const SizedBox(height: 8),
              BNInputBox(
                controller: controller.standard,
                onChanged: (value) {},
                hintText: 'AddProductViewPlaceHolderStandard'.tr,
                errorMessage: controller.standardErrorMessage.value != ''
                    ? controller.standardErrorMessage.value
                    : null,
              ),

              // 제조사
              const SizedBox(height: 16),
              drawBaseActionLabel('AddProductViewLabelMaker'.tr),
              const SizedBox(height: 8),
              BNInputBox(
                controller: controller.maker,
                onChanged: (value) {},
                hintText: 'AddProductViewPlaceHolderMaker'.tr,
                errorMessage: controller.makerErrorMessage.value != ''
                    ? controller.makerErrorMessage.value
                    : null,
              ),

              // 재고
              if (!isEditMode) ...[
                const SizedBox(height: 16),
                drawBaseActionLabel('AddProductViewLabelStock'.tr),
                const SizedBox(height: 8),
                BNInputBox(
                  controller: controller.stock,
                  onChanged: (value) {},
                  hintText: 'AddProductViewPlaceHolderStock'.tr,
                  keyboardType: TextInputType.number,
                  errorMessage: controller.stockErrorMessage.value != ''
                      ? controller.stockErrorMessage.value
                      : null,
                ),
              ],

              // 입고 금액
              const SizedBox(height: 16),
              drawBaseActionLabel('AddProductViewLabelInputPrice'.tr),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: BNInputBox(
                      controller: controller.inputPrice,
                      onChanged: (value) {},
                      // hintText: 'inputPriceErrorMessage'.tr,
                      keyboardType: TextInputType.number,
                      errorMessage: controller.inputPriceErrorMessage.value != ''
                          ? controller.inputPriceErrorMessage.value
                          : null,
                    ),
                  ),
                  const SizedBox(width: 36),
                  Text(
                    '원',
                    style: theme.listTitle,
                  ),
                  const SizedBox(width: 12),
                ],
              ),

              // 출고 금액
              const SizedBox(height: 16),
              drawBaseActionLabel('AddProductViewLabelOutputPrice'.tr),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: BNInputBox(
                      keyboardType: TextInputType.number,
                      controller: controller.outputPrice,
                      onChanged: (value) {},
                      // hintText: 'AddProductViewPlaceHolderName'.tr,
                      errorMessage: controller.outputPriceErrorMessage.value != ''
                          ? controller.outputPriceErrorMessage.value
                          : null,
                    ),
                  ),
                  const SizedBox(width: 36),
                  Text(
                    '원',
                    style: theme.listTitle,
                  ),
                  const SizedBox(width: 12),
                ],
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget drawFooter() {
    if (controller.viewMode == ViewMode.edit && controller.currentProduct == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: Get.width,
      height: 76,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: BNColoredButton(
        child: Text(
          '저장하기',
          style: theme.button.copyWith(color: theme.base),
        ),
        onPressed: () => controller.onClickedSaveButton(),
      ),
    );
  }
}

extension AddProductViewExt on AddProductView {
  // 이미지
  Widget drawImagePickerItem() {
    final emptyImageBackground = ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: SizedBox(
        width: 80,
        height: 80,
        child: controller.imagePath.value != ''
            ? Image.file(
                File(controller.imagePath.value),
                fit: BoxFit.cover,
              )
            : controller.networkImageInfo != null
                ? CachedNetworkImage(
                    imageUrl: controller.networkImageInfo!.thumbnailImageUrl,
                    fit: BoxFit.cover,
                  )
                : ColoredBox(color: theme.secondaryDark),
      ),
    );

    return Container(
      width: Get.width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: theme.baseDark, borderRadius: BorderRadius.circular(8.0)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 24),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '- 최대 10MB 파일\n- png, jpg 확장자 가능',
                    style: theme.listSubBody,
                  ),
                ),
                emptyImageBackground,
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: Get.width,
            height: 42,
            child: Row(
              children: [
                Expanded(
                  child: BNColoredButton(
                    child: Text('불러오기'),
                    onPressed: () async {
                      final _picker = ImagePicker();
                      final image = await _picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        controller.imagePath.value = image.path;
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                BNTextButton(
                  '초기화',
                  onPressed: () async {
                    controller.onClickedInitialImage();
                  },
                  textColor: theme.primaryDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 물품 분류 select 박스
  Widget drawProductCategoryData() {
    const categoryList = ProductCategory.values;
    List<DropdownMenuItem<ProductCategory>> menuItems = [];

    for (int i = 0; i < categoryList.length; i++) {
      menuItems.add(
        DropdownMenuItem<ProductCategory>(
          onTap: () {},
          value: categoryList[i],
          child: Text(
            categoryList[i].displayName,
            style: theme.listSubBody,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
      decoration: BoxDecoration(
        color: theme.baseDark,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Obx(
        () => DropdownButton<ProductCategory>(
          value: controller.category.value,
          items: menuItems,
          onChanged: (value) => value != null ? controller.updateCategoryField(value) : {},
          elevation: 1,
          underline: const SizedBox.shrink(),
          dropdownColor: theme.base,
          icon: Assets.icons.icExpandOn.image(width: 24, height: 24, color: theme.nonoBlue),
          isExpanded: true,
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  // 보관 방법 select 박스
  Widget drawStorageTypeData() {
    const categoryList = StorageType.values;
    List<DropdownMenuItem<StorageType>> menuItems = [];

    for (int i = 0; i < categoryList.length; i++) {
      menuItems.add(
        DropdownMenuItem<StorageType>(
          onTap: () {},
          value: categoryList[i],
          child: Text(
            categoryList[i].displayName,
            style: theme.listSubBody,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
      decoration: BoxDecoration(
        color: theme.baseDark,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Obx(
        () => DropdownButton<StorageType>(
          value: controller.storageType.value,
          items: menuItems,
          onChanged: (value) => value != null ? controller.updateStorageTypeField(value) : {},
          elevation: 1,
          underline: const SizedBox.shrink(),
          dropdownColor: theme.base,
          icon: Assets.icons.icExpandOn.image(width: 24, height: 24, color: theme.nonoBlue),
          isExpanded: true,
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
