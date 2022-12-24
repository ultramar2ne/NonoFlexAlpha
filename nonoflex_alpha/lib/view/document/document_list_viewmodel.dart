import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/conf/locator.dart';
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
  final int pageSize = 30; // 페이지 호출 개수
  int year = DateTime.now().year;
  int month = DateTime.now().month; // 호출에 반영은 하지 않는다. 자체 소팅

  int pageNum = 1; // 현재 페이지
  bool isLastPage = false; // 마지막 페이지 여부
  /// end

  /// start obs
  final currentYear = DateTime.now().year.obs;

  final currentMonth = DateTime.now().month.obs;

  /// end

  DocumentListViewModel({DocumentRepository? documentRepository})
      : _documentRepository = documentRepository ?? locator.get<DocumentRepository>() {
    init();
  }

  init() {
    // 문서 목록 호출
    getDocumentList();
  }

  Future<void> getDocumentList() async {
    final documentList = await _documentRepository.getDocumentList(
      searchValue: searchValue,
      page: pageNum,
      // sortType: sortType,
      // orderType:
      size: pageSize,
      year: year,
      // month: month,
    );

    isLastPage = documentList.isLastPage;
    if (!isLastPage && documentList.totalPages != pageNum) {
      pageNum += 1;
    }

    documentItems.addAll(documentList.items);
    update();
  }

  // 문서 상세정보 화면으로 이동
  void goDocumentDetailInfo(Document document) async {
    await baseNavigator.goDocumentDetailPage(document.documentId);
  }


}

extension MonthChanger on DocumentListViewModel {
  /// 연 정보
  List<int> get selectableYearList {
    const startYear = 2021;

    List<int> yearList = [];
    for (int year = startYear; year <= DateTime.now().year; year++) {
      yearList.add(year);
    }

    return yearList;
  }

  /// 연 정보 변경 이벤트
  void onSelectedYear(int selectedYear) {
    if (selectedYear == currentYear.value) return;
    currentYear.value = selectedYear;
  }

  /// 월 정보 변경 이벤트
  void onChangeMonth(bool next) {
    if (next) {
      if (currentMonth.value == 12) return;
      currentMonth.value += 1;
    } else {
      if (currentMonth.value == 1) return;
      currentMonth.value -= 1;
    }
  }
}
