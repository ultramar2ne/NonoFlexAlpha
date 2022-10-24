import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/model/data/notice.dart';
import 'package:nonoflex_alpha/model/repository/notice/abs_notice_repository.dart';

class NoticeListViewModel extends BaseViewModel {
  NoticeRepository _noticeRepository;

  List<Notice> noticeList = (List<Notice>.of([])).obs;

  final listSize = 20;

  bool isLoading = true;

  String title = '안녕 세상';

  NoticeListSortType sorType = NoticeListSortType.updatedAt;

  NoticeListViewModel({NoticeRepository? noticeRepository})
      : _noticeRepository = noticeRepository ?? locator.get<NoticeRepository>() {
    init();
  }

  void init() {
    getNoticeList();
  }

  Future<void> goNoticeDetail(int noticeId) async {
    this.navigator.goNoticeDetailPage(noticeId);
  }

  Future<void> getNoticeList({int? pageNo}) async {
    final items = await _noticeRepository.getNoticeList(
      // searchValue:,
      size: listSize,
      sortType: sorType,
      // orderType:
      page: pageNo ?? 0,
      // onlyFocusedItem: ,
      // onlyTitle: ,
    );

    if (items.page == 1) {
      noticeList.clear();
    }
    noticeList.addAll(items.items);

    // noticeList items.items;
  }
}
