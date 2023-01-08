import 'package:get/get.dart';
import 'package:nonoflex_alpha/cmm/base.dart';
import 'package:nonoflex_alpha/cmm/ui/dialog.dart';
import 'package:nonoflex_alpha/conf/locator.dart';
import 'package:nonoflex_alpha/model/data/notice.dart';
import 'package:nonoflex_alpha/model/repository/notice/notice_repository.dart';

class NoticeDetailViewModel extends BaseController {
  NoticeRepository _noticeRepository;

  // 공지사항 ID
  final int noticeId;

  // 공지사항 정보
  Notice? noticeItem;

  NoticeDetailViewModel({
    NoticeRepository? noticeRepository,
    required this.noticeId,
  }) : _noticeRepository = noticeRepository ?? locator.get<NoticeRepository>() {
    init();
  }

  void init() {
    getNoticeDetailInfo();
  }

  void getNoticeDetailInfo() async {
    try {
      final notice = await _noticeRepository.getNoticeDetailInfo(noticeId);
      noticeItem = notice;
      update();
    } catch (e) {
      logger.e(e.toString());
    }
  }

  void editNotice() async {
    await baseNavigator.goEditNoticePage(noticeId);
    init();
  }

  void deleteNotice() async {
    if (!await Get.alert('정말로 삭제하시겠습니까?')) return;

    try {
      await _noticeRepository.deleteNotice(noticeId);
      Get.back();
    } catch (e) {
      logger.e(e.toString());
    }
  }
}
