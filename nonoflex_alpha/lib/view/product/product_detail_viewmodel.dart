import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/cmm/ui/dialog.dart';
import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/model/data/document.dart';
import 'package:nonoflex_alpha/model/data/product.dart';
import 'package:nonoflex_alpha/model/data/record.dart';
import 'package:nonoflex_alpha/model/repository/document/document_repository.dart';
import 'package:nonoflex_alpha/model/repository/product/product_repository.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart' as scanner;
import 'package:barcode_widget/barcode_widget.dart' as viewer;

class ProductDetailViewModel extends BaseController {
  final ProductRepository _productRepository;
  final DocumentRepository _documentRepository;

  // 물품 id
  final int productId;

  // 물품 정보
  Product? productItem;

  // 물품 입출고 기록
  final List<RecordOfProduct> records = [];

  List<RecordOfProduct> get currentRecords {
    final List<RecordOfProduct> list = [];
    list.addAll(records.where((el) => el.date.month == selectedMonth.value));

    return list;
  }

  /// start date
  // 현재 선택된 년도
  final selectedYear = DateTime.now().year.obs;

  // 현재 선택된 월
  final selectedMonth = DateTime.now().month.obs;

  final monthList = (List<int>.of([])).obs;

  /// end

  ProductDetailViewModel(
      {ProductRepository? productRepository,
      DocumentRepository? documentRepository,
      required this.productId})
      : _productRepository = productRepository ?? locator.get<ProductRepository>(),
        _documentRepository = documentRepository ?? locator.get<DocumentRepository>() {
    init();
  }

  void init() async {
    await getProductDetailInfo();
    await getRecordList();
    update();
  }

  Future<void> getProductDetailInfo() async {
    try {
      final product = await _productRepository.getProductDetailInfo(productId: productId);
      productItem = product;
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<void> getRecordList() async {
    try {
      records.clear();
      final recordList =
          await _productRepository.getRecordByProduct(productId, year: selectedYear.value);
      records.addAllIf(recordList.isNotEmpty, recordList);
    } catch (e) {
      logger.e(e.toString());
    }
  }

  // 물품 정보 수정화면으로 이동
  void goEditProductInfo() async {
    await baseNavigator.goProductEditPage(productId);
    init();
  }

  // 물품 정보 불러오기
  void updateProductInfo(Product product) async {
    try {
      await _productRepository.updateProductInfo(product);
      await getProductDetailInfo();
      update();
    } catch (e) {
      logger.e(e);
    }
  }

  // 문서 정보 불러오기
  Future<DocumentDetail?> getDocumentDetailInfo(int documentId) async {
    try {
      return await _documentRepository.getDocumentDetailInfo(documentId);
    } catch (e) {
      logger.e(e);
      return null;
    }
  }

  // 문서 상세 페이지로 이동
  Future<void> goDocumentDetailPage(int documentId) async {
    await baseNavigator.goDocumentDetailPage(documentId);
  }

  void deleteProductInfo() async {
    const alertTitle = '경고';
    const alertMessage = '삭제된 정보는 복구할 수 없습니다.\n정말 삭제하시겠습니까?\n';

    if (!await Get.confirmDialog(alertMessage, title: alertTitle)) return;

    try {
      await _productRepository.deleteProductData(productId);
      await Get.alertDialog('물품 정보가 삭제되었습니다.');
      Get.back();
    } catch (e) {
      logger.e(e);
      Get.toast('알 수 없는 오류가 발생했습니다.');
      Get.back();
    }
  }
}

extension MonthChanger on ProductDetailViewModel {
  /// 연 정보
  List<int> get selectableYearList {
    const startYear = 2022;

    List<int> yearList = [];
    for (int year = startYear; year <= DateTime.now().year; year++) {
      yearList.add(year);
    }

    return yearList;
  }

  /// 선택 가능한 월 목록 표시
  void updateMonthList(int selectedYear) {
    if (selectedYear == DateTime.now().year) {
      monthList.value.clear();
      for (int i = 0; i < DateTime.now().month; i++) {
        monthList.value.add(i + 1);
      }
      if (monthList.value.length < selectedMonth.value) {
        selectedMonth.value = monthList.value.length;
      }
    } else {
      monthList.value = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
    }
  }

  /// 연 정보 변경 이벤트
  void onSelectedYear(int year) async {
    if (year == selectedYear.value) return;
    selectedYear.value = year;
    updateMonthList(year);
    await getRecordList();
    update();
  }

  /// 월 정보 선택 시
  void onSelectedMonth(int month) {
    // if (month == selectedMonth.value) {
    //   if (isSelectedDate.value) {
    //     initListStatus();
    //     getDocumentList();
    //   }
    //   return;
    // }
    selectedMonth.value = month;
    update();
    // initListStatus();
    // getDocumentList();
  }

  /// 월 정보 변경 이벤트
  void onChangeMonth(bool next) {
    if (next) {
      if (selectedMonth.value == DateTime.now().month) return;
      selectedMonth.value += 1;
    } else {
      if (selectedMonth.value == 1) return;
      selectedMonth.value -= 1;
    }
    update();
  }
}

extension BarcodeExt on ProductDetailViewModel {
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
