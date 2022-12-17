import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/conf/ui/base_widgets.dart';
import 'package:nonoflex_alpha/conf/ui/widgets.dart';
import 'package:nonoflex_alpha/gen/assets.gen.dart';
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
                _drawDetailInfoItem('ProductDetailViewLabelCategory'.tr, item.category),
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        children: [
          drawBaseLabel('ProductDetailViewLabelRecords'.tr, item1: _drawMonthChanger()),
          const SizedBox(height: 4),
          SizedBox(
            height: Get.height / 2,
            child: recordList.isEmpty
                ? Center(
                    child: Text(
                    'ProductDetailViewPlaceHolderEmptyRecords'.tr,
                    style: theme.hint,
                  ))
                : ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      final item = recordList[index];
                      return drawRecordOfProductListItem(
                        item,
                        onClicked: () {},
                      );
                    },
                  ),
          )
        ],
      ),
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
