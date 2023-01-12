import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/cmm/utils.dart';
import 'package:nonoflex_alpha/conf/config.dart';
import 'package:nonoflex_alpha/conf/ui/base_widgets.dart';
import 'package:nonoflex_alpha/conf/ui/widgets.dart';
import 'package:nonoflex_alpha/gen/assets.gen.dart';
import 'package:nonoflex_alpha/model/data/document.dart';
import 'package:nonoflex_alpha/model/data/product.dart';
import 'package:nonoflex_alpha/view/document/document_detail_viewmodel.dart';

class DocumentDetailView extends BaseGetView<DocumentDetailViewModel> {
  @override
  Widget drawHeader() {
    if (controller.documentInfo == null) return const SizedBox.shrink();

    final documentInfo = controller.documentInfo!;
    return drawSubPageTitle(
      documentInfo.docType.displayName,
      button1: controller.configs.isAdminMode
          ? controller.checkDocumentEditValidation()
              ? BNIconButton(
                  onPressed: () => controller.goDocumentEditPage(),
                  icon: Assets.icons.icEdit.image(width: 24, height: 24),
                )
              : null
          : null,
    );
  }

  @override
  Widget drawBody() {
    if (controller.documentInfo == null) return const SizedBox.shrink();

    final documentInfo = controller.documentInfo!;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          drawDocumentBasicInfo(documentInfo),
          drawProductRecords(documentInfo),
        ],
      ),
    );
  }
}

extension DocumentDetailViewItems on DocumentDetailView {
  /// 문서 기본 정보 영역
  Widget drawDocumentBasicInfo(DocumentDetail item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        children: [
          drawBaseLabel('DocumentDetailViewLabelInfo'.tr),
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
                _drawDetailInfoItem('DocumentDetailViewLabelDocumentCode'.tr, '${item.documentId}'),
                _drawDetailInfoItem('DocumentDetailViewLabelCompanyName'.tr, item.companyName),
                _drawDetailInfoItem('DocumentDetailViewLabelWriter'.tr, item.writer),
                _drawDetailInfoItem(
                    item.docType == DocumentType.input
                        ? 'DocumentDetailViewLabelDateInput'.tr
                        : 'DocumentDetailViewLabelDateOutput'.tr,
                    formatDateYMDE(item.date)),
                _drawDetailInfoItem('DocumentDetailViewLabelPrice'.tr, '${item.totalPrice} ￦'),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (controller.checkDocumentDeleteValidation())
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          width: Get.width,
                          child: BNTextButton(
                            '삭제하기',
                            onPressed: () => controller.deleteDocument(),
                            textColor: theme.error,
                            effectColor: theme.error.withOpacity(0.05),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ),
                    if (controller.checkDocumentEditValidation() && !controller.configs.isAdminMode)
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          width: Get.width,
                          child: BNTextButton(
                            '수정하기',
                            onPressed: () => controller.goDocumentEditPage(),
                            textColor: theme.nonoYellow,
                            effectColor: theme.nonoYellow.withOpacity(0.05),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ),
                  ],
                )
              ],
            ),
          ),
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
          ),
        ],
      ),
    );
  }

  // 입출고 물품 기록 영역
  Widget drawProductRecords(DocumentDetail item) {
    final label = item.docType == DocumentType.input
        ? 'DocumentDetailViewLabelInputProduct'.tr
        : 'DocumentDetailViewLabelOutputProduct'.tr;

    final recordList = item.recordList;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: drawBaseLabel(label)),
        const SizedBox(height: 4),
        Container(
          height: recordList.length * 100,
          constraints: BoxConstraints(minHeight: Get.width / 3),
          child: recordList.isEmpty
              ? Center(
                  child: Text(
                    'DocumentDetailViewPlaceHolderEmptyRecords'.tr,
                    style: theme.hint,
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: recordList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = recordList[index];
                      return drawRecordOfDocumentListItem(
                        item,
                        onClicked: () => showProductSummaryInfo(item.productInfo),
                        isInput: controller.documentInfo!.docType == DocumentType.input,
                      );
                    },
                  ),
                ),
        )
      ],
    );
  }

  // 물품 정보 요약 표시
  Future<void> showProductSummaryInfo(Product product) {
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
                drawProductBasicInfo(product),
                drawProductDetailInfo(product),
                const SizedBox(height: 8),
                Container(
                  height: 60,
                  width: Get.width,
                  margin: const EdgeInsets.all(12),
                  child: BNColoredButton(
                    child: Text('더보기'),
                    onPressed: () {
                      Get.back();
                      controller.loadProductDetailInfo(product);
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
}

extension DocumentDetailViewProductSummary on DocumentDetailView {
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
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            child: CachedNetworkImage(
              width: 60,
              height: 60,
              httpHeaders: {'Authorization': 'Bearer ${Configs().accessToken ?? ''}'},
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
          drawBaseLabel('ProductDetailViewLabelInfo'.tr),
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
                _drawDetailInfoItem('ProductDetailViewLabelPrdName'.tr, item.prdName),
                if (item.barcode != null)
                  _drawDetailInfoItem('ProductDetailViewLabelBarcode'.tr, item.barcode ?? ''),
                _drawDetailInfoItem('ProductDetailViewLabelPrdCode'.tr, item.productCode),
                _drawDetailInfoItem('ProductDetailViewLabelCategory'.tr, item.category.displayName),
                _drawDetailInfoItem(
                    'ProductDetailViewLabelStorageMethod'.tr, item.storageType.displayName),
                _drawDetailInfoItem('ProductDetailViewLabelStandard'.tr, item.unit),
              ],
            ),
          )
        ],
      ),
    );
  }
}
