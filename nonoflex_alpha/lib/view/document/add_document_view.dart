import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/cmm/ui/dialog.dart';
import 'package:nonoflex_alpha/cmm/utils.dart';
import 'package:nonoflex_alpha/conf/ui/base_widgets.dart';
import 'package:nonoflex_alpha/conf/ui/widgets.dart';
import 'package:nonoflex_alpha/gen/assets.gen.dart';
import 'package:nonoflex_alpha/model/data/document.dart';
import 'package:nonoflex_alpha/model/data/record.dart';
import 'package:nonoflex_alpha/view/document/add_document_viewmodel.dart';

class AddDocumentView extends BaseGetView<AddDocumentViewModel> {
  @override
  Future<bool>? willPopCallback() {
    return Get.confirmDialog('문서 작업을 종료하시겠습니까?\n작업한 내용은 저장되지 않습니다.');
  }

  @override
  Widget drawHeader() {
    return drawActionPageTitle('${controller.documentType.displayName} 작성');
  }

  @override
  Widget drawBody() {
    final isInputDocument = controller.documentType == DocumentType.input ||
        controller.documentType == DocumentType.tempInput;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            const SizedBox(height: 16),
            drawBaseLabel(isInputDocument
                ? 'AddDocumentLabelInputDatePicker'.tr
                : 'AddDocumentLabelOutputDatePicker'.tr),
            const SizedBox(height: 8),
            Container(
              width: Get.width,
              height: 50,
              child: BNOutlinedButton(
                onPressed: () async {
                  if (!controller.configs.isAdminMode) return;
                  final date = await showDatePicker(
                      context: Get.context!,
                      initialDate: controller.selectedDate.value,
                      firstDate: DateTime(2022),
                      lastDate: DateTime(DateTime.now().year, DateTime.now().month + 3, 30),
                      helpText: '',
                      cancelText: '취소',
                      confirmText: '확인');
                  if (date != null) {
                    controller.selectedDate.value = date;
                  }
                },
                child: Obx(
                  () => Text(
                    formatDateYMDE(controller.selectedDate.value),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 26),
            drawBaseLabel(isInputDocument
                ? 'AddDocumentLabelInputCompany'.tr
                : 'AddDocumentLabelOutputCompany'.tr),
            const SizedBox(height: 8),
            Container(
              width: Get.width,
              height: 50,
              child: BNOutlinedButton(
                onPressed: () {
                  controller.company_searchValue.clear();
                  controller.getCompanyList();
                  showSelectCompanyBottomSheet();
                },
                child: Obx(
                  () => Text(controller.selectedCompanyName.value == ''
                      ? '거래처를 선택 해 주세요.'
                      : controller.selectedCompanyName.value),
                ),
              ),
            ),
            const SizedBox(height: 20),
            drawBaseLabel('AddDocumentLabelSelectProduct'.tr,
                item1: BNTextButton(
                  '추가하기',
                  onPressed: () async {
                    controller.initProductListStatus();
                    await showSelectProductBottomSheet();
                  },
                  textColor: theme.primary,
                )),
            const SizedBox(height: 8),
            drawSelectedProductList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget drawFooter() {
    return Container(
      width: Get.width,
      height: 76,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: BNColoredButton(
        child: Text(
          'AddDocumentButtonSave'.tr,
          style: theme.button.copyWith(color: theme.base),
        ),
        onPressed: () => controller.onClickedSave(),
      ),
    );
  }
}

extension AddDocumentViewExt on AddDocumentView {
  // 선택 된 물품 리스트
  Widget drawSelectedProductList() {
    return Obx(
      () => Container(
        height: controller.selectedProductItems.value.length * 80,
        constraints: BoxConstraints(minHeight: Get.width / 2),
        child: controller.selectedProductItems.value.isEmpty
            ? Center(
                child: Text(
                'AddDocumentPlaceHolderEmptySelecteItem'.tr,
                style: theme.hint,
              ))
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: controller.selectedProductItems.value.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = controller.selectedProductItems.value[index];
                  return drawProductItemWithStock(
                    item.product,
                    item.count,
                    item.price,
                    controller.isInput,
                    onClicked: () async {
                      await changeProductItemCount(item);
                      controller.update();
                    },
                    onDeleted: () => controller.removeProduct(item.product),
                  );
                },
              ),
      ),
    );
  }
}

extension AddDocumentViewBottomSheetExt on AddDocumentView {
  Widget get bottomSheetHandle => Container(
        width: 52,
        height: 6,
        decoration: BoxDecoration(
          color: theme.baseDark,
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        ),
      );

  // 거래처 선택
  Future<void> showSelectCompanyBottomSheet() async {
    return Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: theme.base,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12.0), topRight: Radius.circular(12.0)),
        ),
        margin: const EdgeInsets.only(top: 80),
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
                const SizedBox(height: 16),
                BNInputBox(
                  controller: controller.company_searchValue,
                  onChanged: (value) {
                    if (value == '') controller.getCompanyList();
                  },
                  onSubmitted: (value) {
                    controller.getCompanyList();
                  },
                  showSearchButton: true,
                  hintText: '거래처 이름을 입력 해 주세요.',
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Obx(
                    () => ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: controller.companyItems.value.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = controller.companyItems.value[index];
                        return drawCompanyListItem(item, onClicked: () {
                          Get.back();
                          controller.selectCompany(item);
                        });
                      },
                    ),
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

