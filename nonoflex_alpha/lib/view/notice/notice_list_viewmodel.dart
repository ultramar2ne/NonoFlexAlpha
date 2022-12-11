import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/model/data/notice.dart';
import 'package:nonoflex_alpha/model/repository/notice/notice_repository.dart';

class NoticeListViewModel extends BaseController {
  NoticeRepository _noticeRepository;

  List<Notice> noticeItems = (List<Notice>.of([])).obs;

  /// start notie List 관련 설정
  String searchValue = ''; // 검색어
  NoticeListSortType sortType = NoticeListSortType.updatedAt; // 정렬 기준
  bool isDesc = false; // 정렬 방향
  int pageNum = 1; // 현재 페이지
  final int pageSize = 30; // 페이지 호출 개수
  bool isLastPage = false; // 마지막 페이지 여부
  bool onlyFocusedItem = false; //
  /// end

  NoticeListViewModel({NoticeRepository? noticeRepository})
      : _noticeRepository = noticeRepository ?? locator.get<NoticeRepository>() {
    init();
  }

  void init() {
    getNoticeList();
  }

  Future<void> goNoticeDetail(int noticeId) async {
    this.baseNavigator.goNoticeDetailPage(noticeId);
  }

  void onClickedAddNotice() async {
    await baseNavigator.goAddNoticePage();
    for (int i = 1; i <= pageNum; i++) {
      await getNoticeList(pageNo: i);
    }
    // updateLoadingState(false);
  }

  void onClickedNoticeItem(Notice notice) async {
    await baseNavigator.goNoticeDetailPage(notice.noticeId);
    for (int i = 1; i <= pageNum; i++) {
      await getNoticeList(pageNo: i);
    }
    updateLoadingState(false);
  }

  Future<void> getNoticeList({int? pageNo}) async {
    try {
      updateLoadingState(true);
      if (pageNo != 1 && isLastPage) return;
      final items = await _noticeRepository.getNoticeList(
        searchValue: searchValue,
        size: pageSize,
        sortType: sortType,
        orderType: isDesc ? 'desc' : 'asc',
        page: pageNo ?? 1,
        onlyFocusedItem: onlyFocusedItem,
        // onlyTitle: ,
      );

      if (items.page == 1) {
        noticeItems.clear();
      }
      noticeItems.addAll(items.items);
      isLastPage = items.isLastPage;
      updateLoadingState(false);
    } catch (e) {
      updateLoadingState(false);
      // Get.dialog(widget)ㅌ/
    }
  }
}
