import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/model/data/product.dart';
import 'package:nonoflex_alpha/model/repository/product/product_repository.dart';

class ProductListViewModel extends BaseController {
  final ProductRepository _productRepository;

  /// 물품 목록
  List<Product> productItems = (List<Product>.of([])).obs;

  /// start product List 관련 설정
  String searchValue = ''; // 검색어
  ProductListSortType sortType = ProductListSortType.name; // 정렬 기준
  bool isDesc = true; // 정렬 방향
  final int pageSize = 30; // 페이지 호출 개수
  bool onlyActiveItem = false; //

  int pageNum = 1; // 현재 페이지
  bool isLastPage = false; // 마지막 페이지 여부
  /// end

  ProductListViewModel({ProductRepository? productRepository})
      : _productRepository = productRepository ?? locator.get<ProductRepository>() {
    init();
  }

  init() {
    // 물품 목록 호출
    getProductList();
  }

  Future<void> getProductList() async {
    final productList = await _productRepository.getProductList(
      searchValue: searchValue,
      page: pageNum,
      // sortType: sortType,
      // orderType:
      size: pageSize,
      onlyActiveItem: onlyActiveItem,
    );

    isLastPage = productList.isLastPage;
    if (!isLastPage && productList.totalPages != pageNum) {
      pageNum += 1;
    }

    productItems.addAll(productList.items);
    update();
  }
}

extension ProductListExt on ProductListViewModel {
  // 물품 목록 정렬기준 수정
  void updateSortType() {
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
