import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/cmm/ui/dialog.dart';
import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/model/data/company.dart';
import 'package:nonoflex_alpha/model/data/document.dart';
import 'package:nonoflex_alpha/model/data/product.dart';
import 'package:nonoflex_alpha/model/data/record.dart';
import 'package:nonoflex_alpha/model/repository/company/company_repository.dart';
import 'package:nonoflex_alpha/model/repository/document/document_repository.dart';
import 'package:nonoflex_alpha/model/repository/product/product_repository.dart';

class AddDocumentViewModel extends BaseController {
  final DocumentRepository _documentRepository;
  final ProductRepository _productRepository;
  final CompanyRepository _companyRepository;

  DocumentType documentType;

  bool get isTemp =>
      documentType == DocumentType.tempOutput || documentType == DocumentType.tempInput;

  bool get isInput =>
      documentType == DocumentType.tempInput || documentType == DocumentType.tempInput;

  bool get isEditMode => currentDocument != null;

  /// 문서 업데이트 시 받는 값
  DocumentDetail? currentDocument;

  bool get isInited => companyItems.isNotEmpty && productItems.isNotEmpty;

  final selectedDate = DateTime.now().obs;

  Company? selectedCompany;

  final selectedCompanyName = ''.obs;

  /// start company List 관련 설정
  final company_searchValue = TextEditingController(); // 검색어
  final companyItems = (List<Company>.of([])).obs;

  /// end

  /// start product List 관련 설정
  final product_searchValue = TextEditingController(); // 검색어
  ProductListSortType product_sortType = ProductListSortType.productCode; // 정렬 기준
  final product_isDesc = false; // 정렬 방향
  final product_pageSize = 100; // 페이지 호출 개수
  final product_onlyActiveItem = true; //

  int pageNum = 1; // 현재 페이지
  bool isLastPage = false; // 마지막 페이지 여부

  final productItems = (List<Product>.of([])).obs;
  final selectedProductItems = (List<RecordForAddDocument>.of([])).obs;

  /// end

  AddDocumentViewModel({
    required this.documentType,
    DocumentDetail? document,
    DocumentRepository? documentRepository,
    ProductRepository? productRepository,
    CompanyRepository? companyRepository,
  })  : _documentRepository = documentRepository ?? locator.get<DocumentRepository>(),
        _productRepository = productRepository ?? locator.get<ProductRepository>(),
        _companyRepository = companyRepository ?? locator.get<CompanyRepository>() {
    currentDocument = document;
    init();
  }

  init() async {
    try {
      updateLoadingState(true);
      await getProductList();
      await getCompanyList();

      if (isEditMode) {
        // 날짜 선택
        selectedDate.value = currentDocument!.date;

        // 거래처 선택
        final currentCompanyId = currentDocument!.companyId;
        selectedCompany = companyItems.value.firstWhere((el) => el.companyId == currentCompanyId);
        if (selectedCompany != null) {
          selectedCompanyName.value = selectedCompany!.name;
        }

        // 물품 선택 목록 구성
        for (RecordOfDocument item in currentDocument!.recordList) {
          final record = RecordForAddDocument(
            item.productInfo,
            item.quantity,
            item.recordPrice,
          );
          selectedProductItems.value.add(record);
        }
      }
      updateLoadingState(false);
      update();
    } catch (e) {
      logger.e(e);
      updateLoadingState(false);
      await Get.alertDialog('알 수 없는 오류가 발생했습니다.\n다시 시도해주세요.');
      Get.back();
    }
  }

  void onClickedSave() async {
    if (selectedCompany == null) {
      Get.toast('거래처를 선택 해 주세요.');
      return;
    }
    if (selectedProductItems.value.isEmpty) {
      Get.toast('선택된 물품이 존재하지 않습니다.');
      return;
    }

    if (!await Get.confirmDialog('문서를 추가하시겠습니까?')) return;

    try {
      if (isTemp) {
        // 예정서
        // TODO: 예정서 로직
      } else {
        // 확인서

        if (isEditMode) {
          await _documentRepository.updateDocumentInfo(
            documentId: currentDocument!.documentId,
            type: currentDocument!.docType,
            date: selectedDate.value,
            companyId: selectedCompany!.companyId,
            recordList: selectedProductItems.value,
          );
          await Get.alertDialog('문서가 수정되었습니다.');
        } else {
          await _documentRepository.addDocument(
            date: selectedDate.value,
            type: documentType,
            companyId: selectedCompany!.companyId,
            recordList: selectedProductItems.value,
          );
          await Get.alertDialog('문서가 추가되었습니다.');
        }
      }
      Get.back();
    } catch (e) {
      await Get.alertDialog('문서를 추가하지 못했습니다.\n잠시 후 다시 시도해주세요.');
      logger.e(e);
    }
  }
}

extension AddDocumentViewModelDatePickerExt on AddDocumentViewModel {}

extension AddDocumentViewModelCompanyPickerExt on AddDocumentViewModel {
  // 거래처 선택
  void selectCompany(Company company) {
    selectedCompany = company;
    selectedCompanyName.value = company.name;
    update();
  }

  Future<void> getCompanyList() async {
    try {
      companyItems.value.clear();

      /// 거래처 목록은 최초에 모두 불러온 후 local에서 검색등의 동작을 처리한다.
      final list = await _companyRepository.getCompanyList(
        searchValue: company_searchValue.text,
        // sortType: CompanyListSortType.name,
        // orderType: 'desc',
        page: 1,
        size: 1000,
        onlyActive: true,
        type: isInput ? 'input' : 'output',
      );

      companyItems.value = list.items;
    } catch (e) {
      logger.e(e);
    }
  }
}

extension AddDocumentViewModelProductPickerExt on AddDocumentViewModel {
  // 물품 항목 추가
  void selectProduct(Product item, double price, int count) {
    final itemIndex =
        selectedProductItems.value.indexWhere((el) => el.product.productId == item.productId);
    if (itemIndex == -1) {
      selectedProductItems.value.add(RecordForAddDocument(item, count, price));
    } else {
      final newItem = selectedProductItems.value[itemIndex].copyWith(
        productPrice: price,
        count: count,
      );
      selectedProductItems.value[itemIndex] = newItem;
    }
  }

  // 물품 항목 제거
  void removeProduct(Product item) {
    final itemIndex =
        selectedProductItems.value.indexWhere((el) => el.product.productId == item.productId);
    selectedProductItems.value.removeAt(itemIndex);
    update();
  }

  // 물품 목록 상태 초기화
  void initProductListStatus() {
    pageNum = 1;
    isLastPage = false;
    product_searchValue.clear();
    getProductList();
  }

  // 검색어 입력 시
  void onChangedSearchValue(String value) {
    product_searchValue.text = value;
    if (value == '') {
      initProductListStatus();
    }
  }

  /// 물품 목록 불러오기
  Future<void> getProductList() async {
    try {
      if (pageNum == 1) productItems.clear();
      final productList = await _productRepository.getProductList(
        searchValue: product_searchValue.text,
        page: pageNum,
        sortType: product_sortType,
        orderType: product_isDesc ? 'desc' : 'asc',
        size: product_pageSize,
        onlyActiveItem: true,
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

  // 물품 검색 시 동작
  void onSearchProduct(String value) {
    pageNum = 1;
    isLastPage = false;
    getProductList();
  }
}
