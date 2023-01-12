import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/cmm/ui/dialog.dart';
import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/model/data/product.dart';
import 'package:nonoflex_alpha/model/repository/product/product_repository.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart' as scanner;
import 'package:barcode_widget/barcode_widget.dart' as viewer;

class BarcodeSettingViewModel extends BaseController {
  final ProductRepository _productRepository;

  /// 물품 목록
  final productItems = (List<Product>.of([])).obs;

  /// start product List 관련 설정
  String searchValue = ''; // 검색어
  ProductListSortType sortType = ProductListSortType.name; // 정렬 기준
  bool isDesc = true; // 정렬 방향
  final int pageSize = 30; // 페이지 호출 개수
  bool onlyActiveItem = false; //

  int pageNum = 1; // 현재 페이지
  bool isLastPage = false; // 마지막 페이지 여부
/// end

  BarcodeSettingViewModel({ProductRepository? productRepository})
      : _productRepository = productRepository ?? locator.get<ProductRepository>() {
    init();
  }

  init() {
    // 물품 목록 호출
    getProductList();
  }

  Future<void> getProductList() async {
    productItems.clear();
    final productList = await _productRepository.getProductList(
      searchValue: searchValue,
      page: pageNum,
      // sortType: sortType,
      // orderType:
      size: 1000,
      onlyActiveItem: onlyActiveItem,
    );

    // isLastPage = productList.isLastPage;
    // if (!isLastPage && productList.totalPages != pageNum) {
    //   pageNum += 1;
    // }

    productItems.addAll(productList.items);
  }

  // 물품 정보 불러오기
  void updateProductInfo(Product product) async {
    try {
      await _productRepository.updateProductInfo(product);
      await getProductList();
      Get.toast('바코드 정보가 수정되었습니다.');
      update();
    } catch (e) {
      Get.toast('알 수 없는 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
      logger.e(e);
      update();
    }
  }
}

extension BarcodeExt on BarcodeSettingViewModel {
  viewer.Barcode? fromScanner(scanner.BarcodeFormat scannerformat) {
    switch (scannerformat) {
      case scanner.BarcodeFormat.aztec:
        return viewer.Barcode.aztec();
      case scanner.BarcodeFormat.codabar:
        return viewer.Barcode.codabar();
      case scanner.BarcodeFormat.code39:
        return viewer.Barcode.code39();
      case scanner.BarcodeFormat.code93:
        return viewer.Barcode.code93();
      case scanner.BarcodeFormat.code128:
        return viewer.Barcode.code128();
      case scanner.BarcodeFormat.dataMatrix:
        return viewer.Barcode.dataMatrix();
      case scanner.BarcodeFormat.ean8:
        return viewer.Barcode.ean8();
      case scanner.BarcodeFormat.ean13:
        return viewer.Barcode.ean13();
      case scanner.BarcodeFormat.itf:
        return viewer.Barcode.itf();
      case scanner.BarcodeFormat.pdf417:
        return viewer.Barcode.pdf417();
      case scanner.BarcodeFormat.qrcode:
        return viewer.Barcode.qrCode();
      case scanner.BarcodeFormat.upcA:
        return viewer.Barcode.upcA();
      case scanner.BarcodeFormat.upcE:
        return viewer.Barcode.upcE();
      case scanner.BarcodeFormat.upcEanExtension:
        return viewer.Barcode.upcE();

      case scanner.BarcodeFormat.maxicode:
      case scanner.BarcodeFormat.rss14:
      case scanner.BarcodeFormat.rssExpanded:
      case scanner.BarcodeFormat.unknown:
        return null;
    }
  }
}