import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/cmm/utils.dart';
import 'package:nonoflex_alpha/conf/ui/widgets.dart';
import 'package:nonoflex_alpha/gen/assets.gen.dart';

import '../../model/data/document.dart';
import '../../model/data/product.dart';
import '../../model/data/record.dart';
import '../../model/data/user.dart';

extension BaseWidget on BaseGetView {
  // region - 공통 위젯
  /// - 메인 타이틀 위젯 [drawMainPageTitle]
  /// - 서브 타이틀 위젯 [drawSubPageTitle]
  /// - 액션 타이틀 위젯 [drawActionPageTitle]
  /// - 아이템 라벨 [drawBaseLabel]

  // 메인 페이지에서 공통적으로 나타나는 타이틀 위젯
  Widget drawMainPageTitle(String title, {BNIconButton? button1, BNIconButton? button2}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 82,
      width: Get.width,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: theme.title.copyWith(
                color: theme.textDark,
                fontWeight: FontWeight.w600,
                fontSize: 26,
              ),
            ),
          ),
          button1 ?? const SizedBox.shrink(),
          const SizedBox(width: 4),
          button2 ?? const SizedBox.shrink(),
        ],
      ),
    );
  }

  /// 서브 페이지에서 공통적으로 나타나는 타이틀 위젯
  Widget drawSubPageTitle(String title, {BNIconButton? button1}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 60,
      width: Get.width,
      child: Row(
        children: [
          BNIconButton(
            onPressed: () => Get.back(),
            icon: Assets.icons.icArrowBack.image(width: 20, height: 20),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: theme.title.copyWith(
                  color: theme.textDark,
                  fontWeight: FontWeight.w500,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          button1 ?? const SizedBox(width: 24),
        ],
      ),
    );
  }

  /// 액션 페이지에서 공통적으로 나타나는 타이틀 위젯
  Widget drawActionPageTitle(String title, {Widget? titleItem}) {
    final item = titleItem ??
        Text(
          title,
          style: theme.title.copyWith(fontSize: 26),
        );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 80,
      width: Get.width,
      child: Row(
        children: [
          item,
          const Spacer(),
          const SizedBox(width: 12),
          BNIconButton(
            onPressed: () => Get.back(),
            icon: Assets.icons.icCancel.image(width: 32, height: 32, color: theme.primary),
          ),
        ],
      ),
    );
  }

  // 요소의 라벨을 나타내는 위젯
  Widget drawBaseLabel(String title, {Widget? item1, Widget? item2}) {
    return Row(
      children: [
        Text(title, style: theme.label),
        const Spacer(),
        item1 ?? const SizedBox.shrink(),
        if (item2 != null) const SizedBox(width: 4),
        item2 ?? const SizedBox.shrink(),
      ],
    );
  }

  // endregion

  // region - 리스트 아이템 항목
  /// - 물품 항목 [drawProductListItem]
  /// - 물품 상세 입출고 기록 항목 [drawRecordOfProductListItem]
  /// - 문서 항목 [drawDocumentListItem]
  /// - 문서 상세 입출고 기록 항목 [drawRecordOfDocumentListItem]
  /// - 사용자 항목 [drawUserListItem]

  /// 물품 항목 위젯
  Widget drawProductListItem(Product item, {VoidCallback? onClicked}) {
    final emptyImageBackground = Container(
      width: 50,
      height: 50,
      color: theme.baseDark,
    );

    return TextButton(
      onPressed: onClicked,
      style: listItemStyle,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // image
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            child: CachedNetworkImage(
              width: 50,
              height: 50,
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
          const SizedBox(width: 12),
          // product name, more info ..?
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.prdName,
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                  style: theme.listTitle,
                ),
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
        ],
      ),
    );
  }

  // 물품에 대한 입출고 기록
  Widget drawRecordOfProductListItem(RecordOfProduct item, {VoidCallback? onClicked}) {
    return TextButton(
      onPressed: onClicked,
      style: listItemStyle,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // product name, more info ..?
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatDateMDE(item.date),
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                  style: theme.listTitle,
                ),
                Text(
                  '${item.documentId}(${item.writer})}',
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                  style: theme.listBody.copyWith(
                    color: theme.nonoOrange,
                  ),
                )
              ],
            ),
          ),
          Text(
            item.docType == DocumentType.input ? '+ ${item.quantity}' : '- ${item.quantity}',
            maxLines: 1,
            overflow: TextOverflow.visible,
            style: theme.normal.copyWith(
              color: item.docType == DocumentType.input ? theme.nonoBlue : theme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${item.stock}',
            maxLines: 1,
            overflow: TextOverflow.visible,
            style: theme.normal.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget drawDocumentListItem(DocumentDetail item, {VoidCallback? onClicked}) {
    return TextButton(
      onPressed: onClicked,
      style: listItemStyle,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.companyName,
                  style: theme.listTitle,
                ),
                const SizedBox(height: 6),
                Text('${formatDateMD(item.date)} | ${item.writer}', style: theme.hint),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item.docType.displayName,
                  style: theme.listTitle.copyWith(
                    color: item.docType != DocumentType.input ? theme.textError : theme.nonoBlue,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${item.recordCount}개 품목',
                  style: theme.listSubBody,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // 문서에 대한 입출고 기록
  Widget drawRecordOfDocumentListItem(RecordOfDocument item, {VoidCallback? onClicked}) {
    final emptyImageBackground = Container(
      width: 50,
      height: 50,
      color: theme.baseDark,
    );

    return TextButton(
      onPressed: onClicked,
      style: listItemStyle,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // image
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            child: CachedNetworkImage(
              width: 50,
              height: 50,
              imageUrl: item.productInfo.imageData?.thumbnailImageUrl ?? '',
              fit: BoxFit.fill,
              errorWidget: (BuildContext context, String url, dynamic error) {
                return emptyImageBackground;
              },
              placeholder: (BuildContext context, String url) {
                return emptyImageBackground;
              },
            ),
          ),
          const SizedBox(width: 12),
          // product name, more info ..?
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productInfo.prdName,
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                  style: theme.listTitle,
                ),
                Text(
                  '${item.stock} ${item.productInfo.unit}',
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                  style: theme.listBody.copyWith(
                    color: theme.nonoOrange,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget drawUserListItem(User item, {VoidCallback? onClicked}) {
    return SizedBox.shrink();
  }

  // endregion

  // region - 테마 아이템
  /// - listItemStyle
  /// - listItemStyleDark

  ButtonStyle get listItemStyle => ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        elevation: MaterialStateProperty.all<double>(0),
        overlayColor: MaterialStateProperty.all<Color>(theme.secondary),
        backgroundColor: MaterialStateProperty.all<Color>(theme.base),
      );

  ButtonStyle get listItemStyleDark => ButtonStyle(
    padding: MaterialStateProperty.all<EdgeInsets>(
      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    ),
    shape: MaterialStateProperty.all<OutlinedBorder>(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    elevation: MaterialStateProperty.all<double>(0),
    overlayColor: MaterialStateProperty.all<Color>(theme.secondary),
    backgroundColor: MaterialStateProperty.all<Color>(theme.base),
  );

// endregion
}
