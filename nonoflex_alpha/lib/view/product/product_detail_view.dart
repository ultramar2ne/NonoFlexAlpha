import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/cmm/utils.dart';
import 'package:nonoflex_alpha/conf/ui/base_widgets.dart';
import 'package:nonoflex_alpha/conf/ui/widgets.dart';
import 'package:nonoflex_alpha/gen/assets.gen.dart';
import 'package:nonoflex_alpha/model/data/company.dart';
import 'package:nonoflex_alpha/model/data/document.dart';
import 'package:nonoflex_alpha/model/data/product.dart';
import 'package:nonoflex_alpha/view/product/product_detail_viewmodel.dart';

import '../../model/data/record.dart';

class ProductDetailView extends BaseGetView<ProductDetailViewModel> {
  @override
  Widget drawHeader() => drawSubPageTitle(
        'ProductDetailViewTitle'.tr,
        button1: BNIconButton(
          onPressed: () => controller.goEditProductInfo(),
          icon: Assets.icons.icEdit.image(width: 24, height: 24),
        ),
      );

  @override
  Widget drawBody() {
    if (controller.productItem == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          drawProductBasicInfo(controller.productItem!),
          drawProductDetailInfo(controller.productItem!),
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

  /// 물품 입출고 기록 영역
  Widget drawProductRecords(List<RecordOfProduct> recordList) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: drawBaseLabel(
            'ProductDetailViewLabelRecords'.tr,
            item1: _drawMonthChanger(),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: recordList.length * 68,
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

  Widget _drawMonthChanger() {
    return Obx(
      () => Row(
        children: [
          BNIconButton(
              onPressed: () => controller.onChangeMonth(false),
              icon: Assets.icons.icArrowBack.image(width: 16, height: 16)),
          Text(
            '${controller.currentMonth.value.toString()} 월',
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
