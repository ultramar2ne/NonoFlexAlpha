import 'package:barcode_widget/barcode_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/cmm/utils.dart';
import 'package:nonoflex_alpha/conf/ui/widgets.dart';
import 'package:nonoflex_alpha/gen/assets.gen.dart';
import 'package:nonoflex_alpha/model/data/company.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

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
  Widget drawMainPageTitle(String title, {List<Widget>? buttonList, bool showBackButton = false}) {
    return Container(
      padding: showBackButton
          ? const EdgeInsets.only(right: 16)
          : const EdgeInsets.symmetric(horizontal: 16),
      height: 82,
      width: Get.width,
      child: Row(
        children: [
          if (showBackButton) ...[
            IconButton(
              onPressed: () => Get.back(),
              icon: Assets.icons.icArrowBack.image(width: 20, height: 20),
            ),
            const SizedBox(width: 8),
          ],
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
          if (buttonList != null) ...buttonList
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
        crossAxisAlignment: CrossAxisAlignment.center,
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
          button1 ?? const SizedBox(width: 46),
        ],
      ),
    );
  }

  /// 액션 페이지에서 공통적으로 나타나는 타이틀 위젯
  Widget drawActionPageTitle(String title, {Widget? titleItem, double? fontSize, double? padding}) {
    final item = titleItem ??
        Text(
          title,
          style: theme.title.copyWith(fontSize: fontSize ?? 26),
        );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding ?? 16),
      height: padding == 0 ? 52 : 80,
      width: Get.width,
      child: Row(
        children: [
          Expanded(child: item),
          const SizedBox(width: 12),
          BNIconButton(
            onPressed: () => Get.back(),
            icon: Assets.icons.icCancel.image(width: 32, height: 32, color: theme.primary),
          ),
        ],
      ),
    );
  }

  /// 요소의 라벨을 나타내는 위젯
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

  /// 상품 추가 등 상세 정보를 입력할 때 설명 라벨을 나타내는 위젯
  Widget drawBaseActionLabel(String title, {bool isRequired = false}) {
    final dot = Container(
      width: 10,
      height: 10,
      margin: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: theme.nonoOrange,
      ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: theme.label.copyWith(color: theme.textDark)),
        if (isRequired) dot,
        const Spacer(),
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
      style: item.isActive ? listItemStyle : listItemStyleDark,
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
              fit: BoxFit.cover,
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
                  style: theme.listTitle
                      .copyWith(color: theme.textDark.withOpacity(item.isActive ? 1 : 0.45)),
                ),
                Text(
                  '${item.stock} ${item.unit}',
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                  style: theme.listBody.copyWith(
                    color: theme.nonoOrange.withOpacity(item.isActive ? 1 : 0.45),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// grid view 용 물품 목록
  Widget drawProductGridItem(Product item, {VoidCallback? onClicked}) {
    final emptyImageBackground = Container(
      width: 50,
      height: 50,
      color: theme.baseDark,
    );

    return TextButton(
      onPressed: onClicked,
      style: item.isActive ? listItemStyle : listItemStyleDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // image
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            child: CachedNetworkImage(
              width: Get.width / 2,
              height: Get.width / 4,
              imageUrl: item.imageData?.thumbnailImageUrl ?? '',
              fit: BoxFit.cover,
              errorWidget: (BuildContext context, String url, dynamic error) {
                return emptyImageBackground;
              },
              placeholder: (BuildContext context, String url) {
                return emptyImageBackground;
              },
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.prdName,
            maxLines: 2,
            overflow: TextOverflow.visible,
            style: theme.listTitle
                .copyWith(color: theme.textDark.withOpacity(item.isActive ? 1 : 0.45)),
          ),
          Text(
            '${item.stock} ${item.unit}',
            maxLines: 1,
            overflow: TextOverflow.visible,
            style: theme.listBody.copyWith(
              color: theme.nonoOrange.withOpacity(item.isActive ? 1 : 0.45),
            ),
          ),
        ],
      ),
    );
  }

  Widget drawProductBarcodeListItem(Product item, {VoidCallback? onClicked}) {
    final emptyImageBackground = Container(
      width: 50,
      height: 50,
      color: theme.baseDark,
    );

    return TextButton(
      onPressed: onClicked,
      style: item.isActive ? listItemStyle : listItemStyleDark,
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
              fit: BoxFit.fitWidth,
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
                  style: theme.listTitle
                      .copyWith(color: theme.textDark.withOpacity(item.isActive ? 1 : 0.45)),
                ),
                Text(
                  item.barcode == null || item.barcode == '' ? '바코드 정보가 존재하지 않습니다.' : item.barcode!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.listBody.copyWith(
                    color: theme.nonoOrange
                        .withOpacity(item.barcode == null || item.barcode == '' ? 0.45 : 1),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(width: 20),
          if (item.barcode != null)
            OutlinedButton(
              onPressed: onClicked,
              child: Utils.fromScanner(
                        BarcodeTypesExtension.fromString(item.barcodeType ?? ''),
                      ) !=
                      null
                  ? BarcodeWidget(
                      width: 60,
                      height: 50,
                      data: item.barcode!,
                      drawText: false,
                      barcode: Utils.fromScanner(
                        BarcodeTypesExtension.fromString(item.barcodeType ?? ''),
                      )!,
                    )
                  : const SizedBox.shrink(),
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
                  '${item.writer}(${item.documentId})',
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                  style: theme.listBody.copyWith(
                    color: theme.secondaryDark,
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.companyName,
                    style: theme.listTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${formatDateMD(item.date)} | ${item.writer}',
                    style: theme.hint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
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
  Widget drawRecordOfDocumentListItem(RecordOfDocument item,
      {VoidCallback? onClicked, bool isInput = false}) {
    final fixString = isInput ? '+ ' : '- ';
    final fixString2 = isInput ? '입고 후 재고' : '출고 후 재고';
    final textColor = isInput ? theme.primary : theme.error;

    return TextButton(
      onPressed: onClicked,
      style: listItemStyle,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productInfo.prdName,
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                  style: theme.listTitle,
                ),
                const SizedBox(height: 6),
                Text(
                  '$fixString2: ${item.stock} ${item.productInfo.unit}',
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                  style: theme.listBody.copyWith(
                      fontSize: 14, fontWeight: FontWeight.w400, color: theme.secondaryDark),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('$fixString${item.quantity}', style: theme.listTitle.copyWith(color: textColor)),
              const SizedBox(height: 6),
              Text('${item.recordPrice} 원', style: theme.listTitle),
            ],
          ),
        ],
      ),
    );
  }

  Widget drawProductItemWithStock(
    Product item,
    int count,
    double price,
    bool isInput, {
    VoidCallback? onClicked,
    VoidCallback? onDeleted,
  }) {
    final isAdded = count > 0;
    final fixString = isInput ? '+ ' : '- ';
    final textColor = isInput ? theme.primary : theme.error;

    return TextButton(
      onPressed: onClicked,
      style: isAdded ? listItemStyleSelected : listItemStyle,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.prdName,
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                  style: theme.listTitle,
                ),
                const SizedBox(height: 6),
                Text(
                  '현재 재고 : ${item.stock} ${item.unit}',
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                  style: theme.listBody.copyWith(
                    color: theme.nonoOrange,
                  ),
                )
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('$fixString$count', style: theme.listTitle.copyWith(color: textColor)),
              const SizedBox(height: 6),
              Text('$price 원', style: theme.listTitle),
            ],
          ),
          if (onDeleted != null) ...[
            const SizedBox(width: 12),
            BNIconButton(
                onPressed: onDeleted, icon: Assets.icons.icCancel.image(width: 24, height: 24)),
          ]
        ],
      ),
    );
  }

  Widget drawUserListItem(User item, {VoidCallback? onClicked, VoidCallback? onMenuClicked}) {
    final isAdmin = item.userType == UserType.admin;

    return TextButton(
      onPressed: onClicked,
      style: item.isActive ? listItemStyle : listItemStyleDark,
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
                  item.userName,
                  style: theme.listTitle
                      .copyWith(color: theme.textDark.withOpacity(item.isActive ? 1 : 0.45)),
                ),
                if (isAdmin) ...[
                  const SizedBox(height: 6),
                  Text(
                    item.id,
                    style: theme.hint
                        .copyWith(color: theme.textDark.withOpacity(item.isActive ? 1 : 0.45)),
                  ),
                ],
              ],
            ),
            if (onMenuClicked != null)
              BNIconButton(
                onPressed: onMenuClicked,
                icon: Assets.icons.icInfo.image(width: 24),
              ),
          ],
        ),
      ),
    );
  }

  Widget drawCompanyListItem(Company item, {VoidCallback? onClicked, VoidCallback? onMenuClicked}) {
    // final isAdmin = item.userType == UserType.admin;
    final badge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: (item.companyType == CompanyType.input ? theme.nonoBlue : theme.error)
            .withOpacity(item.isActive ? 1 : 0.3),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: Text(
          item.companyType.displayName,
          style: theme.small.copyWith(color: theme.base, fontSize: 10, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      ),
    );

    return TextButton(
      onPressed: onClicked,
      style: item.isActive ? listItemStyle : listItemStyleDark,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                badge,
                const SizedBox(height: 4),
                Text(
                  item.name,
                  style: theme.listTitle
                      .copyWith(color: theme.textDark.withOpacity(item.isActive ? 1 : 0.3)),
                ),
                if (item.description != null && item.description != '') ...[
                  const SizedBox(height: 6),
                  Text(
                    item.description!,
                    style: theme.hint
                        .copyWith(color: theme.textDark.withOpacity(item.isActive ? 1 : 0.45)),
                  ),
                ],
              ],
            ),
            if (onMenuClicked != null)
              BNIconButton(
                onPressed: onMenuClicked,
                icon: Assets.icons.icInfo.image(width: 24),
              ),
          ],
        ),
      ),
    );
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

  ButtonStyle get listItemStyleSelected => ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        elevation: MaterialStateProperty.all<double>(0),
        overlayColor: MaterialStateProperty.all<Color>(theme.secondaryDark),
        backgroundColor: MaterialStateProperty.all<Color>(theme.secondary),
      );

  ButtonStyle get listItemStyleDark => ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        elevation: MaterialStateProperty.all<double>(0),
        overlayColor: MaterialStateProperty.all<Color>(theme.secondaryDark),
        backgroundColor: MaterialStateProperty.all<Color>(theme.baseDark),
      );

// endregion
}
