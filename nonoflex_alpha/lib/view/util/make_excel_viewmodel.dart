import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/cmm/ui/dialog.dart';
import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/model/repository/document/document_repository.dart';

class MakeExcelViewModel extends BaseController {
  final DocumentRepository _documentRepository;

  // 현재 선택된 년도
  final year = DateTime.now().year.obs;

  // 현재 선택된 월
  final month = DateTime.now().month.obs;

  final monthList = (List<int>.of([])).obs;

  MakeExcelViewModel({
    DocumentRepository? documentRepository,
  }) : _documentRepository = documentRepository ?? locator.get<DocumentRepository>() {
    init();
  }

  void init() {
    updateMonthList(DateTime.now().year);
  }

  void requestMakeExcelDocument() async {
    try {
      final result = await _documentRepository.requestMakeExcelDocument(year.value, month.value);
      if (result) {
        await Get.alertDialog('요청이 정상적으로 이루어졌습니다. \n메일을 확인 해 주세요.');
      } else {
        await Get.alertDialog('요청 실패했습니다. \n다시 한번 시도 해 주세요.');
      }
    } catch (e) {
      Get.toast('오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
      logger.e(e.toString());
    }
  }
}

extension MonthChanger on MakeExcelViewModel {
  /// 연 정보
  List<int> get selectableYearList {
    const startYear = 2022;

    List<int> yearList = [];
    for (int year = startYear; year <= DateTime.now().year; year++) {
      yearList.add(year);
    }

    return yearList;
  }

  /// 연 정보 변경 이벤트
  void onSelectedYear(int selectedYear) {
    if (selectedYear == year.value) return;
    year.value = selectedYear;
    updateMonthList(selectedYear);
    update();
  }

  // /// 월 정보
  // List<int> get selectableMonthList {
  //   List<int> monthList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  //   return monthList;
  //   // if (year.value == DateTime.now().year) {
  //   //   final currentYear = DateTime.now().month;
  //   //   return monthList.sublist(0, currentYear);
  //   // } else {
  //   //   return monthList;
  //   // }
  // }

  /// 선택 가능한 월 목록 표시
  void updateMonthList(int selectedYear) {
    if (selectedYear == DateTime.now().year) {
      monthList.value.clear();
      for (int i = 0; i < DateTime.now().month; i++) {
        monthList.value.add(i + 1);
      }
      if (monthList.value.length < month.value) {
        month.value = monthList.value.length;
      }
    } else {
      monthList.value = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
    }
  }

  /// 월 정보 변경 이벤트 (selectbox type)
  void onSelectedMonth(int selectedMonth) {
    if (selectedMonth == month.value) return;
    month.value = selectedMonth;
  }

  /// 월 정보 변경 이벤트
  void onChangeMonth(bool next) {
    if (next) {
      if (month.value == 12) return;
      month.value += 1;
    } else {
      if (month.value == 1) return;
      month.value -= 1;
    }
  }
}
