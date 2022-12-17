import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/model/data/product.dart';
import 'package:nonoflex_alpha/model/data/record.dart';
import 'package:nonoflex_alpha/model/repository/product/product_repository.dart';

class ProductDetailViewModel extends BaseController {
  final ProductRepository _productRepository;

  // 물품 id
  final int productId;

  // 물품 정보
  Product? productItem;

  // 물품 입출고 기록
  final List<RecordOfProduct> records = [];

  List<RecordOfProduct> get currentRecords {
    final List<RecordOfProduct> list = [];
    list.addAll(records.where((el) => el.date.month == currentMonth.value));

    return list;
  }

  // 현재 선택된 년도
  final currentYear = DateTime.now().year.obs;

  // 현재 선택된 월
  final currentMonth = DateTime.now().month.obs;

  ProductDetailViewModel({
    ProductRepository? productRepository,
    required this.productId
  }) : _productRepository = productRepository ?? locator.get<ProductRepository>() {
    init();
  }

  void init() async {
    await getProductDetailInfo();
    await getRecordList();
    update();
  }

  Future<void> getProductDetailInfo() async {
    try{
      final product = await _productRepository.getProductDetailInfo(productId: productId);
      productItem = product;
    } catch(e){
      logger.e(e.toString());
    }
  }

  Future<void> getRecordList() async {
    try{
      final recordList = await _productRepository.getRecordByProduct(productId);
      records.addAllIf(recordList.isNotEmpty, recordList);
    } catch(e){
      logger.e(e.toString());
    }
  }

  // 물품 정보 수정화면으로 이동
  void goEditProductInfo() async {
    await baseNavigator.goAddProductPage();
  }

  // 물품 정보 불러오기

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