import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/model/data/product.dart';
import 'package:nonoflex_alpha/model/repository/product/product_repository.dart';

class ProductListViewModel extends BaseController {
  final ProductRepository _productRepository;

  /// 물품 목록
  List<Product> productItems = (List<Product>.of([])).obs;

  /// 검색어
  String searchValue = '';

  ProductListViewModel({ProductRepository? productRepository})
      : _productRepository = productRepository ?? locator.get<ProductRepository>() {
    init();
  }

  init() {
    // 물품 목록 호출
    getProductList();
  }

  Future<void> getProductList() async {
    // _productRepository.getProductList();
    final productList = await _productRepository.getProductList();
    productItems.addAll(productList.items);

  }
}

extension ProductListExt on ProductListViewModel {
  // 물품 목록 정렬기준 수정
  void updateSortType(){
    // 물품 정렬 기준 수정,
    // 수정된 정보 local에 저장
  }

  // 물품 추가 버튼 선택 시
  void onClickedAddButton() async {
    // go add product page
    await baseNavigator.goAddProductPage();
  }

  // 물품 목록 선택 시 동작
  void onClcikedProductItem(Product item) async {
    // go product detail page
    await baseNavigator.goProductDetailPage(item);
  }

  // 물품 검색 시 동작
  void onSearch() {}
}
