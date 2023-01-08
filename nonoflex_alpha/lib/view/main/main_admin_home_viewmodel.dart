import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/model/data/notice.dart';
import 'package:nonoflex_alpha/model/repository/notice/notice_repository.dart';

class AdminHomeViewModel extends BaseController {
  NoticeRepository _noticeRepository;

  // 공지사항 정보
  Notice? noticeItem;

  AdminHomeViewModel({
    NoticeRepository? noticeRepository,
  }) : _noticeRepository = noticeRepository ?? locator.get<NoticeRepository>() {
    init();
  }

  void init() {
    getNoticeDetailInfo();
  }

  void getNoticeDetailInfo() async {
    try {
      final noticeList = await _noticeRepository.getNoticeList(
          size: 1, onlyTitle: true, sortType: NoticeListSortType.createdAt);
      noticeItem = noticeList.items.first;
      update();
    } catch (e) {
      logger.e(e.toString());
    }
  }

  void openNoticeDetail() async {
    if (noticeItem == null) return;
    await baseNavigator.goNoticeDetailPage(noticeItem!);
    init();
  }

  void goNoticeListPage() async {
    await baseNavigator.goNoticeListPage();
    init();
  }

  void goNoticeAddPage() async {
    await baseNavigator.goAddNoticePage();
    init();
  }
}
