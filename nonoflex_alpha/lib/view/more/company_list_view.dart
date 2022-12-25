import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/conf/ui/base_widgets.dart';
import 'package:nonoflex_alpha/conf/ui/widgets.dart';
import 'package:nonoflex_alpha/gen/assets.gen.dart';
import 'package:nonoflex_alpha/model/data/company.dart';
import 'package:nonoflex_alpha/view/more/company_list_viewmodel.dart';

class CompanyListView extends BaseGetView<CompanyListViewModel>{
  @override
  Widget drawHeader() {
    return drawSubPageTitle(
      'CompanyListViewTitle'.tr,
      button1: BNIconButton(
        onPressed: () {},
        icon: Assets.icons.icAdd.image(),
      ),
    );
  }

  @override
  Widget drawBody() {
    final companyList = controller.companyItems;
    return drawUserList(companyList);
  }
}

extension CompanyListViewExt on CompanyListView{

  /// 거래처 목록 위젯
  Widget drawUserList(List<Company>? items) {
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
        final item = list[index];
        return drawCompanyListItem(item, onClicked: () => showCompanyInfo(item));
      },
    );
  }

  /// 거래처 정보 요약
  Future<void> showCompanyInfo(Company company) {
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
                // drawUserInfo(user),
                // drawProductDetailInfo(product),
                const SizedBox(height: 8),
                Container(
                  height: 60,
                  width: Get.width,
                  // margin: const EdgeInsets.all(12),
                  child: BNColoredButton(
                    child: Text('더보기'),
                    onPressed: () {
                      // Get.back();
                      // controller.loadProductDetailInfo(product);
                    },
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );

  }
}