  // 물품 선택
  Future<void> showSelectProductBottomSheet() async {
    return Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: theme.base,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12.0), topRight: Radius.circular(12.0)),
        ),
        margin: const EdgeInsets.only(top: 80),
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
                const SizedBox(height: 16),
                BNInputBox(
                  controller: controller.company_searchValue,
                  onChanged: (value) => controller.onChangedSearchValue(value),
                  onSubmitted: (value) => controller.onSearchProduct(value),
                  showSearchButton: true,
                  hintText: '물품 이름을 입력 해 주세요.',
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Obx(
                    () {
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: controller.productItems.value.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = controller.productItems.value[index];
                          final itemIndex = controller.selectedProductItems.value
                              .indexWhere((el) => el.product.productId == item.productId);

                          final count = itemIndex != -1
                              ? controller.selectedProductItems[itemIndex].count
                              : 0;
                          final price = itemIndex != -1
                              ? controller.selectedProductItems[itemIndex].price
                              : controller.isInput
                                  ? item.price ?? 0
                                  : item.marginPrice ?? 0;
                          return drawProductItemWithStock(
                            item,
                            count,
                            price,
                            controller.isInput,
                            onClicked: () async {
                              Get.back();
                              await changeProductItemCount(
                                  RecordForAddDocument(item, count, price));
                              showSelectProductBottomSheet();
                              controller.update();
                            },
                          );
                        },
                      );
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

  // 물품 갯수 선택 dialog
  Future<void> changeProductItemCount(RecordForAddDocument selectedItem) async {
    final countController = TextEditingController(text: '${selectedItem.count}');
    final priceController = TextEditingController(text: '${selectedItem.price}');

    final productCountWidget = AlertDialog(
      contentPadding: EdgeInsets.zero,
      // color: Colors.transparent,
      content: Container(
        padding: const EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: theme.base,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              drawActionPageTitle(selectedItem.product.prdName, fontSize: 20, padding: 0),
              const SizedBox(height: 12),
              drawBaseLabel('거래 금액'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: BNInputBox(
                      controller: priceController,
                      onChanged: (value) {
                        // if (double.tryParse(value) == null) {
                        //   String kk = value.replaceAll(RegExp('\\D'), '');
                        //   priceController.text = kk;
                        //   return;
                        // }
                      },
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '원',
                    style: theme.listTitle,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              drawBaseLabel('거래 항목 수'),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BNIconButton(
                      onPressed: () {
                        int? count = int.tryParse(countController.text);
                        if (count == null || count == 0) return;
                        count -= 1;
                        countController.text = '$count';
                      },
                      icon: Assets.icons.icMinusCircle.image()),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      width: 90,
                      child: BNInputBox(
                        controller: countController,
                        onChanged: (value) {},
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        maxLength: 3,
                        showTextCount: false,
                        showCursor: false,
                      )),
                  BNIconButton(
                      onPressed: () {
                        int? count = int.tryParse(countController.text);
                        if (count == null || count == 999) return;
                        count += 1;
                        countController.text = '$count';
                      },
                      icon: Assets.icons.icAddCircle.image()),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: Get.width,
                height: 52,
                child: BNColoredButton(
                  onPressed: () {
                    if (countController.text == '0' ||
                        countController.text == '' ||
                        double.tryParse(priceController.text) == null ||
                        int.tryParse(countController.text) == null) {
                      Get.toast('입력된 정보가 올바르지 않습니다.');
                      return;
                    }
                    controller.selectProduct(selectedItem.product,
                        double.parse(priceController.text), int.parse(countController.text));
                    Get.back();
                  },
                  child: Text('확인'),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return await Get.dialog(productCountWidget);
  }
}
