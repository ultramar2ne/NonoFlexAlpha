import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/model/data/product.dart';

class ProductDetailViewModel extends BaseController {

  // 물품 wjdqh
  final Product productItem;

  final currentMonth = DateTime.now().month.obs;

  ProductDetailViewModel({
    required this.productItem
  });

  void onClickedEditProductInfo() {
    baseNavigator.goAddProductPage();
  }
}

extension MonthChanger on ProductDetailViewModel{

  /// 월 정보 변경 이벤트
  void onChangeMonth(bool next){
    if (next) {
      if (currentMonth.value == 12) return;
      currentMonth.value += 1;
    } else {
      if (currentMonth.value == 1) return;
      currentMonth.value -= 1;
    }
  }
}