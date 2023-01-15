import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/conf/manager/auth_manager.dart';
import 'package:nonoflex_alpha/model/data/document.dart';
import 'package:nonoflex_alpha/model/repository/document/document_repository.dart';

class DocumentListViewModel extends BaseController {
  final DocumentRepository _documentRepository;

  /// 입 출고 문서 목록
  List<DocumentDetail> documentItems = (List<DocumentDetail>.of([])).obs;

  /// start document List 관련 설정
  String searchValue = ''; // 검색어
  DocumentListSortType sortType = DocumentListSortType.date; // 정렬 기준
  bool isDesc = true; // 정렬 방향
  final int pageSize = 120; // 페이지 호출 개수
  // int year = DateTime.now().year;
  // int month = DateTime.now().month; // 호출에 반영은 하지 않는다. 자체 소팅

  int pageNum = 1; // 현재 페이지
  bool isLastPage = false; // 마지막 페이지 여부
  /// end

  /// start obs
  final selectedYear = DateTime.now().year.obs;

  final selectedMonth = DateTime.now().month.obs;

  final monthList = (List<int>.of([])).obs;

  final isSelectedDate = false.obs;

  final selectedDate = DateTime.now().obs;

  /// end

  DocumentListViewModel({DocumentRepository? documentRepository})
      : _documentRepository = documentRepository ?? locator.get<DocumentRepository>() {
    init();
  }

  init() {
    // 문서 목록 호출
    getDocumentList();
  }

  Future<void> getDocumentList({bool getAll = false}) async {
    try {
      // 토큰 정보 초기화
      await locator<AuthManager>().refreshTokenInfo();

      if (pageNum == 1) documentItems.clear();
      final documentList = await _documentRepository.getDocumentList(
        searchValue: searchValue,
        page: pageNum,
        // sortType: sortType,
        orderType: isDesc ? 'desc' : 'asc',
        size: getAll ? 1000 : pageSize,
        year: selectedYear.value,
        month: selectedMonth.value,
      );

      isLastPage = documentList.isLastPage;
      if (!isLastPage && documentList.totalPages != pageNum) {
        pageNum += 1;
      }

      if (isSelectedDate.value) {
        documentItems
            .addAll(documentList.items.where((el) => el.date.day == selectedDate.value.day));
      } else {
        documentItems.addAll(documentList.items);
      }
    } catch (e) {
      logger.e(e);
    }
  }

  // 문서 상세정보 화면으로 이동
  void goDocumentDetailInfo(Document document) async {
    await baseNavigator.goDocumentDetailPage(document.documentId);
    init();
  }

  void goAddDocument(DocumentType documentType) async {
    await baseNavigator.goAddDocumentPage(documentType);
    init();
  }

  void initListStatus() {
    isSelectedDate.value = false;
    selectedDate.value = DateTime.now();
    pageNum = 1;
    isLastPage = false;
  }
}

extension DocumentListExt on DocumentListViewModel {
  // 물품 목록 정렬기준 수정
  void updateSortType(bool isDesc, {DateTime? date}) {
    initListStatus();

    if (date != null) {
      if (selectedYear.value != date.year) {
        selectedYear.value = date.year;
        updateMonthList(date.year);
      }
      selectedMonth.value = date.month;

      this.isDesc = !isDesc;
      getDocumentList(getAll: true);

      selectedDate.value = date;
      isSelectedDate.value = true;
    } else {
      this.isDesc = !isDesc;
      getDocumentList();
    }
  }
}

extension MonthChanger on DocumentListViewModel {
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
  void onSelectedYear(int year) {
    if (year == selectedYear.value) return;
    selectedYear.value = year;
    updateMonthList(year);
    initListStatus();
    getDocumentList();
  }

  /// 월 정보 선택 시
  void onSelectedMonth(int month) {
    if (month == selectedMonth.value) {
      if (isSelectedDate.value) {
        initListStatus();
        getDocumentList();
      }
      return;
    }
    selectedMonth.value = month;
    initListStatus();
    getDocumentList();
  }

  /// 월 정보 변경 이벤트
  void onChangeMonth(bool next) {
    if (next) {
      if (selectedMonth.value == 12) return;
      selectedMonth.value += 1;
    } else {
      if (selectedMonth.value == 1) return;
      selectedMonth.value -= 1;
    }
  }
}
