import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/cmm/utils.dart';
import 'package:nonoflex_alpha/conf/ui/base_widgets.dart';
import 'package:nonoflex_alpha/model/data/document.dart';
import 'package:nonoflex_alpha/view/document/document_detail_viewmodel.dart';

class DocumentDetailView extends BaseGetView<DocumentDetailViewModel> {
  @override
  Widget drawHeader() {
    if (controller.documentInfo == null) return const SizedBox.shrink();

    final documentInfo = controller.documentInfo!;
    return drawSubPageTitle(documentInfo.docType.displayName);
  }

  @override
  Widget drawBody() {
    if (controller.documentInfo == null) return const SizedBox.shrink();

    final documentInfo = controller.documentInfo!;
    return Column(
      children: [
        drawDocumentBasicInfo(documentInfo),
        drawProductRecords(documentInfo),
      ],
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

  // 입출고 물품 기록 영역
  Widget drawProductRecords(DocumentDetail item) {
    final label = item.docType == DocumentType.input
        ? 'DocumentDetailViewLabelInputProduct'.tr
        : 'DocumentDetailViewLabelOutputProduct'.tr;

    final recordList = item.recordList;

    return Column(
      children: [
        const SizedBox(height: 8),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: drawBaseLabel(label)),
        const SizedBox(height: 4),
        SizedBox(
          height: Get.height / 2,
          child: recordList.isEmpty
              ? Center(
                  child: Text(
                    'DocumentDetailViewPlaceHolderEmptyRecords'.tr,
                    style: theme.hint,
                  ),
                )
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: recordList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = recordList[index];
                    return drawRecordOfDocumentListItem(
                      item,
                      onClicked: () => controller.loadProductDetailInfo(item.productInfo),
                    );
                  },
                ),
        )
      ],
    );
  }
}
