import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/cmm/ui/dialog.dart';
import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/conf/manager/auth_manager.dart';
import 'package:nonoflex_alpha/model/data/product.dart';
import 'package:nonoflex_alpha/model/repository/product/product_repository.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ProductListViewModel extends BaseController {
  final ProductRepository _productRepository;

  /// 물품 목록
  List<Product> productItems = (List<Product>.of([])).obs;

  /// start product List 관련 설정
  final searchValue = TextEditingController(); // 검색어
  ProductListSortType sortType = ProductListSortType.productCode; // 정렬 기준
  bool isDesc = false; // 정렬 방향
  final int pageSize = 100; // 페이지 호출 개수
  final onlyActiveItem = true.obs; //

  int pageNum = 1; // 현재 페이지
  bool isLastPage = false; // 마지막 페이지 여부
  /// end

  /// 검색 바 활성화 여부
  final searchVarVisible = false.obs;

  ///
  final sortTypeValue = ProductListSortType.name.serverValue.obs;

  final isGridMode = false.obs;

  ProductListViewModel({ProductRepository? productRepository})
      : _productRepository = productRepository ?? locator.get<ProductRepository>() {
    init();
  }

  init() async {
    // 정렬 순서 불러오기
    await getProductSortingInfo();
    // 물품 목록 호출
    getProductList();
  }

  Future<void> getProductSortingInfo() async {
    final sortingInfo = await _productRepository.getProductSortInfo();

    if (sortingInfo != null) {
      isDesc = sortingInfo.isDesc;
      onlyActiveItem.value = sortingInfo.onlyActive;
      isGridMode.value = sortingInfo.isGridLayout;
      sortType = sortingInfo.sortType;
    }
  }

  Future<void> getProductList() async {
    try {
      // 토큰 정보 초기화
      await locator<AuthManager>().refreshTokenInfo();

      if (pageNum == 1) productItems.clear();
      final productList = await _productRepository.getProductList(
        searchValue: searchValue.text,
        page: pageNum,
        sortType: sortType,
        orderType: isDesc ? 'desc' : 'asc',
        size: pageSize,
        onlyActiveItem: onlyActiveItem.value,
      );

      isLastPage = productList.isLastPage;
      if (!isLastPage && productList.totalPages != pageNum) {
        pageNum += 1;
      }

      productItems.addAll(productList.items);
    } catch (e) {
      logger.e(e);
    }
  }

  void initListStatus() {
    pageNum = 1;
    isLastPage = false;
  }
}

extension ProductListExt on ProductListViewModel {
  void toggleVisibilitySearchBar() {
    searchVarVisible.value = !searchVarVisible.value;
    if (!searchVarVisible.value) {
      initListStatus();
      searchValue.clear();
      getProductList();
    }
    ;
  }

  // 검색어 입력 시
  void onChangedSearchValue(String value) {
    if (value == '') {
      onSearch(value);
    }
  }

  // 바코드로 검색
  void onSearchByBarcode() async {
    try {
      final result = await baseNavigator.goScannerPage();
      if (result.runtimeType == Barcode) {
        final code = int.tryParse((result as Barcode).code ?? '');
        if (code == null) {
          Get.toast('정보가 올바르지 않습니다.\n다시 확인해주세요.');
          return;
        }
      } else {
        return;
      }

      final productItem = await _productRepository.getProductDetailInfo(barcode: result.code);
      if (productItem == null) {
        Get.toast('물품을 찾을 수 없습니다.');
        return;
      }
      await baseNavigator.goProductDetailPage(productItem);
      initListStatus();
      getProductList();
    } catch (e) {
      logger.e(e);
      Get.toast('알 수 없는 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
    }
  }

  // 물품 목록 정렬기준 수정
  void updateSortType(bool isDesc) async {
    initListStatus();
    sortType = ProductListSortType.fromServer(sortTypeValue.value);
    this.isDesc = !isDesc;
    updateListLayout();
    getProductList();
  }

  void updateListLayout() async {
    try {
      await _productRepository.updateProductSortInfo(
        ProductSortingSet(
          isDesc: isDesc,
          onlyActive: onlyActiveItem.value,
          isGridLayout: isGridMode.value,
          sortType: sortType,
        ),
      );
    } catch (e) {
      logger.e(e);
    }
  }

  // 물품 추가 버튼 선택 시
  void onClickedAddButton() async {
    // go add product page
    await baseNavigator.goAddProductPage();
    initListStatus();
    getProductList();
  }

  // 물품 목록 선택 시 동작
  void onClcikedProductItem(Product item) async {
    // go product detail page
    await baseNavigator.goProductDetailPage(item);
    initListStatus();
    getProductList();
  }

  // 물품 검색 시 동작
  void onSearch(String value) {
    initListStatus();
    getProductList();
  }

  dispose() async {
    try {
      await _productRepository.updateProductSortInfo(
        ProductSortingSet(
          isDesc: isDesc,
          onlyActive: onlyActiveItem.value,
          isGridLayout: isGridMode.value,
          sortType: sortType,
        ),
      );
    } catch (e) {
      logger.e(e);
    }
  }
}
